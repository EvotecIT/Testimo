$ReplicationStatus = @{
    Enable = $true
    Source = @{
        Name = 'Forest Replication using RepAdmin'
        Data = {
            repadmin /showrepl * /csv | ConvertFrom-Csv
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