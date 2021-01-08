$DNSResolveInternal = @{
    Enable = $true
    Scope  = 'DC'
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
        Details = [ordered] @{
            Area             = ''
            Description      = ''
            Resolution   = ''
            RiskLevel        = 10
            Resources = @(

            )
        }
        ExpectedOutput = $true
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
            Description = 'DNS should resolve internal domains correctly.'
        }
    }
}