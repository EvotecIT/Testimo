$Script:SBDomainControllersPort53 = {
   Test-NetConnection -ComputerName $DomainController -WarningAction SilentlyContinue -Port 53
}