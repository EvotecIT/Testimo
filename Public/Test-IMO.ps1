function Test-IMO {
    [alias('Test-ImoAD')]
    [CmdletBinding()]
    param(
        [switch] $ReturnResults,
        [string[]] $ExludeDomains,
        [string[]] $ExludeDomainControllers,
        [switch] $ShowErrors
    )
    $global:ProgressPreference = 'SilentlyContinue'
    $Script:TestResults = [System.Collections.Generic.List[PSCustomObject]]::new()
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

    $Domains = & $Script:SBForest

    # Tests related to FOREST
    $null = Start-Testing -Scope 'Forest' {
        # Tests related to DOMAIN
        foreach ($Domain in $Domains) {
            #$null = & $Script:SBDomain -Domain $Domain

            Start-Testing -Scope 'Domain' -Domain $Domain {
                # Tests related to DOMAIN CONTROLLERS
                $DomainControllers = & $Script:SBDomainControllers -Domain $Domain
                foreach ($DomainController in $DomainControllers) {
                    Start-Testing -Scope 'DomainControllers' -Domain $Domain -DomainController $DomainController
                }
            }
        }
    }
    if ($ReturnResults) {
        $Script:TestResults
    }
}

