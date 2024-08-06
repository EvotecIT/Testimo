$DCDNSForwaders = @{
    Name   = 'DCDNSForwaders'
    Enable = $true
    Scope  = 'DC'
    Source = @{
        Name           = "DC DNS Forwarders"
        Data           = {
            $Forwarders = Get-WinADDnsServerForwarder -Forest $ForestName -Domain $Domain -IncludeDomainControllers $DomainController -WarningAction SilentlyContinue -Formatted
            $Forwarders
        }
        Details        = [ordered] @{
            Category    = 'Configuration'
            Area        = 'DNS'
            Importance  = 5
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
            Name        = 'Multiple DNS Forwarders'
            Parameters  = @{
                Property              = 'ForwardersCount'
                ExpectedValue         = 1
                OperationType         = 'gt'
                PropertyExtendedValue = 'IPAddress'
            }
            Description = 'DNS: More than one forwarding server should be configured'
        }
    }
}