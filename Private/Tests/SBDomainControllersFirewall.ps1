$Script:SBDomainControllersFirewall = {
    Get-ComputerNetwork -ComputerName $DomainController
}