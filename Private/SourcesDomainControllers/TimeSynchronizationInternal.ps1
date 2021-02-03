$TimeSynchronizationInternal = @{
    Enable = $true
    Scope  = 'DC'
    Source = @{
        Name           = "Time Synchronization Internal"
        Data           = {
            Get-ComputerTime -TimeTarget $DomainController -WarningAction SilentlyContinue
        }
        Details        = [ordered] @{
            Category    = 'Configuration'
            Area        = ''
            Description = ''
            Resolution  = ''
            RiskLevel   = 2
            Resources   = @(
                'https://docs.microsoft.com/en-us/previous-versions/windows/it-pro/windows-server-2003/cc773263(v=ws.10)#w2k3tr_times_tools_uhlp'
            )
        }
        ExpectedOutput = $true
    }
    Tests  = [ordered] @{
        LastBootUpTime          = @{
            Enable     = $true
            Name       = 'Last Boot Up time should be less than X days'
            Parameters = @{
                Property      = 'LastBootUpTime'
                ExpectedValue = '(Get-Date).AddDays(-60)'
                OperationType = 'gt'
            }
        }
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

<#
Name   LocalDateTime       RemoteDateTime      InstallTime         LastBootUpTime      TimeDifferenceMinutes TimeDifferenceSeconds TimeDifferenceMilliseconds TimeSourceName    Status
----   -------------       --------------      -----------         --------------      --------------------- --------------------- -------------------------- --------------    ------
AD2    17.09.2019 07:38:57 17.09.2019 07:38:57 30.05.2018 18:30:48 13.09.2019 07:54:10    0,0417166666666667                 2,503                       2503 AD1.ad.evotec.xyz
AD3    17.09.2019 07:38:56 17.09.2019 02:38:57 26.05.2019 17:30:17 13.09.2019 07:54:09               0,02175                 1,305                       1305 AD1.ad.evotec.xyz
EVOWin 17.09.2019 07:38:57 17.09.2019 07:38:57 24.05.2019 22:46:45 13.09.2019 07:53:44                0,0415                  2,49                       2490 AD1.ad.evotec.xyz
#>