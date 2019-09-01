Import-Module .\Testimo.psd1 -Force #-Verbose

$ConfigurationFile = "$PSScriptRoot\Configuration\TestimoConfiguration.json"

$Sources = @(
    #'ForestFSMORoles'
    'ForestOptionalFeatures'
    'ForestBackup'
    #'ForestOrphanedAdmins'
    'DomainPasswordComplexity'
    #'DomainKerberosAccountAge'
    #'DomainDNSScavengingForPrimaryDNSServer'
    'DCWindowsUpdates'
)

$TestResults = Test-IMO -ReturnResults -ExcludeDomains 'ad.evotec.pl' -ExtendedResults -Configuration $ConfigurationFile -Sources $Sources
$TestResults | Format-Table -AutoSize *