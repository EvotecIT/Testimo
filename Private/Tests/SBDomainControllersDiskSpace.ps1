$Script:SBDomainControllersDiskSpace = {
    Get-ComputerDiskLogical -ComputerName $DomainController -OnlyLocalDisk -WarningAction SilentlyContinue
}

$Script:SBDomainControllersDiskSpacePercent = {
    Test-Value -TestName "Disk Free Percent" -Property 'FreePercent' -PropertyExtendedValue 'FreePercent' @args
}

$Script:SBDomainControllersDiskSpaceGB = {
    Test-Value -TestName "Disk Free Size" -Property 'FreeSpace' -PropertyExtendedValue 'FreeSpace' @args
}