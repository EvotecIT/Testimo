$TimeSynchronizationInternal = @{
    Enable             = $true
    Source             = @{
        Name       = "Time Synchronization Internal"
        Data       = {
            Get-ComputerTime -TimeTarget $DomainController -WarningAction SilentlyContinue
        }
        Details = [ordered] @{
            Area             = ''
            Explanation      = ''
            Recommendation   = ''
            RiskLevel        = 10
            RecommendedLinks = @(
                'https://docs.microsoft.com/en-us/previous-versions/windows/it-pro/windows-server-2003/cc773263(v=ws.10)#w2k3tr_times_tools_uhlp'
            )
        }
    }
    Tests              = [ordered] @{
        TimeSynchronizationTest = @{
            Enable     = $true
            Name       = 'Time Difference'
            Parameters = @{
                Property              = 'TimeDifferenceSeconds'
                ExpectedValue         = 1
                OperationType         = 'le'
                PropertyExtendedValue = 'TimeDifferenceSeconds'
            }
        }
    }
}