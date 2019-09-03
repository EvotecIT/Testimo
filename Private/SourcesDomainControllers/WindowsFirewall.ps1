$WindowsFirewall = @{
    Enable = $true
    Source = @{
        Name        = "Windows Firewall"
        Data        = {
            Get-ComputerNetwork -ComputerName $DomainController
        }
        Area        = 'Connectivity'
        Description = 'Verify windows firewall should be enabled for all network cards'

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