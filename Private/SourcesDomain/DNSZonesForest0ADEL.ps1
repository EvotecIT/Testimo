$DNSZonesForest0ADEL = @{
    Enable = $true
    Source = @{
        Name           = "ForestDNSZones should have proper FSMO Owner (0ADEL)"
        Data           = {
            #$DomainController = 'ad.evotec.xyz'
            #$DomainInformation = Get-ADDomain -Server $DomainController
            $IdentityForest = "CN=Infrastructure,DC=ForestDnsZones,$(($DomainInformation).DistinguishedName)"
            $FSMORoleOwner = (Get-ADObject -Identity $IdentityForest -Properties fSMORoleOwner -Server $Domain)
            $FSMORoleOwner
        }
        Requirements   = @{
            IsDomainRoot = $true
        }
        Details        = [ordered] @{
            Area        = 'Configuration'
            Category    = 'DNS'
            Severity    = ''
            RiskLevel   = 0
            Description = ""
            Resolution  = ''
            Resources   = @(
                'https://blogs.technet.microsoft.com/the_9z_by_chris_davis/2011/12/20/forestdnszones-or-domaindnszones-fsmo-says-the-role-owner-attribute-could-not-be-read/'
                'https://support.microsoft.com/en-us/help/949257/error-message-when-you-run-the-adprep-rodcprep-command-in-windows-serv'
                'https://social.technet.microsoft.com/Forums/en-US/8b4a7794-13b2-4ef0-90c8-16799e9fd529/orphaned-fsmoroleowner-entry-for-domaindnszones?forum=winserverDS'
            )

        }
        ExpectedOutput = $true
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

