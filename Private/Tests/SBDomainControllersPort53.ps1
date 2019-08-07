<#
$Script:SBDomainControllersPort53 = {
    param(
        $DomainController
    )
    Start-TestProcessing -Test "Domain Controller - $($DomainController.HostName) | Connectivity Port 53 (DNS)" -Level 1 -ExpectedStatus $true -IsTest {
        Get-WinTestConnectionPort -Computer $DomainController.HostName -Port 53
    }
}
#>


$Script:SBDomainControllersPort53 = {
   Test-NetConnection -ComputerName $DomainController.HostName -WarningAction SilentlyContinue -Port 53
}

$Script:SBDomainControllersPort53Test = {
    Test-Value -TestName "Port is open" -Property 'TcpTestSucceeded' @args
}