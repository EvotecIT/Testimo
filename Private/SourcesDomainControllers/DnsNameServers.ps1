$DNSNameServers = @{
    # (Get-Help <Command> -Parameter *).Name
    Enable = $true
    Source = @{
        Name = "Name servers for primary domain zone"
        Data = {
            Test-DNSNameServers -Domain $Domain -DomainController $DomainController
        }
        Details = [ordered] @{
            Area             = ''
            Explanation      = ''
            Recommendation   = ''
            RiskLevel        = 10
            RecommendedLinks = @(

            )
        }
    }
    Tests  = [ordered] @{
        DnsNameServersIdentical = @{
            Enable      = $true
            Name        = 'DNS Name servers for primary zone are identical'
            Parameters  = @{
                Property              = 'Status'
                ExpectedValue         = $True
                OperationType         = 'eq'
                PropertyExtendedValue = 'Comment'
            }
            Explanation = 'DNS Name servers for primary zone should be equal to Domain Controllers for a Domain.'
        }
    }
}