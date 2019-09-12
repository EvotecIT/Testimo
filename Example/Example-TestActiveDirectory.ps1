Import-Module .\Testimo.psd1 -Force #-Verbose

$TestResults = Invoke-Testimo -Sources DomainDNSZonesDomain0ADEL,DomainDNSZonesForest0ADEL,DCEventLogs #-ShowReport # -ExcludeDomains 'ad.evotec.pl' -ExcludeDomainControllers 'ADRODC.ad.evotec.pl' -ReturnResults
$TestResults | Format-Table -AutoSize *