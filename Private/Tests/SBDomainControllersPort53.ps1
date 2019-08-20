$Script:SBDomainControllersPort53 = {
   Test-NetConnection -ComputerName $DomainController -WarningAction SilentlyContinue -Port 53
}

<#
$Script:SBDomainControllersPort53Test = {
    Test-Value -TestName "Port is open" -Property 'TcpTestSucceeded' @args
}
#>