Import-Module .\Testimo.psd1 -Force #-Verbose

$TestResults = Invoke-Testimo -ExcludeDomains 'ad.evotec.pl' -ExludeDomainControllers 'ADRODC.ad.evotec.pl' -ReturnResults
$TestResults | Format-Table -AutoSize *