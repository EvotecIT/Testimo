$Script:SBDomainControllersRespondsPS = {
    Get-WinADDomain -Domain $DomainController
}