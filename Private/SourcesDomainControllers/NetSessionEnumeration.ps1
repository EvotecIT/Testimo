$NetSessionEnumeration = @{
    Enable = $true
    Source = @{
        Name           = "Net Session Enumeration"
        Data           = {
            $Registry = Get-PSRegistry -RegistryPath "HKLM\SYSTEM\CurrentControlSet\Services\LanmanServer\DefaultSecurity" -ComputerName $DomainController
            $CSD = [System.Security.AccessControl.CommonSecurityDescriptor]::new($true, $false, $Registry.SrvsvcSessionInfo, 0)
            $CSD.DiscretionaryAcl.SecurityIdentifier | Where-Object { $_ -eq 'S-1-5-11' }
            # ConvertFrom-SID -sid $CSD.DiscretionaryAcl.SecurityIdentifier | Where-Object { $_.Name -eq 'Authenticated Users' }
        }
        Details        = [ordered] @{
            Type        = 'Security'
            Area        = ''
            Description = 'Net Session Enumeration is a method used to retrieve information about established sessions on a server. Any domain user can query a server for its established sessions.'
            Resolution  = 'Hardening Net Session Enumeration'
            RiskLevel   = 10
            Resources   = @(
                'https://gallery.technet.microsoft.com/Net-Cease-Blocking-Net-1e8dcb5b'
            )
        }
        Requirements   = @{
            CommandAvailable = 'Get-PSRegistry'
        }
        ExpectedOutput = $false
    }
}