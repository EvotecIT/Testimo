$Pingable = @{
    Enable = $true
    Source = @{
        Name       = 'Ping Connectivity'
        Data       = {
            Test-NetConnection -ComputerName $DomainController -WarningAction SilentlyContinue
        }
        Area       = ''
        Parameters = @{

        }
    }
    Tests  = @{
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