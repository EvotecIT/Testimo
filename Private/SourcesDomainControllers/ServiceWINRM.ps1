$ServiceWINRM = @{
    Enable = $true
    Source = @{
        Name           = "Service WINRM"
        Data           = {
            Get-PSRegistry -RegistryPath 'HKEY_LOCAL_MACHINE\SOFTWARE\Policies\Microsoft\Windows\WinRM\Service' -ComputerName $DomainController
        }
        Details        = [ordered] @{
            Type        = 'Security'
            Area        = ''
            Description = ''
            Resolution  = ''
            RiskLevel   = 10
            Resources   = @(

            )
        }
        Requirements   = @{
            CommandAvailable = 'Get-PSRegistry'
        }
        ExpectedOutput = $true
    }
    Tests  = [ordered] @{
        DisableRunAs = @{
            Enable     = $true
            Name       = 'DisableRunAs'
            Parameters = @{
                Property      = 'DisableRunAs'
                ExpectedValue = 1
                OperationType = 'eq'
            }
            Details    = [ordered] @{
                Area        = ''
                Description = 'The Windows Remote Management (WinRM) service must not store RunAs credentials.'
                Resolution  = ''
                RiskLevel   = 10
                Resources   = @(
                    'https://www.stigviewer.com/stig/windows_server_2016/2018-03-07/finding/V-73603'
                )
            }
        }
    }
}

