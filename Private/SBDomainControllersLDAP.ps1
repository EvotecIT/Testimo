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
    param(
        $DomainController
    )
    #Start-TestProcessing -Test "Testing LDAP Connectivity" -Level 1 -OutputRequired {
    Test-LDAP -ComputerName $DomainController.HostName -WarningAction SilentlyContinue
    #}
}

$Script:SBDomainControllersLDAP_Port = {
    param(
        $DomainController,
        [alias('SourceData')]$Data
    )
    foreach ($_ in $Data) {
        Test-Value -TestName "Domain Controller - $($DomainController.HostName) | LDAP Port is Available" -Level 2 -Object $_ -Property 'LDAP' -ExpectedValue $true
    }
}
$Script:SBDomainControllersLDAP_PortSSL = {
    param(
        $DomainController,
        [alias('SourceData')]$Data
    )
    foreach ($_ in $Data) {
        Test-Value -TestName "Domain Controller - $($DomainController.HostName) | LDAP SSL Port is Available" -Level 2 -Object $_ -Property 'LDAPS' -ExpectedValue $true
    }
}
$Script:SBDomainControllersLDAP_PortGC = {
    param(
        $DomainController,
        [alias('SourceData')]$Data
    )
    foreach ($_ in $Data) {
        Test-Value -TestName "Domain Controller - $($DomainController.HostName) | LDAP GC Port is Available" -Level 2 -Object $_ -Property 'GlobalCatalogLDAP' -ExpectedValue $true
    }
}
$Script:SBDomainControllersLDAP_PortGC_SSL = {
    param(
        $DomainController,
        [alias('SourceData')]$Data
    )
    foreach ($_ in $Data) {
        Test-Value -TestName "Domain Controller - $($DomainController.HostName) | LDAP GC SSL Port is Available" -Level 2 -Object $_ -Property 'GlobalCatalogLDAPS' -ExpectedValue $true
    }
}