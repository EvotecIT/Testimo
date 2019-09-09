$TimeSynchronizationExternal = @{
    Enable             = $true
    Source             = @{
        Name       = "Time Synchronization External"
        Data       = {
            Get-ComputerTime -TimeTarget $DomainController -TimeSource 'pool.ntp.org' -WarningAction SilentlyContinue
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
    MicrosoftMaterials = 'https://docs.microsoft.com/en-us/previous-versions/windows/it-pro/windows-server-2003/cc773263(v=ws.10)#w2k3tr_times_tools_uhlp'
}