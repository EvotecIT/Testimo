$DNSResolveExternal = @{
    Name   = 'DCDnsResolveExternal'
    Enable = $true
    Scope  = 'DC'
    Source = @{
        Name           = "Resolves external DNS queries"
        Data           = {
            $Output = Invoke-Command -ComputerName $DomainController -ErrorAction Stop {
                Resolve-DnsName -Name 'testimo-check.evotec.xyz' -ErrorAction SilentlyContinue | Where-Object { $_.Section -eq 'Answer' -and $_.Type -eq 'A' }
            }
            $Output
        }
        Details        = [ordered] @{
            Area        = 'DNS'
            Category    = 'Health'
            Severity    = 'High'
            Description = ''
            Resolution  = ''
            Importance  = 10
            Resources   = @(

            )
        }
        ExpectedOutput = $true
    }
    Tests  = [ordered] @{
        ResolveDNSExternal = @{
            Enable      = $true
            Name        = 'Should resolve External DNS'
            Parameters  = @{
                Property      = 'IPAddress'
                ExpectedValue = '1.1.1.1'
                OperationType = 'eq'
            }
            Description = 'DNS should resolve external queries properly.'
        }
    }
}
