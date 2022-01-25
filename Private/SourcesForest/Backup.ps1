$Backup = @{
    Name            = "ForestBackup"
    Enable          = $true
    Scope           = 'Forest'
    Source          = @{
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
            StatusTrue  = 0
            StatusFalse = 0
        }
        ExpectedOutput = $true
    }
    Tests           = [ordered] @{
        LastBackupTests = @{
            Enable     = $true
            Name       = 'Forest Last Backup Time'
            Parameters = @{
                ExpectedValue         = 2
                OperationType         = 'lt'
                Property              = 'LastBackupDaysAgo'
                PropertyExtendedValue = 'LastBackup'
                OverwriteName         = { "Last Backup $($_.NamingContext)" }
            }
            Details    = [ordered] @{
                Category    = 'Configuration'
                Importance  = 10
                ActionType  = 2
                StatusTrue  = 1
                StatusFalse = 5
            }
        }
    }
    DataDescription = {
        New-HTMLSpanStyle -FontSize 10pt {
            New-HTMLText -Text @(
                'Active Directory is critical system for any company. Having a proper, up to date backup is crucial. '
                'Last backup should be maximum few days old, if not less than 24 hours old. '
                "Please keep in mind that this test doesn't verifies the backup, nor provides information if the backup was saved to proper place and will be available for restore operations. "
                "This tests merely checks what was reported by Active Directory - that backup did happen. "
                "You should make sure that your backup, and more importantly restore process actually works! "
            )
        }
    }
    DataHighlights  = {
        New-HTMLTableCondition -Name 'LastBackupDaysAgo' -ComparisonType number -BackgroundColor PaleGreen -Value 2 -Operator lt
        New-HTMLTableCondition -Name 'LastBackupDaysAgo' -ComparisonType number -BackgroundColor Salmon -Value 2 -Operator ge
        New-HTMLTableCondition -Name 'LastBackupDaysAgo' -ComparisonType number -BackgroundColor Tomato -Value 10 -Operator ge
    }
}