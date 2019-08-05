$Script:SBDomainControllersLDAP = {
    param(
        $DomainController
    )
    Start-TestProcessing -Test "Testing LDAP Connectivity" -Level 1 -Data {
        Test-LDAP -ComputerName $DomainController.HostName -WarningAction SilentlyContinue
    } -Tests {
        Test-Array -TestName "Domain Controller - $($DomainController.HostName) | LDAP Port is Available" -Property 'LDAP' -ExpectedValue $true -SearchObjectValue $DomainController.HostName -SearchObjectProperty 'ComputerFQDN'
        Test-Array -TestName "Domain Controller - $($DomainController.HostName) | LDAP SSL Port is Available" -Property 'LDAPS' -ExpectedValue $true -SearchObjectValue $DomainController.HostName -SearchObjectProperty 'ComputerFQDN'
        Test-Array -TestName "Domain Controller - $($DomainController.HostName) | LDAP GC Port is Available" -Property 'GlobalCatalogLDAP' -ExpectedValue $true -SearchObjectValue $DomainController.HostName -SearchObjectProperty 'ComputerFQDN'
        Test-Array -TestName "Domain Controller - $($DomainController.HostName) | LDAP GC SSL Port is Available" -Property 'GlobalCatalogLDAPS' -ExpectedValue $true -SearchObjectValue $DomainController.HostName -SearchObjectProperty 'ComputerFQDN'
    }
}