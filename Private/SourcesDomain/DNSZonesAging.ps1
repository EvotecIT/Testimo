$DnsZonesAging = @{
    Enable = $true
    Scope  = 'Domain'
    Source = @{
        Name           = "Aging primary DNS Zone"
        Data           = {
            Get-WinDNSServerZones -Forest $ForestName -ZoneName $Domain -IncludeDomains $Domain
        }
        Details        = [ordered] @{
            Area        = ''
            Category    = ''
            Severity    = ''
            RiskLevel   = 0
            Description = ''
            Resolution  = ''
            Resources   = @(

            )
        }
        ExpectedOutput = $true
    }
    Tests  = [ordered] @{
        EnabledAgingEnabledAndIdentical = @{
            Enable      = $true
            Name        = 'Zone DNS aging should be identical on all DCs'
            Parameters  = @{
                WhereObject   = { $_.AgingEnabled -eq $false }
                ExpectedCount = 0
            }
            Description = 'Primary DNS zone should have aging enabled, on all DNS servers.'
        }
    }
}