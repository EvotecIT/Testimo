$TimeSynchronizationExternal = @{
    Name               = 'DCTimeSynchronizationExternal'
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
            Importance  = 2
            Resources   = @(
                '[How to: Fix Time Sync in your Domain](https://community.spiceworks.com/how_to/166215-fix-time-sync-in-your-domain-use-w32time)'
                '[Windows Time Settings in a Domain](https://www.concurrency.com/blog/october-2018/windows-time-settings-in-a-domain)'
            )
        }
        ExpectedOutput = $true
    }
    Tests              = [ordered] @{
        TimeSynchronizationTest = @{
            Enable     = $true
            Name       = 'Time Difference'
            Details    = [ordered] @{
                Area        = ''
                Category    = 'Configuration'
                Description = ''
                Importance  = 2
                Resources   = @(

                )
            }
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