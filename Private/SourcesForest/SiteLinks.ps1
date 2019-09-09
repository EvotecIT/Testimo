$SiteLinks            = @{
    Enable = $true
    Source = @{
        Name       = 'Site Links'
        Data       = {
            Get-WinADSiteLinks
        }
        Details = [ordered] @{
            Area             = ''
            Description      = ''
            Resolution   = ''
            RiskLevel        = 10
            Resources = @(

            )
        }
    }
    Tests  = [ordered] @{
        MinimalReplicationFrequency = @{
            Enable      = $true
            Name        = 'Replication Frequency should be set to maximum 60 minutes'
            Parameters  = @{
                Property      = 'ReplicationFrequencyInMinutes'
                ExpectedValue = 60
                OperationType = 'lt'
            }
        }
        UseNotificationsForLinks    = @{
            Enable      = $true
            Name        = 'Automatic site links should use notifications'
            Parameters  = @{
                Property              = 'Options'
                ExpectedValue         = 'UseNotify'
                OperationType         = 'contains'
                PropertyExtendedValue = 'Options'
            }
        }
    }
}