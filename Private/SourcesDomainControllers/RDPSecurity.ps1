$RDPSecurity = [ordered] @{
    Enable = $true
    Source = [ordered] @{
        Name    = 'RDP Security'
        Data    = {
            Get-ComputerRDP -ComputerName $DomainController -WarningAction SilentlyContinue
        }
        Details = [ordered] @{
            Area             = 'Connectivity'
            Description      = ''
            Resolution   = ''
            RiskLevel        = 10
            Resources = @(
                'https://lazywinadmin.com/2014/04/powershell-getset-network-level.html'
                'https://devblogs.microsoft.com/scripting/weekend-scripter-report-on-network-level-authentication/'
            )
        }
    }
    Tests  = [ordered] @{
        PortOpen                 = [ordered] @{
            Enable     = $true
            Name       = 'Port is OPEN'
            Parameters = @{
                Property              = 'Connectivity'
                ExpectedValue         = $true
                OperationType         = 'eq'
                PropertyExtendedValue = 'ConnectivitySummary'
            }
        }
        NLAAuthenticationEnabled = [ordered] @{
            Enable     = $true
            Name       = 'NLA Authentication is Enabled'
            Parameters = @{
                Property      = 'UserAuthenticationRequired'
                ExpectedValue = $true
                OperationType = 'eq'
            }
        }
    }
}
