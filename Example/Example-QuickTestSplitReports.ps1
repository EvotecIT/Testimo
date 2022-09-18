Import-Module .\Testimo.psd1 -Force

# Split reports functionality
Invoke-Testimo -Sources ForestBackup, ForestOptionalFeatures, DomainComputersUnsupported, DomainDuplicateObjects, DCDiskSpace, DCFileSystem -SplitReports -ReportPath "$PSScriptRoot\Reports\Testimo.html" -AlwaysShowSteps
Invoke-Testimo -Sources DCDiskSpace, DCFileSystem -SplitReports -ReportPath "$PSScriptRoot\Reports\Testimo.html" -AlwaysShowSteps
Invoke-Testimo -Sources DomainComputersUnsupported, DomainDuplicateObjects -SplitReports -ReportPath "$PSScriptRoot\Reports\Testimo.html" -AlwaysShowSteps