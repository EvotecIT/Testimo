$SiteLinks = @{
    Enable = $true
    Scope  = 'Forest'
    Source = @{
        Name           = 'Site Links'
        Data           = {
            Get-WinADSiteLinks -Forest $ForestName
        }
        Details        = [ordered] @{
            Area        = 'Configuration'
            Category    = 'Sites'
            Description = ''
            Resolution  = ''
            RiskLevel   = 10
            Severity    = 'Informational'
            Resources   = @(

            )
        }
        ExpectedOutput = $true
    }
    Tests  = [ordered] @{
        MinimalReplicationFrequency = @{
            Enable     = $true
            Name       = 'Replication Frequency should be set to maximum 60 minutes'
            Parameters = @{
                Property      = 'ReplicationFrequencyInMinutes'
                ExpectedValue = 60
                OperationType = 'le'
            }
        }
        UseNotificationsForLinks    = @{
            Enable     = $true
            Name       = 'Automatic site links should use notifications'
            Parameters = @{
                Property              = 'Options'
                ExpectedValue         = 'UseNotify'
                OperationType         = 'contains'
                PropertyExtendedValue = 'Options'
            }
        }
    }
}
