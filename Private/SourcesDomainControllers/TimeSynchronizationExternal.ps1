$TimeSynchronizationExternal = @{
    Enable             = $true
    Scope              = 'DC'
    Source             = @{
        Name           = "Time Synchronization External"
        Data           = {
            Get-ComputerTime -TimeTarget $DomainController -WarningAction SilentlyContinue -TimeSource $TimeSource
        }
        Parameters     = @{
            TimeSource = 'pool.ntp.org'
        }
        Details        = [ordered] @{
            Area        = ''
            Category    = 'Configuration'
            Description = ''
            Resolution  = ''
            RiskLevel   = 2
            Resources   = @(

            )
        }
        ExpectedOutput = $true
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