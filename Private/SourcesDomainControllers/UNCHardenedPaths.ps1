$UNCHardenedPaths = @{
    Enable = $true
    Scope  = 'DC'
    Source = @{
        Name           = "Hardened UNC Paths"
        Data           = {
            Get-PSRegistry -RegistryPath "HKLM\SOFTWARE\Policies\Microsoft\Windows\NetworkProvider\HardenedPaths" -ComputerName $DomainController
        }
        Details        = [ordered] @{
            Type        = 'Security'
            Area        = ''
            Description = 'Hardened UNC Paths must be defined to require mutual authentication and integrity for at least the \\*\SYSVOL and \\*\NETLOGON shares.'
            Resolution  = 'Harden UNC Paths for SYSVOL and NETLOGON'
            RiskLevel   = 10
            Resources   = @(
                'https://docs.microsoft.com/en-us/archive/blogs/leesteve/demystifying-the-unc-hardening-dilemma'
                'https://www.stigviewer.com/stig/windows_10/2016-06-24/finding/V-63577'
                'https://support.microsoft.com/en-us/help/3000483/ms15-011-vulnerability-in-group-policy-could-allow-remote-code-executi'
            )
        }
        Requirements   = @{
            CommandAvailable = 'Get-PSRegistry'
        }
        Implementation = {

        }
        Rollback       = {
            Remove-ItemProperty -Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows\NetworkProvider\HardenedPaths" -Name "*"
        }
        ExpectedOutput = $true
    }
    Tests  = [ordered] @{
        NetLogonUNCPath = @{
            Enable      = $true
            Name        = 'Netlogon UNC Hardening'
            Parameters  = @{
                Property      = '\\*\NETLOGON'
                ExpectedValue = 'RequireMutualAuthentication=1, RequireIntegrity=1'
                OperationType = 'eq'
            }
            Description = "Hardened UNC Paths must be defined to require mutual authentication and integrity for at least the \\*\SYSVOL and \\*\NETLOGON shares."
        }
        SysVolUNCPath   = @{
            Enable      = $true
            Name        = 'SysVol UNC Hardening'
            Parameters  = @{
                Property      = '\\*\SYSVOL'
                ExpectedValue = 'RequireMutualAuthentication=1, RequireIntegrity=1'
                OperationType = 'eq'
            }
            Description = "Hardened UNC Paths must be defined to require mutual authentication and integrity for at least the \\*\SYSVOL and \\*\NETLOGON shares."
        }
    }
}