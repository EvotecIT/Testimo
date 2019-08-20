Import-Module .\Testimo.psd1 -Force #-Verbose

$Results = Test-ImoAD -ReturnResults
$Results | Format-Table -AutoSize *