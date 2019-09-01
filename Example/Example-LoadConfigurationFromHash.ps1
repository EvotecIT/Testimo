Import-Module .\Testimo.psd1 -Force #-Verbose

$OutputOrderedDictionary = Get-TestimoConfiguration
$OutputOrderedDictionary.Forest.OptionalFeatures.Tests.RecycleBinEnabled.Enable = $false
$OutputOrderedDictionary.Forest.OptionalFeatures.Tests.LapsAvailable.Enable = $true
$OutputOrderedDictionary.Forest.OptionalFeatures.Tests.LapsAvailable.Parameters.ExpectedValue = $false

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

$TestResults = Test-IMO -ReturnResults -ExcludeDomains 'ad.evotec.pl' -ExtendedResults -Sources $Sources -Configuration $OutputOrderedDictionary
$TestResults | Format-Table -AutoSize *