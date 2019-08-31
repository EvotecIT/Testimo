function Test-ADRolesAvailability {
    param(
        [string] $Domain
    )
    $ADModule = Import-Module PSWinDocumentation.AD -PassThru
    $Roles = & $ADModule { param($Domain); Get-WinADForestRoles -Domain $Domain } $Domain
    if ($Domain -ne '') {
        [PSCustomObject] @{
            PDCEmulator                      = $Roles['PDCEmulator']
            PDCEmulatorAvailability          = if ($Roles['PDCEmulator']) { (Test-NetConnection -ComputerName $Roles['PDCEmulator']).PingSucceeded } else { $false }
            RIDMaster                        = $Roles['RIDMaster']
            RIDMasterAvailability            = if ($Roles['RIDMaster']) { (Test-NetConnection -ComputerName $Roles['RIDMaster']).PingSucceeded } else { $false }
            InfrastructureMaster             = $Roles['InfrastructureMaster']
            InfrastructureMasterAvailability = if ($Roles['InfrastructureMaster']) { (Test-NetConnection -ComputerName $Roles['InfrastructureMaster']).PingSucceeded } else { $false }
        }
    } else {
        [PSCustomObject] @{
            SchemaMaster                   = $Roles['SchemaMaster']
            SchemaMasterAvailability       = if ($Roles['SchemaMaster']) { (Test-NetConnection -ComputerName $Roles['SchemaMaster']).PingSucceeded } else { $false }
            DomainNamingMaster             = $Roles['DomainNamingMaster']
            DomainNamingMasterAvailability = if ($Roles['DomainNamingMaster']) { (Test-NetConnection -ComputerName $Roles['DomainNamingMaster']).PingSucceeded } else { $false }
        }
    }
}