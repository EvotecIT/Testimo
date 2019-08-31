$Script:SBDomainControllersLDAP = {
    Test-LDAP -ComputerName $DomainController -WarningAction SilentlyContinue
}