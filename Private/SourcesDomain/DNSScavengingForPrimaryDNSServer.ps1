$DNSScavengingForPrimaryDNSServer = @{
    Name   = 'DomainDNSScavengingForPrimaryDNSServer'
    Enable = $true
    Scope  = 'Domain'
    Source = @{
        Name           = "DNS Scavenging - Primary DNS Server"
        Data           = {
            Get-WinDnsServerScavenging -Forest $ForestName -IncludeDomains $Domain
        }
        Details        = [ordered] @{
            Area        = ''
            Category    = ''
            Severity    = ''
            Importance  = 0
            Description = ''
            Resolution  = ''
            Resources   = @(

            )
        }
        ExpectedOutput = $true
    }
    Tests  = [ordered] @{
        ScavengingCount      = @{
            Enable      = $true
            Name        = 'Scavenging DNS Servers Count'
            Parameters  = @{
                WhereObject   = { $null -ne $_.ScavengingInterval -and $_.ScavengingInterval -ne 0 }
                ExpectedCount = 1
                OperationType = 'eq'
            }
            Description = 'Scavenging Count should be 1. There should be 1 DNS server per domain responsible for scavenging. If this returns false, every other test fails.'
        }
        ScavengingInterval   = @{
            Enable     = $true
            Name       = 'Scavenging Interval'
            Parameters = @{
                WhereObject   = { $null -ne $_.ScavengingInterval -and $_.ScavengingInterval -ne 0 }
                Property      = 'ScavengingInterval', 'Days'
                ExpectedValue = 7
                OperationType = 'le'
            }
        }
        'Scavenging State'   = @{
            Enable                 = $true
            Name                   = 'Scavenging State'
            Parameters             = @{
                WhereObject   = { $null -ne $_.ScavengingInterval -and $_.ScavengingInterval -ne 0 }
                Property      = 'ScavengingState'
                ExpectedValue = $true
                OperationType = 'eq'
            }
            Description            = 'Scavenging State is responsible for enablement of scavenging for all new zones created.'
            RecommendedValue       = $true
            DescriptionRecommended = 'It should be enabled so all new zones are subject to scavanging.'
            DefaultValue           = $false
        }
        'Last Scavenge Time' = @{
            Enable     = $true
            Name       = 'Last Scavenge Time'
            Parameters = @{
                WhereObject   = { $null -ne $_.ScavengingInterval -and $_.ScavengingInterval -ne 0 }
                # this date should be the same as in Scavending Interval
                Property      = 'LastScavengeTime'
                # we need to use string which will be converted to ScriptBlock later on due to configuration export to JSON
                ExpectedValue = '(Get-Date).AddDays(-7)'
                OperationType = 'gt'
            }
        }
    }
}