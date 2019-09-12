$ReplicationStatus = @{
    Enable = $true
    Source = @{
        Name         = 'Forest Replication using RepAdmin'
        Data         = {
            repadmin /showrepl * /csv | ConvertFrom-Csv
        }
        Details      = [ordered] @{
            Area        = ''
            Description = ''
            Resolution  = ''
            RiskLevel   = 10
            Resources   = @(

            )
        }
        Requirements = @{
            CommandAvailable = 'repadmin'
            OperatingSystem  = '*2008*'
        }
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
        }
    }
}