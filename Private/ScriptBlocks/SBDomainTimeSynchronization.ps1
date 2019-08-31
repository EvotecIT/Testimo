$Script:SBDomainTimeSynchronizationInternal = {
    Get-ComputerTime -TimeTarget $DomainController -WarningAction SilentlyContinue
}
$Script:SBDomainTimeSynchronizationExternal = {
    Get-ComputerTime -TimeTarget $DomainController -TimeSource 'pool.ntp.org' -WarningAction SilentlyContinue
}