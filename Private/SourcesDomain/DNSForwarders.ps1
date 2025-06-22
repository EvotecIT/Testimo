$DNSForwarders = @{
    Name   = 'DomainDNSForwarders'
    Enable = $true
    Scope  = 'Domain'
    Source = @{
        Name           = "DNS Forwarders"
        Data           = {
            [Array] $Forwarders = Get-WinADDnsServerForwarder -Forest $ForestName -Domain $Domain -WarningAction SilentlyContinue
            if ($Forwarders.Count -gt 1) {
                $Comparision = Compare-MultipleObjects -Objects $Forwarders -FormatOutput -CompareSorted:$true -ExcludeProperty GatheredFrom -SkipProperties -Property 'IpAddress' -WarningAction SilentlyContinue
                [PSCustomObject] @{
                    Source = $Comparision.Source -join ', '
                    Status = $Comparision.Status
                }
            } elseif ($Forwarders.Count -eq 0) {
                [PSCustomObject] @{
                    # This code takes care of no forwarders
                    Source = 'No forwarders set'
                    Status = $false
                }
            } else {
                # This code takes care of only 1 server within a domain. If there is 1 server available (as others may be dead/unavailable at the time it assumes Pass)
                [PSCustomObject] @{
                    Source = $Forwarders[0].IPAddress -join ', '
                    Status = $true
                }
            }
        }
        Details        = [ordered] @{
            Area        = 'DNS'
            Category    = 'Configuration'
            Importance  = 3
            Description = ''
            Resolution  = ''
            Resources   = @(

            )
        }
        ExpectedOutput = $true
    }
    Tests  = [ordered] @{
        SameForwarders = @{
            Enable      = $true
            Name        = 'Same DNS Forwarders'
            Parameters  = @{
                Property              = 'Status'
                ExpectedValue         = $true
                OperationType         = 'eq'
                PropertyExtendedValue = 'Source'
            }
            Description = 'DNS forwarders within one domain should have identical setup'
        }
    }
}