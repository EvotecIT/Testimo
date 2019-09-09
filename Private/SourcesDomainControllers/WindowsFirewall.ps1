$WindowsFirewall = @{
    Enable = $true
    Source = @{
        Name    = "Windows Firewall"
        Data    = {
            Get-ComputerNetwork -ComputerName $DomainController
        }
        Details = [ordered] @{
            Area             = 'Connectivity'
            Explanation      = 'Verify windows firewall should be enabled for all network cards'
            Recommendation   = ''
            RiskLevel        = 10
            RecommendedLinks = @(

            )
        }
    }
    Tests  = [ordered] @{
        WindowsFirewall = @{
            Enable     = $true
            Name       = 'Windows Firewall should be enabled on network card'
            Parameters = @{
                Property              = 'FirewallStatus'
                ExpectedValue         = $true
                OperationType         = 'eq'
                PropertyExtendedValue = 'FirewallProfile'
            }
        }
    }
}