$SMBShares = @{
    Name   = 'DCSMBShares'
    Enable = $true
    Scope  = 'DC'
    Source = @{
        Name           = 'Default SMB Shares'
        Data           = {
            Get-ComputerSMBShare -ComputerName $DomainController -Translated
        }
        Details        = [ordered] @{
            Area        = ''
            Description = ''
            Resolution  = ''
            Importance  = 10
            Resources   = @(

            )
        }
        Requirements   = @{
            CommandAvailable = 'Get-ComputerSMBShare'
        }
        ExpectedOutput = $true
    }
    Tests  = [ordered] @{
        AdminShare   = @{
            Enable     = $true
            Name       = 'Remote Admin Share is available'
            Parameters = @{
                WhereObject           = { $_.Name -eq 'ADMIN$' }
                ExpectedCount         = 1
                PropertyExtendedValue = 'Path'
            }
        }
        DefaultShare = @{
            Enable     = $true
            Name       = 'Default Share is available'
            Parameters = @{
                WhereObject           = { $_.Name -eq 'C$' }
                ExpectedCount         = 1
                PropertyExtendedValue = 'Path'
            }
        }
        RemoteIPC    = @{
            Enable     = $true
            Name       = 'Remote IPC Share is available'
            Parameters = @{
                WhereObject           = { $_.Name -eq 'IPC$' }
                ExpectedCount         = 1
                PropertyExtendedValue = 'Path'
            }
        }
        NETLOGON     = @{
            Enable     = $true
            Name       = 'NETLOGON Share is available'
            Parameters = @{
                WhereObject           = { $_.Name -eq 'NETLOGON' }
                ExpectedCount         = 1
                PropertyExtendedValue = 'Path'
            }
        }
        SYSVOL       = @{
            Enable     = $true
            Name       = 'SYSVOL Share is available'
            Parameters = @{
                WhereObject           = { $_.Name -eq 'SYSVOL' }
                ExpectedCount         = 1
                PropertyExtendedValue = 'Path'
            }
        }
    }
}