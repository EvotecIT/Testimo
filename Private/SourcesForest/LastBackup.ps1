$ForestBackup = @{
    Enable = $true
    Source = @{
        Name = 'Forest Backup'
        Data = {
            Get-WinADLastBackup
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