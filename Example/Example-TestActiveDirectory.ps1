Import-Module .\Testimo.psd1 -Force

$Results = Test-ImoAD -ReturnResults
#$Results | Format-Table -AutoSize *


#$Results.Count
#$Domain1 = $Results | Where-Object { $_.Domain -eq 'ad.evotec.xyz' }
#$Domain2 = $Results | Where-Object { $_.Domain -eq 'ad.evotec.pl' }
#$Domain1.Count
#$Domain2.Count

