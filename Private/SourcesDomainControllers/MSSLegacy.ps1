$MSSLegacy = @{
    Enable = $true
    Source = @{
        Name           = "MSS (Legacy)"
        Data           = {
            Get-PSRegistry -RegistryPath 'HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Services\Tcpip\Parameters' -ComputerName $DomainController
            # Get-PSRegistry -RegistryPath 'HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Services\Tcpip6\Parameters' -ComputerName AD1
        }
        Details        = [ordered] @{
            Type        = 'Security'
            Area        = ''
            Description = ''
            Resolution  = ''
            RiskLevel   = 10
            Resources   = @(
                'https://blogs.technet.microsoft.com/secguide/2016/10/02/the-mss-settings/'
            )
        }
        Requirements   = @{
            CommandAvailable = 'Get-WinADLMSettings'
        }
        ExpectedOutput = $true
    }
    Tests  = [ordered] @{
        DisableIPSourceRouting = @{
            Enable     = $true
            Name       = 'DisableIPSourceRouting'
            Parameters = @{
                Property      = 'DisableIPSourceRouting'
                ExpectedValue = 2
                OperationType = 'eq'
            }
            Details    = [ordered] @{
                Area        = ''
                Description = 'Highest protection, source routing is completely disabled'
                Resolution  = ''
                RiskLevel   = 10
                Resources   = @(
                    'https://blogs.technet.microsoft.com/secguide/2016/10/02/the-mss-settings/'
                )
            }
        }
        EnableICMPRedirect     = @{
            Enable     = $true
            Name       = 'EnableICMPRedirect'
            Parameters = @{
                Property      = 'EnableICMPRedirect'
                ExpectedValue = 0
                OperationType = 'eq'
            }
            Details    = [ordered] @{
                Area        = ''
                Description = ''
                Resolution  = ''
                RiskLevel   = 10
                Resources   = @(
                    'https://blogs.technet.microsoft.com/secguide/2016/10/02/the-mss-settings/'
                )
            }
        }
    }
}


#Get-PSRegistry -RegistryPath 'HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Services\Tcpip6\Parameters' -ComputerName AD1
#Get-PSRegistry -RegistryPath 'HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Services\Tcpip\Parameters' -ComputerName AD1