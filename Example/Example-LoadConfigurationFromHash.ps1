Import-Module .\Testimo.psd1 -Force #-Verbose

$OutputOrderedDictionary = Get-TestimoConfiguration
$OutputOrderedDictionary.ForestOptionalFeatures.Tests.RecycleBinEnabled.Enable = $false
$OutputOrderedDictionary.ForestOptionalFeatures.Tests.LapsAvailable.Enable = $true
$OutputOrderedDictionary.ForestOptionalFeatures.Tests.LapsAvailable.Parameters.ExpectedValue = $false
$OutputOrderedDictionary.ForestOptionalFeatures.Tests.PrivAccessManagement.Enable = $false
$OutputOrderedDictionary.ForestOptionalFeatures.Tests.PrivAccessManagement.Parameters.ExpectedValue = $false
$OutputOrderedDictionary.DCTimeSynchronizationExternal.Source.Parameters.TimeSource = '1.pool.ntp.org'

$Sources = @(
    #'ForestFSMORoles'
    'ForestOptionalFeatures'
    #'ForestBackup'
    #'ForestOrphanedAdmins'
    #'DomainPasswordComplexity'
    #'DomainKerberosAccountAge'
    #'DomainDNSScavengingForPrimaryDNSServer'
    #'DCWindowsUpdates'
    'DCTimeSynchronizationExternal'
)

$TestResults = Invoke-Testimo -ReturnResults -ExcludeDomains 'ad.evotec.pl' -ExtendedResults -Sources $Sources -Configuration $OutputOrderedDictionary
$TestResults | Format-Table -AutoSize *