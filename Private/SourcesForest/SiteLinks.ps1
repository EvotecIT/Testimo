$SiteLinks            = @{
    Enable = $true
    Source = @{
        Name       = 'Site Links'
        Data       = {
            Get-WinADSiteLinks
        }
        Area       = 'Sites'
        Parameters = @{

        }
    }
    Tests  = [ordered] @{
        MinimalReplicationFrequency = @{
            Enable      = $true
            Name        = 'Replication Frequency should be set to maximum 60 minutes'
            Description = ''
            Parameters  = @{
                Property      = 'ReplicationFrequencyInMinutes'
                ExpectedValue = 60
                OperationType = 'lt'
            }
        }
        UseNotificationsForLinks    = @{
            Enable      = $true
            Name        = 'Automatic site links should use notifications'
            Description = ''
            Parameters  = @{
                Property              = 'Options'
                ExpectedValue         = 'UseNotify'
                OperationType         = 'contains'
                PropertyExtendedValue = 'Options'
            }
        }
    }
}