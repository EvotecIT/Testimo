$Script:SBDomainControllersPing = {
    Test-NetConnection -ComputerName $DomainController -WarningAction SilentlyContinue
}

$Script:SBDomainControllersPingTest = {
    Test-Value -TestName "Responds to PING" -Property 'PingSucceeded' -PropertyExtendedValue 'PingReplyDetails', 'RoundtripTime' @args
}