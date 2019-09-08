function Invoke-Testimo {
    [alias('Test-ImoAD', 'Test-IMO')]
    [CmdletBinding()]
    param(
        [ValidateScript(
            {
                $_ -in (& $SourcesAutoCompleter)
            }
        )]
        [string[]] $Sources,
        [ValidateScript(
            {
                $_ -in (& $SourcesAutoCompleter)
            }
        )] [string[]] $ExcludeSources,
        [string[]] $ExcludeDomains,
        [string[]] $ExcludeDomainControllers,
        [switch] $ReturnResults,
        [switch] $ShowErrors,
        [switch] $ExtendedResults,
        [Object] $Configuration,
        [string] $ReportPath,
        [switch] $ShowReport
    )
    $Script:Reporting = [ordered] @{ }
    $Script:Reporting['Results'] = $null
    $Script:Reporting['Summary'] = $null
    $Script:Reporting['Forest'] = [ordered] @{ }
    $Script:Reporting['Forest']['Summary'] = $null
    $Script:Reporting['Forest']['Tests'] = [ordered] @{ }
    $Script:Reporting['Domains'] = [ordered] @{ }

    Import-TestimoConfiguration -Configuration $Configuration

    $global:ProgressPreference = 'SilentlyContinue'
    $global:ErrorActionPreference = 'Stop'
    $Script:TestResults = [System.Collections.Generic.List[PSCustomObject]]::new()
    $Script:TestimoConfiguration.Debug.ShowErrors = $ShowErrors
    $Script:TestimoConfiguration.Exclusions.Domains = $ExcludeDomains
    $Script:TestimoConfiguration.Exclusions.DomainControllers = $ExcludeDomainControllers

    Set-TestsStatus -Sources $Sources -ExcludeSources $ExcludeSources

    if ($Script:TestimoConfiguration.Exclusions.Domains) {
        Out-Begin -Text 'Following Domains will be ignored' -Level 0
        Out-Status -Status $null -Domain $Domain -DomainController $DomainController -ExtendedValue ($Script:TestimoConfiguration.Exclusions.Domains -join ', ')
    }
    if ( $Script:TestimoConfiguration.Exclusions.DomainControllers) {
        Out-Begin -Text 'Following Domain Controllers will be ignored' -Level 0
        Out-Status -Status $null -Domain $Domain -DomainController $DomainController -ExtendedValue ($Script:TestimoConfiguration.Exclusions.DomainControllers -join ', ')
    }

    $ForestInformation = Get-TestimoForest

    # Tests related to FOREST
    $null = Start-Testing -Scope 'Forest' -ForestInformation $ForestInformation {
        # Tests related to DOMAIN
        foreach ($Domain in $ForestInformation.Domains) {
            $Script:Reporting['Domains'][$Domain] = [ordered] @{ }
            $Script:Reporting['Domains'][$Domain]['Summary'] = $null
            $Script:Reporting['Domains'][$Domain]['Tests'] = [ordered] @{ }
            $Script:Reporting['Domains'][$Domain]['DomainControllers'] = [ordered] @{ }
            $DomainInformation = Get-TestimoDomain -Domain $Domain

            Start-Testing -Scope 'Domain' -Domain $Domain -DomainInformation $DomainInformation -ForestInformation $ForestInformation {
                # Tests related to DOMAIN CONTROLLERS
                $DomainControllers = Get-TestimoDomainControllers -Domain $Domain
                foreach ($DC in $DomainControllers) {
                    $Script:Reporting['Domains'][$Domain]['DomainControllers'][$DC.Name] = [ordered] @{ }
                    $Script:Reporting['Domains'][$Domain]['DomainControllers'][$DC.Name]['Summary'] = $null
                    $Script:Reporting['Domains'][$Domain]['DomainControllers'][$DC.Name]['Tests'] = [ordered] @{ }
                    Start-Testing -Scope 'DomainControllers' -Domain $Domain -DomainController $DC.Name -IsPDC $DC.IsPDC -DomainInformation $DomainInformation -ForestInformation $ForestInformation
                }
            }
        }
    }
    $Script:Reporting['Results'] = $Script:TestResults

    if ($ReturnResults -and $ExtendedResults) {
        $Script:Reporting
    } else {
        if ($ReturnResults) {
            $Script:TestResults
        }
    }
    if ($ReportPath -or $ShowReport) {
        Start-TestimoReport -FilePath $ReportPath -UseCssLinks:$true -UseJavaScriptLinks:$true -ShowHTML:$ShowReport -TestResults $Script:Reporting
    }
}

[scriptblock] $SourcesAutoCompleter = {
    param($commandName, $parameterName, $wordToComplete, $commandAst, $fakeBoundParameters)

    $ForestKeys = $Script:TestimoConfiguration.Forest.Keys
    $DomainKeys = $Script:TestimoConfiguration.Domain.Keys
    $DomainControllerKeys = $Script:TestimoConfiguration.DomainControllers.Keys

    $TestSources = @(
        foreach ($Key in $ForestKeys) {
            "Forest$Key"
        }
        foreach ($Key in $DomainKeys) {
            "Domain$Key"
        }
        foreach ($Key in $DomainControllerKeys) {
            "DC$Key"
        }
    )
    $TestSources | Sort-Object
}
Register-ArgumentCompleter -CommandName Invoke-Testimo -ParameterName Sources -ScriptBlock $SourcesAutoCompleter
Register-ArgumentCompleter -CommandName Invoke-Testimo -ParameterName ExcludeSources -ScriptBlock $SourcesAutoCompleter