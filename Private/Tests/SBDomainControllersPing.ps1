<#
$Script:SBDomainControllersPing = {
    param(
        $DomainController
    )
    Start-TestProcessing -Test "Domain Controller - $($DomainController.HostName) | Connectivity Ping $($DomainController.HostName)" -Level 1 -ExpectedStatus $true -IsTest {
        Get-WinTestConnection -Computer $DomainController.HostName
    }
}
#>

$Script:SBDomainControllersPing = {
    Test-NetConnection -ComputerName $DomainController -WarningAction SilentlyContinue
}

$Script:SBDomainControllersPingTest = {
    Test-Value -TestName "Domain Controller - $DomainController | Responds to PING" -Property 'PingSucceeded' @args -PropertExtendedValue 'PingReplyDetails', 'RoundtripTime'
}