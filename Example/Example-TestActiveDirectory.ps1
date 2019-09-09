Import-Module .\Testimo.psd1 -Force #-Verbose

$TestResults = Invoke-Testimo -ExcludeDomains 'ad.evotec.pl' -ExcludeDomainControllers 'ADRODC.ad.evotec.pl' -ReturnResults -Sources DCPorts,DCNetworkCardSettings
$TestResults | Format-Table -AutoSize *