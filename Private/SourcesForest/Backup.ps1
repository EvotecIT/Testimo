$Backup = @{
    Enable = $true
    Scope  = 'Forest'
    Source = @{
        Name           = 'Forest Backup'
        Data           = {
            Get-WinADLastBackup -Forest $ForestName
        }
        Details        = [ordered] @{
            Area        = 'Configuration'
            Category    = 'Backup'
            Description = ''
            Resolution  = ''
            RiskLevel   = 10
            Severity    = 'High'
            Resources   = @(

            )
        }
        ExpectedOutput = $true
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