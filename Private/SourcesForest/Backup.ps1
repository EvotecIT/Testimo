$Backup = @{
    Enable         = $true
    Scope          = 'Forest'
    Source         = @{
        Name           = 'Forest Backup'
        Data           = {
            Get-WinADLastBackup -Forest $ForestName
        }
        Details        = [ordered] @{
            Category    = 'Configuration'
            Description = 'Active Directory is critical system for any company. Having a proper, up to date backup in place is crucial.'
            Importance  = 0
            ActionType  = 0
            Resources   = @(
                '[Backing Up and Restoring an Active Directory Server](https://docs.microsoft.com/en-us/windows/win32/ad/backing-up-and-restoring-an-active-directory-server)'
                '[Backup Active Directory (Full and Incremental Backup)](https://activedirectorypro.com/backup-active-directory/)'
            )
            Tags        = 'Backup', 'Configuration'
        }
        ExpectedOutput = $true
    }
    Tests          = [ordered] @{
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
            Details    = [ordered] @{
                Category   = 'Configuration'
                Importance = 10
                ActionType = 2
            }
        }
    }
    DataHighlights = {
        New-HTMLTableCondition -Name 'LastBackupDaysAgo' -ComparisonType number -BackgroundColor PaleGreen -Value 2 -Operator lt
        New-HTMLTableCondition -Name 'LastBackupDaysAgo' -ComparisonType number -BackgroundColor Salmon -Value 2 -Operator ge
        New-HTMLTableCondition -Name 'LastBackupDaysAgo' -ComparisonType number -BackgroundColor Tomato -Value 10 -Operator ge
    }
}