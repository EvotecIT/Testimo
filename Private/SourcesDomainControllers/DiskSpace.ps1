$DiskSpace = @{
    Enable = $true
    Source = @{
        Name       = 'Disk Free'
        Data       = {
            Get-ComputerDiskLogical -ComputerName $DomainController -OnlyLocalDisk -WarningAction SilentlyContinue
        }
        Details = [ordered] @{
            Area             = ''
            Explanation      = ''
            Recommendation   = ''
            RiskLevel        = 10
            RecommendedLinks = @(

            )
        }
    }
    Tests  = @{
        FreeSpace   = @{
            Enable     = $true
            Name       = 'Free Space in GB'
            Parameters = @{
                Property              = 'FreeSpace'
                PropertyExtendedValue = 'FreeSpace'
                ExpectedValue         = 10
                OperationType         = 'gt'
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
            }
        }
    }
}