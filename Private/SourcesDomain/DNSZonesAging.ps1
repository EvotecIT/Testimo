$DnsZonesAging = @{
    Enable = $true
    Source = @{
        Name    = "Aging primary DNS Zone"
        Data    = {
            #$PSWinDocumentationDNS = Import-Module PSWinDocumentation.DNS -PassThru
            $PSWinDocumentationDNS = Import-PrivateModule PSWinDocumentation.DNS
            & $PSWinDocumentationDNS {
                param($Domain)
                $Zones = Get-WinDnsServerZones -ZoneName $Domain -Domain $Domain
                Compare-MultipleObjects -Objects $Zones -FormatOutput -CompareSorted:$true -ExcludeProperty GatheredFrom -SkipProperties -Property 'AgingEnabled'
            } $Domain
        }
        Details = [ordered] @{
            Area        = ''
            Category    = ''
            Severity    = ''
            RiskLevel   = 0
            Description = ''
            Resolution  = ''
            Resources   = @(

            )
        }
    }
    Tests  = [ordered] @{
        EnabledAgingEnabled   = @{
            Enable      = $true
            Name        = 'Zone DNS aging should be enabled'
            # Data     = $Script:SBDomainDnsZonesTestEnabled
            Parameters  = @{
                Property      = 'Source'
                ExpectedValue = $true
                OperationType = 'eq'
            }
            Description = 'Primary DNS zone should have aging enabled.'
        }
        EnabledAgingIdentical = @{
            Enable      = $true
            Name        = 'Zone DNS aging should be identical on all DCs'
            #Data     = $Script:SBDomainDnsZonesTestIdentical
            Parameters  = @{
                Property      = 'Status'
                ExpectedValue = $true
                OperationType = 'eq'
            }
            Description = 'Primary DNS zone should have aging enabled, on all DNS servers.'
        }
    }
}