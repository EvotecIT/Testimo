$Script:SBDomainControllersPing = {
    param(
        $DomainController
    )
    Start-TestProcessing -Test "Domain Controller - $($DomainController.HostName) | Connectivity Ping $($DomainController.HostName)" -Level 1 -ExpectedStatus $true -IsTest {
        Get-WinTestConnection -Computer $DomainController.HostName
    }
}