$Script:SBDomainControllersPort53 = {
    param(
        $DomainController
    )
    Start-TestProcessing -Test "Domain Controller - $($DomainController.HostName) | Connectivity Port 53 (DNS)" -Level 1 -ExpectedStatus $true -IsTest {
        Get-WinTestConnectionPort -Computer $DomainController.HostName -Port 53
    }
}