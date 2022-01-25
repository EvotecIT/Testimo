$Replication = @{
    Name   = "ForestReplication"
    Enable = $true
    Scope  = 'Forest'
    Source = @{
        Name           = 'Forest Replication'
        Data           = {
            Get-WinADForestReplication -WarningAction SilentlyContinue -Forest $ForestName
        }
        Details        = [ordered] @{
            Category    = 'Health'
            Description = ''
            Importance  = 10
            ActionType  = 2
            Severity    = 'High'
            Resources   = @(
                "[Active Directory Replication](https://blog.netwrix.com/2017/02/20/active-directory-replication/)"
                "[Active Directory Replication Concepts](https://docs.microsoft.com/en-us/windows-server/identity/ad-ds/get-started/replication/active-directory-replication-concepts)"
                "[Repadmin: How to Check Active Directory Replication](https://activedirectorypro.com/repadmin-how-to-check-active-directory-replication/)"
            )
            StatusTrue  = 1
            StatusFalse = 5
        }
        ExpectedOutput = $true
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
            Details    = @{
                Category    = 'Health'
                Importance  = 10
                ActionType  = 2
                StatusTrue  = 1
                StatusFalse = 5
            }
        }
    }
}