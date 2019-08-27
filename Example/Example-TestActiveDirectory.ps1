Import-Module .\Testimo.psd1 -Force #-Verbose

$TestResults = Test-IMO -ReturnResults -ShowErrors -ExludeDomains 'ad.evotec.pl'#-ExludeDomainControllers 'ADRODC.ad.evotec.pl'
#$TestResults | Format-Table -AutoSize *