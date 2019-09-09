$DNSZonesForest0ADEL = @{
    Enable = $true
    Source = @{
        Name         = "ForestDNSZones should have proper FSMO Owner (0ADEL)"
        Data         = {
            #$DomainController = 'ad.evotec.xyz'
            #$DomainInformation = Get-ADDomain -Server $DomainController
            $IdentityForest = "CN=Infrastructure,DC=ForestDnsZones,$(($DomainInformation).DistinguishedName)"
            $FSMORoleOwner = (Get-ADObject -Identity $IdentityForest -Properties fSMORoleOwner -Server $Domain)
            $FSMORoleOwner
        }
        Requirements = @{
            IsDomainRoot = $true
        }
        Details      = [ordered] @{
            Area        = ''
            Category    = ''
            Severity    = ''
            RiskLevel   = 0
            Description = ""
            Resolution  = ''
            Resources   = @(

            )

        }
    }
    Tests  = [ordered] @{
        DNSZonesForest0ADEL = @{
            Enable     = $true
            Name       = 'ForestDNSZones should have proper FSMO Owner (0ADEL)'
            Parameters = @{
                ExpectedValue = '0ADEL:'
                Property      = 'fSMORoleOwner'
                OperationType = 'notmatch'
            }
        }
    }
}

