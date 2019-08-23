$Script:WindowsRemoteManagement = {
    Test-WinRM -ComputerName $DomainController
}