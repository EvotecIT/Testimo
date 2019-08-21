$Script:SBDomainControllersPing = {
    Test-NetConnection -ComputerName $DomainController -WarningAction SilentlyContinue
}