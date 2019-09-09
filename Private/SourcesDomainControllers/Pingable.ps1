$Pingable = @{
    Enable = $true
    Source = @{
        Name       = 'Ping Connectivity'
        Data       = {
            Test-NetConnection -ComputerName $DomainController -WarningAction SilentlyContinue
        }
        Details = [ordered] @{
            Area             = ''
            Explanation      = ''
            Recommendation   = ''
            RiskLevel        = 10
            RecommendedLinks = @(

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