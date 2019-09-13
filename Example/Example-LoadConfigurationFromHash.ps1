Import-Module .\Testimo.psd1 -Force #-Verbose

$OutputOrderedDictionary = Get-TestimoConfiguration
$OutputOrderedDictionary.Forest.OptionalFeatures.Tests.RecycleBinEnabled.Enable = $false
$OutputOrderedDictionary.Forest.OptionalFeatures.Tests.LapsAvailable.Enable = $true
$OutputOrderedDictionary.Forest.OptionalFeatures.Tests.LapsAvailable.Parameters.ExpectedValue = $false
$OutputOrderedDictionary.DomainControllers.TimeSynchronizationExternal.Source.Parameters.TimeSource = '1.pool.ntp.org'

$Sources = @(
    #'ForestFSMORoles'
    'ForestOptionalFeatures'
    #'ForestBackup'
    #'ForestOrphanedAdmins'
    'DomainPasswordComplexity'
    #'DomainKerberosAccountAge'
    #'DomainDNSScavengingForPrimaryDNSServer'
    #'DCWindowsUpdates'
    'DCTimeSynchronizationExternal'
)

$TestResults = Invoke-Testimo -ReturnResults -ExcludeDomains 'ad.evotec.pl' -ExtendedResults -Sources $Sources -Configuration $OutputOrderedDictionary -ShowReport
$TestResults | Format-Table -AutoSize *