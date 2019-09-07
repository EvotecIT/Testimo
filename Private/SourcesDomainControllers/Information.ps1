<#
ComputerObjectDN           : CN=AD1,OU=Domain Controllers,DC=ad,DC=evotec,DC=xyz
DefaultPartition           : DC=ad,DC=evotec,DC=xyz
Domain                     : ad.evotec.xyz
Enabled                    : True
Forest                     : ad.evotec.xyz
HostName                   : AD1.ad.evotec.xyz
InvocationId               : dbb12bed-243b-4983-b4be-e420cb662754
IPv4Address                : 192.168.240.189
IPv6Address                :
IsGlobalCatalog            : True
IsReadOnly                 : False
LdapPort                   : 389
Name                       : AD1
NTDSSettingsObjectDN       : CN=NTDS Settings,CN=AD1,CN=Servers,CN=KATOWICE-1,CN=Sites,CN=Configuration,DC=ad,DC=evotec,DC=xyz
OperatingSystem            : Windows Server 2016 Standard
OperatingSystemHotfix      :
OperatingSystemServicePack :
OperatingSystemVersion     : 10.0 (14393)
OperationMasterRoles       : {SchemaMaster, DomainNamingMaster, PDCEmulator, RIDMaster...}
Partitions                 : {DC=ForestDnsZones,DC=ad,DC=evotec,DC=xyz, DC=DomainDnsZones,DC=ad,DC=evotec,DC=xyz, CN=Schema,CN=Configuration,DC=ad,DC=evotec,DC=xyz, CN=Configuration,DC=ad,DC=evotec,DC=xyz...}
ServerObjectDN             : CN=AD1,CN=Servers,CN=KATOWICE-1,CN=Sites,CN=Configuration,DC=ad,DC=evotec,DC=xyz
ServerObjectGuid           : d23687c4-307b-466d-bf2b-8951094da6a9
Site                       : KATOWICE-1
SslPort                    : 636
#>

$Information = @{
    Enable = $true
    Source = @{
        Name = "Domain Controller Information"
        Data = {
            Get-ADDomainController -Server $DomainController
        }
    }
    Tests  = [ordered] @{
        IsEnabled = @{
            Enable      = $true
            Name        = 'Is Enabled'
            Parameters  = @{
                Property              = 'Enabled'
                ExpectedValue         = $True
                OperationType         = 'eq'
            }
        }
        IsGlobalCatalog = @{
            Enable      = $true
            Name        = 'Is Global Catalog'
            Parameters  = @{
                Property              = 'IsGlobalCatalog'
                ExpectedValue         = $True
                OperationType         = 'eq'
            }
        }
    }
}