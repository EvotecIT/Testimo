Import-Module .\Testimo.psd1 -Force

$Sources = @(
    'ForestBackup'
    #'ForestConfigurationPartitionOwners'
    #'ForestConfigurationPartitionOwnersContainers'
    #'ForestOptionalFeatures'
    #'ForestOrphanedAdmins'
    #'DomainDuplicateObjects'
    #'DomainDomainControllers'
    'DomainLDAP'
)

# Tests one by one
foreach ($_ in $Sources) {
#    Invoke-Testimo -Source $_ -Online #-ReportPath $PSScriptRoot\Reports\TestimoSummary.html
}

# Tests in single report
Invoke-Testimo -Source $Sources -Online -ReportPath $PSScriptRoot\Reports\TestimoSummary.html