$Pingable = @{
    Enable = $true
    Source = @{
        Name       = 'Ping Connectivity'
        Data       = {
            Test-NetConnection -ComputerName $DomainController -WarningAction SilentlyContinue
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