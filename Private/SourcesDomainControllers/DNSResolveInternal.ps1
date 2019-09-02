$DNSResolveInternal = @{
    Enable = $true
    Source = @{
        Name       = "Resolves internal DNS queries"
        Data       = {
            $Output = Invoke-Command -ComputerName $DomainController -ErrorAction Stop {
                param(
                    [string] $DomainController
                )
                $AllDomainControllers = Get-ADDomainController -Identity $DomainController -Server $DomainController
                $IPs = $AllDomainControllers.IPv4Address | Sort-Object
                $Output = Resolve-DnsName -Name $DomainController -ErrorAction SilentlyContinue
                @{
                    'Result'      = 'IP Comparison'
                    'Status'      = if ($null -eq (Compare-Object -ReferenceObject $IPs -DifferenceObject ($Output.IP4Address | Sort-Object))) { $true } else { $false }
                    'IPAddresses' = $Output.IP4Address
                }
            } -ArgumentList $DomainController
            $Output
        }
    }
    Tests  = [ordered] @{
        ResolveDNSInternal = @{
            Enable      = $true
            Name        = 'Should resolve Internal DNS'
            Parameters  = @{
                Property              = 'Status'
                ExpectedValue         = $true
                OperationType         = 'eq'
                PropertyExtendedValue = 'IPAddresses'
            }
            Explanation = 'DNS should resolve internal domains correctly.'
        }
    }
}