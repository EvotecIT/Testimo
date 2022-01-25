$ServiceWINRM = @{
    Name   = 'DCServiceWINRM'
    Enable = $true
    Scope  = 'DC'
    Source = @{
        Name           = "Service WINRM"
        Data           = {
            Get-PSRegistry -RegistryPath 'HKEY_LOCAL_MACHINE\SOFTWARE\Policies\Microsoft\Windows\WinRM\Service' -ComputerName $DomainController
        }
        Details        = [ordered] @{
            Type        = 'Security'
            Area        = ''
            Description = 'Storage of administrative credentials could allow unauthorized access. Disallowing the storage of RunAs credentials for Windows Remote Management will prevent them from being used with plug-ins. The Windows Remote Management (WinRM) service must not store RunAs credentials.'
            Resolution  = ''
            Importance  = 10
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
                Description = 'Storage of administrative credentials could allow unauthorized access. Disallowing the storage of RunAs credentials for Windows Remote Management will prevent them from being used with plug-ins. The Windows Remote Management (WinRM) service must not store RunAs credentials.'
                Resolution  = ''
                Importance  = 10
                Resources   = @(
                    'https://www.stigviewer.com/stig/windows_server_2016/2018-03-07/finding/V-73603'
                )
            }
        }
    }
}

