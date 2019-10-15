$LanManServer = @{
    Enable = $true
    Source = @{
        Name           = "Lan Man Server"
        Data           = {
            #Get-WinADLMSettings -DomainController $DomainController
            Get-PSRegistry -RegistryPath 'HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Services\LanManServer\Parameters' -ComputerName $DomainController
        }
        Details        = [ordered] @{
            Area        = ''
            Description = 'Lan Man Server'
            Resolution  = ''
            RiskLevel   = 10
            Resources   = @(

            )
        }
        Requirements   = @{
            CommandAvailable = 'Get-WinADLMSettings'
        }
        ExpectedOutput = $true
    }
    Tests  = [ordered] @{
        EnableForcedLogoff       = @{
            Enable     = $true
            Name       = 'Enable Forced Logoff'
            Parameters = @{
                Property      = 'EnableForcedLogoff'
                ExpectedValue = 1
                OperationType = 'eq'
            }
            Details    = [ordered] @{
                Area        = ''
                Description = 'Users are not forcibly disconnected when logon hours expire.'
                Resolution  = ''
                RiskLevel   = 10
                Resources   = @(
                    'https://www.stigviewer.com/stig/windows_7/2012-07-02/finding/V-1136'
                )
            }
        }
        EnableSecuritySignature  = @{
            Enable     = $true
            Name       = 'Enable Security Signature'
            Parameters = @{
                Property      = 'EnableSecuritySignature'
                ExpectedValue = 1
                OperationType = 'eq'
            }
            Details    = [ordered] @{
                Area        = ''
                Description = 'Microsoft network server: Digitally sign communications (if client agrees)'
                Resolution  = ''
                RiskLevel   = 10
                Resources   = @(
                    'https://support.microsoft.com/en-us/help/887429/overview-of-server-message-block-signing' # XP
                    'https://community.spiceworks.com/topic/2131862-how-to-set-microsoft-network-server-digitally-sign-communications-always'
                    'https://www.stigviewer.com/stig/windows_server_2016/2017-11-20/finding/V-73663'
                )
            }
        }
        RequireSecuritySignature = @{
            Enable     = $true
            Name       = 'Require Security Signature'
            Parameters = @{
                Property      = 'RequireSecuritySignature'
                ExpectedValue = 1
                OperationType = 'eq'
            }
            Details    = [ordered] @{
                Area        = ''
                Description = 'Microsoft network server: Digitally sign communications (always)'
                Resolution  = ''
                RiskLevel   = 10
                Resources   = @(
                    'https://support.microsoft.com/en-us/help/887429/overview-of-server-message-block-signing' # XP
                    'https://community.spiceworks.com/topic/2131862-how-to-set-microsoft-network-server-digitally-sign-communications-always'
                )
            }
        }
    }
}


#Get-PSRegistry -RegistryPath 'HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Services\Tcpip6\Parameters' -ComputerName AD1

#Get-PSRegistry -RegistryPath 'HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Services\Tcpip\Parameters' -ComputerName AD1