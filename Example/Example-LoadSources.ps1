Import-Module .\Testimo.psd1 -Force #-Verbose

# this will get you available sources
Get-TestimoSources

<# Currently something like this. You can use this list to ExcludeSources or define Sources for Invoke-Testimo
DCDFSRAutoRecovery
DCDiskSpace                                                                                                                                                                                      ailed: 1, Skipped: 0]
DCDnsNameServes
DCDnsResolveExternal
DCDnsResolveInternal
DCLDAP
DCOperatingSystem
DCPingable                                                                                                                                                                                       Domain=; DomainController=; Status=True; Extended=Expected value (Equal): False}, @{Name=Forest | Privileged Access Management Enabled; Type=Forest; Domain=; DomainController=; Status=False; Extended=Expected value (Equal): True, Found value: False}, @{...
DCPorts
DCPortsRDP
DCServices
DCSMBProtocols
DCTimeSettings
DCTimeSynchronizationExternal
DCTimeSynchronizationInternal
DCWindowsFirewall
DCWindowsRemoteManagement
DCWindowsUpdates
DomainDNSForwaders
DomainDNSScavengingForPrimaryDNSServer
DomainDnsZonesAging
DomainEmptyOrganizationalUnits
DomainFSMORoles
DomainKerberosAccountAge
DomainOrphanedForeignSecurityPrincipals
DomainPasswordComplexity
DomainSecurityGroupsAccountOperators
DomainSecurityGroupsSchemaAdmins
DomainSecurityUsersAcccountAdministrator
DomainTrusts
DomainWellKnownFolders
ForestBackup
ForestFSMORoles
ForestOptionalFeatures
ForestOrphanedAdmins
ForestReplication
ForestSiteLinks
ForestSiteLinksConnections
ForestSites
ForestTombstoneLifetime
#>