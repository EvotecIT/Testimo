$Pingable = @{
    Name   = 'DCPingable'
    Enable = $true
    Scope  = 'DC'
    Source = @{
        Name           = 'Ping Connectivity'
        Data           = {
            Test-NetConnection -ComputerName $DomainController -WarningAction SilentlyContinue
        }
        Details        = [ordered] @{
            Area        = ''
            Description = ''
            Resolution  = ''
            Importance  = 10
            Resources   = @(

            )
        }
        ExpectedOutput = $true
    }
    Tests  = [ordered] @{
        Ping = @{
            Enable     = $true
            Name       = 'Responding to PING'
            Parameters = @{
                Property              = 'PingSucceeded'
                PropertyExtendedValue = 'PingReplyDetails', 'RoundtripTime'
                ExpectedValue         = $true
                OperationType         = 'eq'
            }
        }
    }
}