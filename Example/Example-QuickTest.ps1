Import-Module .\Testimo.psd1 -Force

$Sources = @(

    # 'ForestTombstoneLifetime'
    # 'ForestOptionalFeatures'
    # 'ForestBackup'
    # 'ForestConfigurationPartitionOwners'
    # 'ForestConfigurationPartitionOwnersContainers'
    # 'ForestOptionalFeatures'
    # 'ForestOrphanedAdmins'
    # 'DomainDuplicateObjects'
    # 'DomainDomainControllers'
    # 'DomainLDAP'
    # 'ForestSites'
    # 'ForestSubnets'
    # 'DomainOrphanedForeignSecurityPrincipals'
    # 'ForestTrusts'
    #'DomainSecurityUsers'
    #'DomainSecurityKRBGT'
    # 'ForestTrusts'
    # 'ForestRoles'
    #'DomainGroupPolicyAssessment'
    #'DomainSecurityDelegatedObjects'
    #'DomainSecurityComputers'
    #'DomainWellKnownFolders'
    #'DomainSecurityUsersAcccountAdministrator'
    #'DomainSecurityGroupsSchemaAdmins'
    #'DomainSecurityGroupsAccountOperators'
    'DomainWellKnownFolders'
    #'DomainDHCPAuthorized'
    'ForestDHCP'
    'DCDiskSpace'
)

# Tests one by one
foreach ($_ in $Sources) {
    #Invoke-Testimo -Source $_ -Online -ReportPath "$PSScriptRoot\Reports\Testimo_$($_).html" -AlwaysShowSteps
}

# Tests in single report
Invoke-Testimo -Source $Sources -Online -ReportPath $PSScriptRoot\Reports\TestimoSummary.html -AlwaysShowSteps #-HideHTML