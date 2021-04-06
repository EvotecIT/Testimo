﻿$DCDNSForwaders = @{
    Enable = $true
    Scope  = 'DC'
    Source = @{
        Name           = "DC DNS Forwarders"
        Data           = {
            $Forwarders = Get-WinDnsServerForwarder -Forest $ForestName -Domain $Domain -IncludeDomainControllers $DomainController -WarningAction SilentlyContinue -Formatted
            $Forwarders
        }
        Details        = [ordered] @{
            Area        = 'Configuration'
            Category    = 'DNS'
            Severity    = 'Medium'
            Importance   = 0
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