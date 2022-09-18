Import-Module .\Testimo.psd1 -Force

$Sources = @(
    #'ForestTombstoneLifetime'
    #'ForestOptionalFeatures'
    #'ForestBackup'
    #'ForestConfigurationPartitionOwners'
    #'ForestConfigurationPartitionOwnersContainers'
    #'ForestOptionalFeatures'
    #'ForestOrphanedAdmins'
    #'DomainDuplicateObjects'
    #'DomainDomainControllers'
    #'DomainLDAP'
    #'ForestSites'
    #'ForestSubnets'
    #'DomainOrphanedForeignSecurityPrincipals'
    #'ForestTrusts'
    #'DomainSecurityUsers'
    #'DomainSecurityKRBGT'
    #'ForestTrusts'
    #'ForestRoles'
    #'DomainGroupPolicyAssessment'
    #'DomainSecurityDelegatedObjects'
    #'DomainSecurityComputers'
    #'DomainWellKnownFolders'
    #'DomainSecurityUsersAcccountAdministrator'
    #'DomainSecurityGroupsSchemaAdmins'
    #'DomainSecurityGroupsAccountOperators'
    #'DomainWellKnownFolders'
    #'DomainDHCPAuthorized'
    #'ForestDHCP'
    #'DCDiskSpace'
    #'DomainSecurityDelegatedObjects'
    'DomainWellKnownFolders'
)

# Tests one by one
foreach ($_ in $Sources) {
    Invoke-Testimo -Source $_ -Online -ReportPath "$PSScriptRoot\Reports\Testimo_$($_).html" -AlwaysShowSteps
}

# Tests in single report
$T1 = Invoke-Testimo -Source DomainSecurityDelegatedObjects, ForestRoles, ForestDHCP, DomainLDAP, ForestSites, ForestBackup, ForestOptionalFeatures -Online -ReportPath $PSScriptRoot\Reports\TestimoSummary.html -AlwaysShowSteps -PassThru #-HideHTML
$T2 = Invoke-Testimo -Source DomainOrganizationalUnitsEmpty -Online -ReportPath $PSScriptRoot\Reports\TestimoSummary.html -AlwaysShowSteps -PassThru #-HideHTML

$T1 | Format-Table
$T2 | Format-Table

Invoke-Testimo -Sources ForestBackup, DomainDNSZonesForest0ADEL, DCInformation, DCDiskSpace, DCServices, DomainDomainControllers, DomainDHCPAuthorized, DomainSecurityComputers, ForestRoles -ExternalTests "C:\Support\GitHub\Testimo\Example\O365"
Invoke-Testimo -Sources DomainFSMORoles, DomainPasswordComplexity -IncludeDomainControllers AD2
Invoke-Testimo -Sources DCLDAP
Invoke-Testimo -Sources DomainSecurityUsersAcccountAdministrator, DomainSecurityAdministrator, ForestBackup, ForestTrusts