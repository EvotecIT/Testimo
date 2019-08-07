<#
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
#>

$Script:SBDomainControllersLDAP = {
    Test-LDAP -ComputerName $DomainController.HostName -WarningAction SilentlyContinue
}
$Script:SBDomainControllersLDAP_Port = {
    Test-Value -TestName "Domain Controller - $($DomainController) | LDAP Port is Available" -Property 'LDAP' @args
}
$Script:SBDomainControllersLDAP_PortSSL = {
    Test-Value -TestName "Domain Controller - $($DomainController) | LDAP SSL Port is Available" -Property 'LDAPS' @args
}
$Script:SBDomainControllersLDAP_PortGC = {
    Test-Value -TestName "Domain Controller - $($DomainController) | LDAP GC Port is Available" -Property 'GlobalCatalogLDAP'  @args
}
$Script:SBDomainControllersLDAP_PortGC_SSL = {
    Test-Value -TestName "Domain Controller - $($DomainController) | LDAP GC SSL Port is Available" -Property 'GlobalCatalogLDAPS' @args
}