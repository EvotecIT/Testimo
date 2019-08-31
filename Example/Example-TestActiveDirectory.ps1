Import-Module .\Testimo.psd1 -Force #-Verbose

$TestResults = Test-IMO -ReturnResults #-ExludeDomains 'ad.evotec.pl' -ExtendedResults #-ShowErrors #-ExludeDomainControllers 'ADRODC.ad.evotec.pl'
$TestResults | Format-Table -AutoSize *

return

New-HTML -FilePath $PSScriptRoot\ShowMeTheMoney.html {

    New-HTMLTab -Name 'Summary' {
        New-HTMLSection -HeaderText "Tests results" -HeaderBackGroundColor DarkGray {
            New-HTMLTable -DataTable $TestResults['Results'] {
                New-HTMLTableCondition -Name 'Status' -Value $true -Color Green -Row
                New-HTMLTableCondition -Name 'Status' -Value $false -Color Red -Row
            }
        }
    }
    New-HTMLTab -Name 'All Tests' {
        foreach ($Key in $TestResults.ReportData.Keys) {
            New-HTMLSection -HeaderText $TestResults.ReportData[$Key]['Name'] {

                New-HTMLSection -HeaderText "Tests data" {
                    New-HTMLTable -DataTable $TestResults.ReportData[$Key]['Data']
                }
                New-HTMLSection -HeaderText "Tests results" {
                    New-HTMLTable -DataTable $TestResults.ReportData[$Key]['Results'] {
                        New-HTMLTableCondition -Name 'Status' -Value $true -Color Green -Row
                        New-HTMLTableCondition -Name 'Status' -Value $false -Color Red -Row
                    }
                }
            }
        }
    }

} -ShowHTML

#$Script:TestimoConfiguration.Forest.Sources