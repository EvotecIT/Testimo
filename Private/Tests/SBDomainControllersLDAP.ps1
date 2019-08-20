$Script:SBDomainControllersLDAP = {
    Test-LDAP -ComputerName $DomainController -WarningAction SilentlyContinue
}
<#
$Script:SBDomainControllersLDAP_Port = {
    Test-Value -TestName "LDAP Port is Available" -Property 'LDAP' @args
}
$Script:SBDomainControllersLDAP_PortSSL = {
    Test-Value -TestName "LDAP SSL Port is Available" -Property 'LDAPS' @args
}
$Script:SBDomainControllersLDAP_PortGC = {
    Test-Value -TestName "LDAP GC Port is Available" -Property 'GlobalCatalogLDAP'  @args
}
$Script:SBDomainControllersLDAP_PortGC_SSL = {
    Test-Value -TestName "LDAP GC SSL Port is Available" -Property 'GlobalCatalogLDAPS' @args
}
#>