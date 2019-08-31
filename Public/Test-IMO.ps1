function Test-IMO {
    [alias('Test-ImoAD')]
    [CmdletBinding()]
    param(
        [switch] $ReturnResults,
        [string[]] $ExludeDomains,
        [string[]] $ExludeDomainControllers,
        [switch] $ShowErrors,
        [switch] $ExtendedResults
    )
    $Script:Reporting = [ordered] @{

    }

    $global:ProgressPreference = 'SilentlyContinue'
    $global:ErrorActionPreference = 'Stop'
    $Script:TestResults = [System.Collections.Generic.List[PSCustomObject]]::new()
    $Script:TestimoConfiguration.Debug.ShowErrors = $ShowErrors
    $Script:TestimoConfiguration.Exclusions.Domains = $ExludeDomains
    $Script:TestimoConfiguration.Exclusions.DomainControllers = $ExludeDomainControllers

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
                    Start-Testing -Scope 'DomainControllers' -Domain $Domain -DomainController $DC.Name -IsPDC $DC.IsPDC -DomainInformation $DomainInformation -ForestInformation ForestInformation
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