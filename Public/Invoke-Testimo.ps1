function Invoke-Testimo {
    [alias('Test-ImoAD', 'Test-IMO')]
    [CmdletBinding()]
    param(
        [ValidateScript(
            {
                $_ -in (& $SourcesAutoCompleter)
            }
        )]
        [alias('Type')][string[]] $Sources,
        [ValidateScript(
            {
                $_ -in (& $SourcesAutoCompleter)
            }
        )] [alias('ExludeType')] [string[]] $ExcludeSources,
        [string[]] $ExcludeDomains,
        [string[]] $ExcludeDomainControllers,
        [string[]] $IncludeDomains,
        [string[]] $IncludeDomainControllers,
        # this requires rebuild of all tests
        [string] $ForestName,
        [alias('ReturnResults')][switch] $PassThru,
        [switch] $ShowErrors,
        [switch] $ExtendedResults,
        [Object] $Configuration,
        [alias('ReportPath')][string] $FilePath,
        [Parameter(DontShow)][switch] $ShowReport,
        [switch] $HideHTML,
        [alias('HideSolution')][switch] $HideSteps,
        [alias('AlwaysShowSolution')][switch] $AlwaysShowSteps,
        [switch] $SkipRODC,
        [switch] $Online,
        [string[]] $ExternalTests
    )
    if (-not $Script:DefaultSources) {
        $Script:DefaultSources = Get-TestimoSources -Enabled -SourcesOnly
    } else {
        Set-TestsStatus -Sources $Script:DefaultSources
    }
    if ($ShowReport) {
        Write-Warning "Invoke-Testimo - Paramter ShowReport is deprecated. By default HTML report will open up after running Testimo. If you want to prevent that, use HideHTML switch instead. This message and parameter will be removed in future releases."
    }

    $Script:Reporting = [ordered] @{ }
    $Script:Reporting['Version'] = ''
    $Script:Reporting['Errors'] = [System.Collections.Generic.List[PSCustomObject]]::new()
    $Script:Reporting['Results'] = $null
    $Script:Reporting['Summary'] = [ordered] @{ }
    $Script:Reporting['Forest'] = [ordered] @{ }
    $Script:Reporting['Forest']['Summary'] = $null
    $Script:Reporting['Forest']['Tests'] = [ordered] @{ }
    $Script:Reporting['Domains'] = [ordered] @{ }
    $Script:Reporting['BySource'] = [ordered] @{}

    $TestimoVersion = Get-Command -Name 'Invoke-Testimo' -ErrorAction SilentlyContinue
    $ProgressPreference = 'SilentlyContinue'
    [Array] $GitHubReleases = (Get-GitHubLatestRelease -Url "https://api.github.com/repos/evotecit/Testimo/releases")
    $ProgressPreference = 'Continue'
    $LatestVersion = $GitHubReleases[0]

    if (-not $LatestVersion.Errors) {
        if ($TestimoVersion.Version -eq $LatestVersion.Version) {
            $Script:Reporting['Version'] = "Current/Latest: $($LatestVersion.Version) at $($LatestVersion.PublishDate)"
        } elseif ($TestimoVersion.Version -lt $LatestVersion.Version) {
            $Script:Reporting['Version'] = "Current: $($TestimoVersion.Version), Published: $($LatestVersion.Version) at $($LatestVersion.PublishDate). Update?"
        } elseif ($TestimoVersion.Version -gt $LatestVersion.Version) {
            $Script:Reporting['Version'] = "Current: $($TestimoVersion.Version), Published: $($LatestVersion.Version) at $($LatestVersion.PublishDate). Lucky you!"
        }
    } else {
        $Script:Reporting['Version'] = "Current: $($TestimoVersion.Version)"
    }
    Out-Informative -OverrideTitle 'Testimo' -Text 'Version' -Level 0 -Status $null -ExtendedValue $Script:Reporting['Version']

    Import-TestimoConfiguration -Configuration $Configuration

    $global:ProgressPreference = 'SilentlyContinue'
    $global:ErrorActionPreference = 'Stop'
    $Script:TestResults = [System.Collections.Generic.List[PSCustomObject]]::new()
    $Script:TestimoConfiguration.Debug.ShowErrors = $ShowErrors
    $Script:TestimoConfiguration.Exclusions.Domains = $ExcludeDomains
    $Script:TestimoConfiguration.Exclusions.DomainControllers = $ExcludeDomainControllers
    $Script:TestimoConfiguration.Inclusions.Domains = $IncludeDomains
    $Script:TestimoConfiguration.Inclusions.DomainControllers = $IncludeDomainControllers

    if (-not $Sources) {
        $Sources = $Script:DefaultSources
    }
    Set-TestsStatus -Sources $Sources -ExcludeSources $ExcludeSources

    if ($Script:TestimoConfiguration.Inclusions.Domains) {
        Out-Informative -Text 'Only following Domains will be scanned' -Level 0 -Status $null -ExtendedValue ($Script:TestimoConfiguration.Inclusions.Domains -join ', ')
    }
    if ( $Script:TestimoConfiguration.Inclusions.DomainControllers) {
        Out-Informative -Text 'Only following Domain Controllers will be scanned' -Level 0 -Status $null -ExtendedValue ($Script:TestimoConfiguration.Inclusions.DomainControllers -join ', ')
    }
    # We only exclude if inclusion is not specified for Domains
    if ($Script:TestimoConfiguration.Exclusions.Domains -and -not $Script:TestimoConfiguration.Inclusions.Domains) {
        Out-Informative -Text 'Following Domains will be ignored' -Level 0 -Status $null -ExtendedValue ($Script:TestimoConfiguration.Exclusions.Domains -join ', ')
    }
    # We only exclude if inclusion is not specified for Domain Controllers
    if ( $Script:TestimoConfiguration.Exclusions.DomainControllers -and -not $Script:TestimoConfiguration.Inclusions.DomainControllers) {
        Out-Informative -Text 'Following Domain Controllers will be ignored' -Level 0 -Status $null -ExtendedValue ($Script:TestimoConfiguration.Exclusions.DomainControllers -join ', ')
    }

    $ForestDetails = Get-WinADForestDetails -WarningVariable ForestWarning -WarningAction SilentlyContinue -Forest $ForestName -ExcludeDomains $ExcludeDomains -IncludeDomains $IncludeDomains -IncludeDomainControllers $IncludeDomainControllers -ExcludeDomainControllers $ExcludeDomainControllers -SkipRODC:$SkipRODC -Extended
    if ($ForestDetails) {
        # Tests related to FOREST
        $null = Start-Testing -Scope 'Forest' -ForestInformation $ForestDetails.Forest -ForestDetails $ForestDetails -SkipRODC:$SkipRODC {
            # Tests related to DOMAIN
            foreach ($Domain in $ForestDetails.Domains) {
                $Script:Reporting['Domains'][$Domain] = [ordered] @{ }
                $Script:Reporting['Domains'][$Domain]['Summary'] = [ordered] @{ }
                $Script:Reporting['Domains'][$Domain]['Tests'] = [ordered] @{ }
                $Script:Reporting['Domains'][$Domain]['DomainControllers'] = [ordered] @{ }

                if ($ForestDetails['DomainsExtended']["$Domain"]) {
                    Start-Testing -Scope 'Domain' -Domain $Domain -DomainInformation $ForestDetails['DomainsExtended']["$Domain"] -ForestInformation $ForestDetails.Forest -ForestDetails $ForestDetails -SkipRODC:$SkipRODC {
                        # Tests related to DOMAIN CONTROLLERS
                        if (Get-TestimoSourcesStatus -Scope 'DC') {
                            foreach ($DC in $ForestDetails['DomainDomainControllers'][$Domain]) {
                                $Script:Reporting['Domains'][$Domain]['DomainControllers'][$DC.HostName] = [ordered] @{ }
                                $Script:Reporting['Domains'][$Domain]['DomainControllers'][$DC.HostName]['Summary'] = [ordered] @{ }
                                $Script:Reporting['Domains'][$Domain]['DomainControllers'][$DC.HostName]['Tests'] = [ordered] @{ }
                                Start-Testing -Scope 'DC' -Domain $Domain -DomainController $DC.HostName -IsPDC $DC.IsPDC -DomainInformation $ForestDetails['DomainsExtended']["$Domain"] -ForestInformation $ForestDetails.Forest -ForestDetails $ForestDetails
                            }
                        }
                    }
                    #}
                }
            }
        }
    } else {
        Write-Color -Text '[e]', '[Testimo] ', "Forest Information couldn't be gathered. ", "[", "Error", "] ", "[", $ForestWarning, "]" -Color Red, DarkGray, Yellow, Cyan, DarkGray, Cyan, Cyan, Red, Cyan
    }
    $Script:Reporting['Results'] = $Script:TestResults

    if ($PassThru -and $ExtendedResults) {
        $Script:Reporting
    } else {
        if ($PassThru) {
            $Script:TestResults
        }
    }
    if (-not $FilePath) {
        $FilePath = Get-FileName -Extension 'html' -Temporary
    }
    $Time = Start-TimeLog
    Out-Informative -OverrideTitle 'Testimo' -Text 'HTML Report Generation Started' -Level 0 -Status $null #-ExtendedValue $Script:Reporting['Version']
    Start-TestimoReport -FilePath $FilePath -Online:$Online -ShowHTML:(-not $HideHTML.IsPresent) -TestResults $Script:Reporting -HideSteps:$HideSteps -AlwaysShowSteps:$AlwaysShowSteps
    $TimeEnd = Stop-TimeLog -Time $Time
    Out-Informative -OverrideTitle 'Testimo' -Text "HTML Report Saved to $FilePath" -Level 0 -Status $null -ExtendedValue $TimeEnd
}

[scriptblock] $SourcesAutoCompleter = {
    param($commandName, $parameterName, $wordToComplete, $commandAst, $fakeBoundParameters)
    $Script:TestimoConfiguration.ActiveDirectory.Keys | Sort-Object | Where-Object { $_ -like "*$wordToComplete*" }
}
Register-ArgumentCompleter -CommandName Invoke-Testimo -ParameterName Sources -ScriptBlock $SourcesAutoCompleter
Register-ArgumentCompleter -CommandName Invoke-Testimo -ParameterName ExcludeSources -ScriptBlock $SourcesAutoCompleter
Register-ArgumentCompleter -CommandName Get-TestimoSources -ParameterName Sources -ScriptBlock $SourcesAutoCompleter