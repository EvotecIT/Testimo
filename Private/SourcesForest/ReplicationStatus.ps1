
$ReplicationStatus = @{
    Name   = "ForestReplicationStatus"
    Enable = $true
    Scope  = 'Forest'
    Source = @{
        Name           = 'Forest Replication using RepAdmin'
        Data           = {
            $Header = '"showrepl_COLUMNS","Destination DSA Site","Destination DSA","Naming Context","Source DSA Site","Source DSA","Transport Type","Number of Failures","Last Failure Time","Last Success Time","Last Failure Status"'
            $data = repadmin /showrepl * /csv
            $data[0] = $Header
            $data | ConvertFrom-Csv
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
        Requirements   = @{
            CommandAvailable = 'repadmin'
            IsInternalForest = $true
        }
        ExpectedOutput = $true
    }
    Tests  = [ordered] @{
        ReplicationTests = @{
            Enable     = $true
            Name       = 'Replication Test'
            Parameters = @{
                ExpectedValue         = 0
                Property              = 'Number of Failures'
                OperationType         = 'eq'
                PropertyExtendedValue = 'Last Success Time'
                OverwriteName         = { "Replication from $($_.'Source DSA') to $($_.'Destination DSA'), Naming Context: $($_.'Naming Context')" }
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