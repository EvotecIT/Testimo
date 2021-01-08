$Replication = @{
    Enable = $true
    Scope  = 'Forest'
    Source = @{
        Name           = 'Forest Replication'
        Data           = {
            Get-WinADForestReplication -WarningAction SilentlyContinue -Forest $ForestName
        }
        Details        = [ordered] @{
            Area        = 'Health'
            Category    = 'Replication'
            Description = ''
            Resolution  = ''
            RiskLevel   = 10
            Severity    = 'High'
            Resources   = @(

            )
        }
        ExpectedOutput = $null
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