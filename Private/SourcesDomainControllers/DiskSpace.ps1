$DiskSpace = @{
    Name   = 'DCDiskSpace'
    Enable = $true
    Scope  = 'DC'
    Source = @{
        Name           = 'Disk Free'
        Data           = {
            Get-ComputerDiskLogical -ComputerName $DomainController -OnlyLocalDisk -WarningAction SilentlyContinue
        }
        Details        = [ordered] @{
            Area        = 'Health'
            Category    = 'Disk'
            Description = ''
            Resolution  = ''
            Importance  = 10
            Resources   = @(

            )
        }
        ExpectedOutput = $true
    }
    Tests  = [ordered] @{
        FreeSpace   = @{
            Enable     = $true
            Name       = "Free Space in GB"
            Parameters = @{
                Property              = 'FreeSpace'
                PropertyExtendedValue = 'FreeSpace'
                ExpectedValue         = 10
                OperationType         = 'gt'
                OverwriteName         = { "Free Space in GB / $($_.DeviceID)" }
            }
        }
        FreePercent = @{
            Enable     = $true
            Name       = 'Free Space Percent'
            Parameters = @{
                Property              = 'FreePercent'
                PropertyExtendedValue = 'FreePercent'
                ExpectedValue         = 10
                OperationType         = 'gt'
                OverwriteName         = { "Free Space in Percent / $($_.DeviceID)" }
            }
        }
    }
}