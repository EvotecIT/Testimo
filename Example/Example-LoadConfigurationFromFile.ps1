Import-Module .\Testimo.psd1 -Force #-Verbose

$ConfigurationFile = "$PSScriptRoot\Configuration\TestimoConfiguration.json"

$Sources = @(
    #'ForestFSMORoles'
    'ForestOptionalFeatures'
    #'ForestBackup'
    #'ForestOrphanedAdmins'
    #'DomainPasswordComplexity'
    #'DomainKerberosAccountAge'
    #'DomainDNSScavengingForPrimaryDNSServer'
    #'DCWindowsUpdates'
    #'DCTimeSynchronizationExternal'
    'DomainDHCPAuthorized'
)

$TestResults = Invoke-Testimo -ReturnResults -ExcludeDomains 'ad.evotec.pl' -ExtendedResults -Configuration $ConfigurationFile -Sources $Sources -ShowReport
$TestResults | Format-Table -AutoSize *