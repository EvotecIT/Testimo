$ForestBackup = @{
    Enable = $true
    Source = @{
        Name = 'Forest Backup'
        Data = {
            Get-WinADLastBackup
        }
        Details = [ordered] @{
            Area             = 'Backup'
            Description      = ''
            Resolution   = ''
            RiskLevel        = 10
            Resources = @(

            )
        }
    }
    Tests  = [ordered] @{
        LastBackupTests = @{
            Enable     = $true
            Name       = 'Forest Last Backup Time - Context'
            Parameters = @{
                ExpectedValue         = 2
                OperationType         = 'lt'
                Property              = 'LastBackupDaysAgo'
                PropertyExtendedValue = 'LastBackup'
                OverwriteName         = { "Last Backup $($_.NamingContext)" }
            }
        }
    }
}