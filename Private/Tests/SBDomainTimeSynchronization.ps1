<#

    Get-ComputerTime -TimeTarget AD2, AD3, EVOWin | Format-Table

    Output

    Name   LocalDateTime       RemoteDateTime      InstallTime         LastBootUpTime      TimeDifferenceMinutes TimeDifferenceSeconds TimeDifferenceMilliseconds TimeSourceName
    ----   -------------       --------------      -----------         --------------      --------------------- --------------------- -------------------------- --------------
    AD2    13.08.2019 23:40:26 13.08.2019 23:40:26 30.05.2018 18:30:48 09.08.2019 18:40:31  8,33333333333333E-05                 0,005                          5 AD1.ad.evotec.xyz
    AD3    13.08.2019 23:40:26 13.08.2019 17:40:26 26.05.2019 17:30:17 09.08.2019 18:40:30  0,000266666666666667                 0,016                         16 AD1.ad.evotec.xyz
    EVOWin 13.08.2019 23:40:26 13.08.2019 23:40:26 24.05.2019 22:46:45 09.08.2019 18:40:06  6,66666666666667E-05                 0,004                          4 AD1.ad.evotec.xyz
#>

$Script:SBDomainTimeSynchronizationInternal = {
    Get-ComputerTime -TimeTarget $DomainController -WarningAction SilentlyContinue
}
$Script:SBDomainTimeSynchronizationExternal = {
    Get-ComputerTime -TimeTarget $DomainController -TimeSource 'pool.ntp.org' -WarningAction SilentlyContinue
}
$Script:SBDomainTimeSynchronizationTest1 = {
    Test-Value -TestName 'Time Difference' -Property 'TimeDifferenceSeconds' @args
}