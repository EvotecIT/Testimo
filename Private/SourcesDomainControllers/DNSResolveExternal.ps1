$DNSResolveExternal = @{
    Enable = $true
    Source = @{
        Name       = "Resolves external DNS queries"
        Data       = {
            $Output = Invoke-Command -ComputerName $DomainController -ErrorAction Stop {
                Resolve-DnsName -Name 'evotec.xyz' -ErrorAction SilentlyContinue
            }
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
    }
    Tests  = [ordered] @{
        ResolveDNSExternal = @{
            Enable      = $true
            Name        = 'Should resolve External DNS'
            Parameters  = @{
                Property      = 'IPAddress'
                ExpectedValue = '37.59.176.139'
                OperationType = 'eq'
            }
            Description = 'DNS should resolve external queries properly.'
        }
    }
}