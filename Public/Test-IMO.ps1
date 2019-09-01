function Test-IMO {
    [alias('Test-ImoAD')]
    [CmdletBinding()]
    param(
        [string[]] $Sources,
        [string[]] $ExcludeSources,
        [string[]] $ExcludeDomains,
        [string[]] $ExcludeDomainControllers,
        [switch] $ReturnResults,
        [switch] $ShowErrors,
        [switch] $ExtendedResults
    )
    $Script:Reporting = [ordered] @{

    }

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
            $DomainInformation = Get-TestimoDomain -Domain $Domain

            Start-Testing -Scope 'Domain' -Domain $Domain -DomainInformation $DomainInformation -ForestInformation $ForestInformation {
                # Tests related to DOMAIN CONTROLLERS
                $DomainControllers = Get-TestimoDomainControllers -Domain $Domain
                foreach ($DC in $DomainControllers) {
                    Start-Testing -Scope 'DomainControllers' -Domain $Domain -DomainController $DC.Name -IsPDC $DC.IsPDC -DomainInformation $DomainInformation -ForestInformation $ForestInformation
                }
            }
        }
    }
    if ($ExtendedResults) {
        @{
            Results    = $Script:TestResults
            ReportData = $Script:Reporting
        }
    } else {
        if ($ReturnResults) {
            $Script:TestResults
        }
    }
}

$ArgumentCompleterForestTests = {
    param($commandName, $parameterName, $wordToComplete, $commandAst, $fakeBoundParameters)

    ($TestimoConfiguration.Forest.Keys)
}
$ArgumentCompleterDomainTests = {
    param($commandName, $parameterName, $wordToComplete, $commandAst, $fakeBoundParameters)

    ($TestimoConfiguration.Domain.Keys)
}
$ArgumentCompleterDomainControllerTests = {
    param($commandName, $parameterName, $wordToComplete, $commandAst, $fakeBoundParameters)

    ($TestimoConfiguration.DomainControllers.Keys)
}

$New = {
    param($commandName, $parameterName, $wordToComplete, $commandAst, $fakeBoundParameters)

    $ForestKeys = $TestimoConfiguration.Domain.Keys
    $DomainKeys = $TestimoConfiguration.Forest.Keys
    $DomainControllerKeys = $TestimoConfiguration.DomainControllers.Keys

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
Register-ArgumentCompleter -CommandName Test-IMO -ParameterName Sources -ScriptBlock $New
Register-ArgumentCompleter -CommandName Test-IMO -ParameterName ExcludeSources -ScriptBlock $New

<#
Register-ArgumentCompleter -CommandName Test-IMO -ParameterName ForestTests -ScriptBlock $ArgumentCompleterForestTests
Register-ArgumentCompleter -CommandName Test-IMO -ParameterName DomainTests -ScriptBlock $ArgumentCompleterDomainTests
Register-ArgumentCompleter -CommandName Test-IMO -ParameterName DomainControllerTests -ScriptBlock $ArgumentCompleterDomainControllerTests
Register-ArgumentCompleter -CommandName Test-IMO -ParameterName ExcludeForestTests -ScriptBlock $ArgumentCompleterForestTests
Register-ArgumentCompleter -CommandName Test-IMO -ParameterName ExcludeDomainTests -ScriptBlock $ArgumentCompleterDomainTests
Register-ArgumentCompleter -CommandName Test-IMO -ParameterName ExcludeDomainControllerTests -ScriptBlock $ArgumentCompleterDomainControllerTests





#$ForestKeys

function Set-Testimo {
    [CmdletBinding()]
    param(
        [string] $Source,
        [string] $Tests
    )
}


#>


#Register-ArgumentCompleter -CommandName 'Set-Testimo' -ParameterName Source -ScriptBlock $ArgumentCompleterForestTests
#Register-ArgumentCompleter -CommandName 'Set-Testimo' -ParameterName Tests -ScriptBlock $New

<#

Register-ArgumentCompleter -ParameterName Source -ScriptBlock {
    param($commandName, $parameterName, $wordToComplete, $commandAst, $fakeBoundParameter)

    $FoodNameFilter = $fakeBoundParameter.FoodName

    $TestimoConfiguration.Forest.Keys | Where-Object { $_ -like "${wordToComplete}*" } | Where-Object {
        $Foods.$_ -like "${FoodNameFilter}*"
    } | ForEach-Object {
        New-Object System.Management.Automation.CompletionResult (
            $_,
            $_,
            'ParameterValue',
            $_
        )
    }
}

Register-ArgumentCompleter -ParameterName Tests -ScriptBlock {
    param($commandName, $parameterName, $wordToComplete, $commandAst, $fakeBoundParameter)

    $TypeFilter = $fakeBoundParameter.FoodType

    $Foods.Keys | Where-Object { $_ -like "${TypeFilter}*" } | ForEach-Object { $Foods.$_ | Where-Object { $_ -like "${wordToComplete}*" } } | Sort-Object -Unique | ForEach-Object {
        New-Object System.Management.Automation.CompletionResult (
            $_,
            $_,
            'ParameterValue',
            $_
        )
    }
}
#>