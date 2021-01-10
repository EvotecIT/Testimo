$Sites = @{
    Enable = $true
    Scope  = 'Forest'
    Source = [ordered] @{
        Name           = 'Sites Verification'
        Data           = {
            Get-WinADForestSites
        }
        Details        = [ordered] @{
            Area        = 'Configuration'
            Category    = 'Sites'
            Description = ''
            Resolution  = ''
            RiskLevel   = 10
            Severity    = 'Low'
            Resources   = @(

            )
        }
        ExpectedOutput = $true
    }
    Tests  = [ordered] @{
        SitesWithoutDC      = @{
            Enable      = $true
            Name        = 'Sites without Domain Controllers'
            Description = 'Verify each `site has at least [one subnet configured]`'
            Parameters  = @{
                WhereObject   = { $_.DomainControllersCount -eq 0 }
                ExpectedCount = 0
            }
        }
        SitesWithoutSubnets = @{
            Enable     = $true
            Name       = 'Sites without Subnets'
            Parameters = @{
                WhereObject   = { $_.SubnetsCount -eq 0 }
                ExpectedCount = 0
            }
        }
    }
}