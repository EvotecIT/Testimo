$DNSZonesDomain0ADEL = @{
    Enable = $true
    Source = @{
        Name    = "DomainDNSZones should have proper FSMO Owner (0ADEL)"
        Data    = {
            #$DomainController = 'ad.evotec.pl'
            #$DomainInformation = Get-ADDomain -Server $DomainController
            $IdentityDomain = "CN=Infrastructure,DC=DomainDnsZones,$(($DomainInformation).DistinguishedName)"
            $FSMORoleOwner = (Get-ADObject -Identity $IdentityDomain -Properties fSMORoleOwner -Server $Domain)
            $FSMORoleOwner
            #If ($FSMORoleOwner -match "0ADEL:") {
            #    $FSMORoleOwner
            #}
        }
        Details = [ordered] @{
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
        DNSZonesDomain0ADEL = @{
            Enable     = $true
            Name       = 'DomainDNSZones should have proper FSMO Owner (0ADEL)'
            Parameters = @{
                ExpectedValue = '0ADEL:'
                Property      = 'fSMORoleOwner'
                OperationType = 'notmatch'
            }
        }
    }
}