Import-Module .\Testimo.psd1 -Force

$Results = Test-ImoAD -ReturnResults
$Results | Format-Table -AutoSize *