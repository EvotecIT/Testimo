Import-Module .\Testimo.psd1 -Force #-Verbose

$TestResults = Invoke-Testimo -Sources DCTimeSynchronizationExternal -ShowReport -ExcludeDomains 'ad.evotec.pl' #, ForestBackup, DomainDNSZonesDomain0ADEL, DCEventLogs, ForestReplicationStatus #,DomainDNSZonesForest0ADEL,DCEventLogs#-ShowReport # -ExcludeDomains 'ad.evotec.pl' -ExcludeDomainControllers 'ADRODC.ad.evotec.pl' -ReturnResults
$TestResults | Format-Table -AutoSize *