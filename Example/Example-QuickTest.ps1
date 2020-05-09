Import-Module .\Testimo.psd1 -Force

#Invoke-Testimo -Sources DomainPasswordComplexity, ForestBackup #-ShowReport
#Invoke-Testimo -Sources DomainDNSForwaders,DCDiskSpace
#Invoke-Testimo -Sources DomainComputersUnsupported,DomainComputersUnsupportedMainstream,DomainPasswordComplexity
#Invoke-Testimo -Sources DCDiskSpace -SkipRODC -ShowReport

#Invoke-Testimo -Sources DCSMBSharesPermissions,DCSMBShares -IncludeDomains 'ad.evotec.pl' -IncludeDomainControllers 'ADRODC' -ShowReport
#Invoke-Testimo -Sources DomainSecurityUsers,DCUNCHardenedPaths -ShowReport
#Invoke-Testimo -Sources ForestBackup,ForestOptionalFeatures,DCDFS -IncludeDomainControllers ad1 -ForestName 'test.evotec.pl'
#Invoke-Testimo -Sources DomainSecurityUsers, DomainSecurityKRBGT -ShowReport #-ForestName test.evotec.pl #-ShowReport
#Invoke-Testimo -Sources DCLanManServer, DomainSecurityKRBGT -ShowReport
#Invoke-Testimo -Sources ForestSiteLinks,ForestSiteLinksConnections -ShowReport -ForestName 'test.evotec.pl'
#Invoke-Testimo -Sources DomainOrganizationalUnitsProtected -ShowReport #-ForestName 'test.evotec.pl'
#Invoke-Testimo -Sources DomainDNSForwaders,DCDNSForwaders -ShowReport #-ForestName 'test.evotec.pl'
#Invoke-Testimo -Sources DomainDNSScavengingForPrimaryDNSServer -ShowReport
Invoke-Testimo -Sources ForestReplication -ShowReport
Invoke-Testimo -Sources ForestReplication <#,ForestReplicationStatus#> -ForestName 'test.evotec.pl' -ShowReport
#Invoke-Testimo -Sources DomainDuplicateObjects
#Invoke-Testimo -Sources ForestReplication,ForestReplicationStatus -ReturnResults #-ForestName 'test.evotec.pl'

#Invoke-Testimo -Sources ForestSiteLinks -ForestName 'test.evotec.pl' #-ShowReport
#Invoke-Testimo -Sources DomainDNSZonesForest0ADEL
#Invoke-Testimo -Sources DomainDNSZonesForest0ADEL -ForestName 'test.evotec.pl'
#Invoke-Testimo -Sources DomainTrusts -ForestName 'test.evotec.pl'
#Invoke-Testimo -Sources DomainTrusts