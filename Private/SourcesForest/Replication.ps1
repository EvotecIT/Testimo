$Replication = @{
    Enable = $true
    Source = @{
        Name       = 'Forest Replication'
        Data       = {
            Get-WinADForestReplication -WarningAction SilentlyContinue
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
        ReplicationTests = @{
            Enable     = $true
            Name       = 'Replication Test'
            Parameters = @{
                ExpectedValue         = $true
                Property              = 'Status'
                OperationType         = 'eq'
                PropertyExtendedValue = 'StatusMessage'
                OverwriteName         = { "Replication from $($_.Server) to $($_.ServerPartner)" }
            }
        }
    }
}