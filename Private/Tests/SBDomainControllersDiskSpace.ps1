$Script:SBDomainControllersDiskSpace = {
    Get-ComputerDiskLogical -ComputerName $DomainController -OnlyLocalDisk -WarningAction SilentlyContinue
}