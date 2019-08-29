Import-Module .\Testimo.psd1 -Force #-Verbose

$TestResults = Test-IMO -ReturnResults -ExludeDomains 'ad.evotec.pl' #-ShowErrors #-ExludeDomainControllers 'ADRODC.ad.evotec.pl'
#$TestResults | Format-Table -AutoSize *