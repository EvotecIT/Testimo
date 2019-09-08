Import-Module .\Testimo.psd1 -Force #-Verbose

$Sources = @(
    'ForestRoles'
    'ForestOptionalFeatures'
    'ForestOrphanedAdmins'
    'DomainPasswordComplexity'
    'DomainKerberosAccountAge'
    #'DomainDNSScavengingForPrimaryDNSServer'
    #'DomainSysVolDFSR'
    #'DCRDPSecurity'
    'DCSMBShares'
    'DomainGroupPolicyMissingPermissions'
    #'DCWindowsRolesAndFeatures'
    #'DCNTDSParameters'
    #'DCInformation'
    'ForestReplicationStatus'
)

Invoke-Testimo -Sources $Sources -ExcludeDomains 'ad.evotec.pl' -ShowReport