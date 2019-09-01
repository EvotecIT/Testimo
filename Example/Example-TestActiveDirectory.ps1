Import-Module .\Testimo.psd1 -Force #-Verbose

$TestResults = Test-IMO -ExcludeDomains 'ad.evotec.pl' -ExludeDomainControllers 'ADRODC.ad.evotec.pl' -ReturnResults
$TestResults | Format-Table -AutoSize *