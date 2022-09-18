Import-Module .\Testimo.psd1 -Force

Invoke-Testimo -Sources DomainDHCPAuthorized -ExternalTests "C:\Support\GitHub\Testimo\Example\O365"

$T = Invoke-Testimo -ExternalTests $PSScriptRoot\O365 -Source ForestBackup -Online -ReportPath $PSScriptRoot\Reports\TestimoSummary.html -AlwaysShowSteps -PassThru -ExtendedResults #-HideHTML
$T