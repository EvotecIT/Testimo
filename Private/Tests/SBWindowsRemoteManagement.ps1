$Script:SBWindowsRemoteManagement = {
    Test-WinRM -ComputerName $DomainController
}