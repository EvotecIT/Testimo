Import-Module .\Testimo.psd1 -Force #-Verbose

$TestResults = Invoke-Testimo -Sources DCLanManagerSettings,DCTimeSettings, DCTimeSynchronizationInternal,DCDiagnostics -ShowReport:$true -ExcludeDomains 'ad.evotec.pl' -ReturnResults #, ForestBackup, DomainDNSZonesDomain0ADEL, DCEventLogs, ForestReplicationStatus #,DomainDNSZonesForest0ADEL,DCEventLogs#-ShowReport # -ExcludeDomains 'ad.evotec.pl' -ExcludeDomainControllers 'ADRODC.ad.evotec.pl' -ReturnResults
$TestResults | Format-Table -AutoSize *