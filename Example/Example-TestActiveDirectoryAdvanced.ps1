Import-Module .\Testimo.psd1 -Force #-Verbose

$Sources = @(
    #'ForestFSMORoles'
    #'ForestOptionalFeatures'
    #'ForestOrphanedAdmins'
    #'DomainPasswordComplexity'
    #'DomainKerberosAccountAge'
    #'DomainDNSScavengingForPrimaryDNSServer'
    #'DomainSysVolDFSR'
    'DCRDPSecurity'
    'DCSMBShares'
    'DomainGroupPolicyMissingPermissions'
    #'DCWindowsRolesAndFeatures'
    'DCNTDSParameters'
    'DCInformation'
    # 'ForestReplicationStatus'
)
#$ExludeDomainControllers = 'ad1.ad.evotec.xyz', 'ad2.ad.evotec.xyz'
#$ExludeDomainControllers = 'dc1.ad.evotec.pl','adpreview2019.ad.evotec.pl'

#$TestResults = Invoke-Testimo -ReturnResults  -ExtendedResults -Sources $Sources -ExcludeDomains 'ad.evotec.pl' #-ExcludeDomainControllers $ExludeDomainControllers
#$TestResults | Format-Table -AutoSize *


#$TestResults['Results'] | ft -AutoSize

$TestResults['ReportData'] | ft -AutoSize

$TestResults['ReportData']['Forest'] | ft -a
$TestResults['ReportData']['Domains'] | ft -a

foreach ($Domain in $TestResults['ReportData']['Domains'].Keys) {
    $TestResults['ReportData']['Domains'][$Domain] | ft -a


}

return

if ($TestResults -and $TestResults['Results']) {
    [Array] $PassedTests = $TestResults['Results'] | Where-Object { $_.Status -eq $true }
    [Array] $FailedTests = $TestResults['Results'] | Where-Object { $_.Status -ne $true }

    New-HTML -FilePath $PSScriptRoot\Output\TestimoSummary.html -UseCssLinks -UseJavaScriptLinks {
        New-HTMLTab -Name 'Summary' {
            New-HTMLSection -HeaderText "Tests results" -HeaderBackGroundColor DarkGray {
                New-HTMLPanel {
                    New-HTMLChart {
                        New-ChartPie -Name 'Passed' -Value ($PassedTests.Count) -Color ForestGreen
                        New-ChartPie -Name 'Failed' -Value ($FailedTests.Count) -Color OrangeRed
                    }
                }
                New-HTMLPanel {
                    New-HTMLTable -DataTable $TestResults['Results'] {
                        New-HTMLTableCondition -Name 'Status' -Value $true -Color Green -Row
                        New-HTMLTableCondition -Name 'Status' -Value $false -Color Red -Row
                    }
                }
            }
        }
        New-HTMLTab -Name 'All Tests' {
            foreach ($Key in $TestResults.ReportData.Keys) {

                New-HTMLSection -HeaderText $TestResults.ReportData[$Key]['Name'] {
                    [Array] $PassedTestsSingular = $TestResults.ReportData[$Key]['Results'] | Where-Object { $_.Status -eq $true }
                    [Array] $FailedTestsSingular = $TestResults.ReportData[$Key]['Results'] | Where-Object { $_.Status -ne $true }
                    New-HTMLContainer {
                        #New-HTMLPanel {

                        # }
                        #New-HTMLPanel {
                        if ($TestResults.ReportData[$Key]['SourceCode']) {
                            #New-HTMLContent -HeaderText 'Source Code for Test' {
                            New-HTMLCodeBlock -Code $TestResults.ReportData[$Key]['SourceCode'] -Style 'PowerShell' -Theme enlighter
                            #}
                        }
                        #}
                        New-HTMLChart {
                            New-ChartPie -Name 'Passed' -Value ($PassedTestsSingular.Count) -Color ForestGreen
                            New-ChartPie -Name 'Failed' -Value ($FailedTestsSingular.Count) -Color OrangeRed
                        }
                    }
                    New-HTMLContainer {
                        ## New-HTMLSection -HeaderText "Tests data" {
                        New-HTMLTable -DataTable $TestResults.ReportData[$Key]['Data']
                        #}
                        #New-HTMLSection -HeaderText "Tests results" {
                        New-HTMLTable -DataTable $TestResults.ReportData[$Key]['Results'] {
                            New-HTMLTableCondition -Name 'Status' -Value $true -Color Green -Row
                            New-HTMLTableCondition -Name 'Status' -Value $false -Color Red -Row
                        }
                        # }
                    }
                }
            }
        }

    } -ShowHTML
}