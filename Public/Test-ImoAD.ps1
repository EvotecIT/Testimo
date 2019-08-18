function Test-ImoAD {
    [CmdletBinding()]
    param(
        [switch] $ReturnResults
    )
    $global:ProgressPreference = 'SilentlyContinue'
    $Script:TestResults = [System.Collections.Generic.List[PSCustomObject]]::new()

    $Forest = & $Script:SBForest

    # Tests related to FOREST
    $null = Start-Testing -Scope 'Forest' {
        # Tests related to DOMAIN
        foreach ($Domain in $Forest.Domains) {
            $Domain = $Domain.ToLower()
            $null = & $Script:SBDomain -Domain $Domain

            Start-Testing -Scope 'Domain' -Domain $Domain {
                # Tests related to DOMAIN CONTROLLERS
                $DomainControllers = & $Script:SBDomainControllers -Domain $Domain
                foreach ($DomainController in $DomainControllers) {
                    $DomainControllerHostName = $($DomainController.HostName).ToLower()
                    Start-Testing -Scope 'DomainControllers' -Domain $Domain -DomainController $DomainControllerHostName
                }
            }
        }
    }
    if ($ReturnResults) {
        $Script:TestResults
    }
}