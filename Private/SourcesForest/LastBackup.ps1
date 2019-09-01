$ForestBackup = @{
    Enable = $true
    Source = @{
        Name = 'Forest Backup'
        Data = {
            Get-WinADLastBackup
        }
        Details = [ordered] @{
            Area             = 'Backup'
            Explanation      = ''
            Recommendation   = ''
            RiskLevel        = 10
            RecommendedLinks = @(

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