$RDPSecurity = [ordered] @{
    Enable = $true
    Scope  = 'DC'
    Source = [ordered] @{
        Name    = 'RDP Security'
        Data    = {
            Get-ComputerRDP -ComputerName $DomainController -WarningAction SilentlyContinue
        }
        Details = [ordered] @{
            Area        = 'Connectivity'
            Description = ''
            Resolution  = ''
            RiskLevel   = 10
            Resources   = @(

            )
        }
        ExpectedOutput = $true
    }
    Tests  = [ordered] @{
        PortOpen                    = [ordered] @{
            Enable     = $true
            Name       = 'Port is OPEN'
            Parameters = @{
                Property              = 'Connectivity'
                ExpectedValue         = $true
                OperationType         = 'eq'
                PropertyExtendedValue = 'ConnectivitySummary'
            }
            Details    = [ordered] @{
                Area        = 'Connectivity'
                Description = ''
                Resolution  = ''
                RiskLevel   = 10
                Resources   = @(
                    'https://lazywinadmin.com/2014/04/powershell-getset-network-level.html'
                    'https://devblogs.microsoft.com/scripting/weekend-scripter-report-on-network-level-authentication/'
                )
            }
        }
        NLAAuthenticationEnabled    = [ordered] @{
            Enable     = $true
            Name       = 'NLA Authentication is Enabled'
            Parameters = @{
                Property      = 'UserAuthenticationRequired'
                ExpectedValue = $true
                OperationType = 'eq'
            }
            Details    = [ordered] @{
                Area        = 'Connectivity'
                Description = ''
                Resolution  = ''
                RiskLevel   = 10
                Resources   = @(
                    'https://lazywinadmin.com/2014/04/powershell-getset-network-level.html'
                    'https://devblogs.microsoft.com/scripting/weekend-scripter-report-on-network-level-authentication/'
                )
            }
        }
        MinimalEncryptionLevel = [ordered] @{
            Enable     = $true
            Name       = 'Minimal Encryption Level is set to at least High'
            Parameters = @{
                Property              = 'MinimalEncryptionLevelValue'
                ExpectedValue         = 3
                OperationType         = 'ge'
                PropertyExtendedValue = 'MinimalEncryptionLevel'
            }
            Details    = [ordered] @{
                Area        = 'Connectivity'
                Description = 'Remote connections must be encrypted to prevent interception of data or sensitive information. Selecting "High Level" will ensure encryption of Remote Desktop Services sessions in both directions.'
                Resolution  = ''
                RiskLevel   = 10
                Resources   = @(
                    'https://www.stigviewer.com/stig/windows_server_2012_member_server/2014-01-07/finding/V-3454'
                )
            }
        }
    }
}
