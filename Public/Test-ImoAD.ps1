function Test-ImoAD {
    [CmdletBinding()]
    param(
        [switch] $ReturnResults
    )
    $Time = Start-TimeLog
    $Script:TestResults = [System.Collections.Generic.List[PSCustomObject]]::new()

    # Imports all commands / including private ones from PSWinDocumentation.AD
    $ADModule = Import-Module PSWinDocumentation.AD -PassThru

    <#
    $Forest = & $Script:SBForest

    & $Script:SBForestOptionalFeatures
    & $Script:SBForestReplication
    & $Script:SBForestLastBackup

    foreach ($Domain in $Forest.Domains) {
        & $Script:SBDomainPasswordComplexity -Domain $Domain
        & $Script:SBDomainTrusts -Domain $Domain

        $DomainInformation = & $Script:SBDomainInformation -Domain $Domain

        $DomainControllers = & $Script:SBDomainControllers -Domain $Domain

        foreach ($_ in $DomainControllers) {
            & $Script:SBDomainControllersLDAP -DomainController $_
            & $Script:SBDomainControllersPing -DomainController $_
            & $Script:SBDomainControllersPort53 -DomainController $_
            & $Script:SBDomainControllersServices -DomainController $_
            & $Script:SBDomainControllersRespondsPS -DomainController $_
        }
    }
    #>

    $Forest = & $Script:SBForest

    # Tests related to FOREST
    Start-Testing -Scope 'Forest' #-Level 1
    # Tests related to DOMAIN
    foreach ($Domain in $Forest.Domains) {

        $null = & $Script:SBDomain -Domain $Domain

        Start-Testing -Scope 'Domain' -Domain $Domain -DomainController $DomainController
        # Tests related to DOMAIN CONTROLLERS
        $DomainControllers = & $Script:SBDomainControllers -Domain $Domain
        foreach ($DomainController in $DomainControllers) {
            Start-Testing -Scope 'DomainControllers' -Domain $Domain -DomainController $DomainController
        }
    }

    # Summary
    $TestsPassed = (($Script:TestResults) | Where-Object { $_.Status -eq $true }).Count
    $TestsFailed = (($Script:TestResults) | Where-Object { $_.Status -eq $false }).Count
    $TestsSkipped = 0

    $EndTime = Stop-TimeLog -Time $Time -Option OneLiner

    Write-Color -Text '[i] ', 'Time to execute tests: ', $EndTime -Color Yellow, DarkGray, Cyan
    Write-Color -Text '[i] ', 'Tests Passed: ', $TestsPassed, ' Tests Failed: ', $TestsFailed, ' Tests Skipped: ', $TestsSkipped -Color Yellow, DarkGray, Green, DarkGray, Red, DarkGray, Cyan

    # This results informaiton in form of Array for future processing
    if ($ReturnResults) {
        $Script:TestResults
    }
}