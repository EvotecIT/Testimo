$DHCPAuthorized = @{
    Name   = 'DomainDHCPAuthorized'
    Enable = $false
    Scope  = 'Domain'
    Source = @{
        Name           = "DHCP authorized in domain"
        Data           = {
            #$DomainInformation = Get-ADDomain -Identity 'ad.evotec.pl'
            $SearchBase = 'cn=configuration,{0}' -f $DomainInformation.DistinguishedName
            Get-ADObject -SearchBase $searchBase -Filter "objectclass -eq 'dhcpclass' -AND Name -ne 'dhcproot'" #| select name
        }
        Requirements   = @{
           IsDomainRoot = $true
        }
        Details        = [ordered] @{
            Area        = 'DHCP'
            Category    = 'Configuration'
            Severity    = ''
            Importance  = 0
            Description = ""
            Resolution  = ''
            Resources   = @(

            )
        }
        ExpectedOutput = $true
    }
    Tests  = [ordered] @{
        DHCPAuthorized = @{
            Enable     = $true
            Name       = 'At least 1 DHCP Server Authorized'
            Parameters = @{
                ExpectedCount = '1'
                OperationType = 'ge'
            }
        }
    }
}
