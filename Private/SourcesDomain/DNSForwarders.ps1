$DNSForwaders                       = @{
    Enable = $true
    Source = @{
        Name       = "DNS Forwarders"
        Data       = {
            $PSWinDocumentationDNS = Import-Module PSWinDocumentation.DNS -PassThru

            & $PSWinDocumentationDNS {
                param($Domain)
                $Forwarders = Get-WinDnsServerForwarder -Domain $Domain -WarningAction SilentlyContinue
                Compare-MultipleObjects -Objects $Forwarders -FormatOutput -CompareSorted:$true -ExcludeProperty GatheredFrom -SkipProperties -Property 'IpAddress' #| Out-HtmlView -ScrollX -DisablePaging  -Filtering
            } $Domain
        }
        Area       = ''
        Parameters = @{

        }
    }
    Tests  = [ordered] @{
        SameForwarders = @{
            Enable      = $true
            Name        = 'Same DNS Forwarders'
            # Data     = $Script:SBDomainDNSForwadersTest
            Parameters  = @{
                Property              = 'Status'
                ExpectedValue         = $true
                OperationType         = 'eq'
                PropertyExtendedValue = 'Source'
            }
            Explanation = 'DNS forwarders within one domain should have identical setup'
        }
    }
}