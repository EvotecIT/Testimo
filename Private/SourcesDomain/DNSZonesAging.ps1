$DnsZonesAging                      = @{
    Enable = $false
    Source = @{
        Name       = "Aging primary DNS Zone"
        Data       = {
            $PSWinDocumentationDNS = Import-Module PSWinDocumentation.DNS -PassThru

            & $PSWinDocumentationDNS {
                param($Domain)
                $Zones = Get-WinDnsServerZones -ZoneName $Domain -Domain $Domain
                Compare-MultipleObjects -Objects $Zones -FormatOutput -CompareSorted:$true -ExcludeProperty GatheredFrom -SkipProperties -Property 'AgingEnabled'
            } $Domain
        }
        Area       = ''
        Parameters = @{

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
            Explanation = 'Primary DNS zone should have aging enabled.'
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
            Explanation = 'Primary DNS zone should have aging enabled, on all DNS servers.'
        }
    }
}