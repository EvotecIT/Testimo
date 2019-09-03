Import-Module .\Testimo.psd1 -Force #-Verbose

$Sources = @(
    #'ForestFSMORoles'
    #'ForestOptionalFeatures'
    #'ForestOrphanedAdmins'
    #'DomainPasswordComplexity'
    #'DomainKerberosAccountAge'
    #'DomainDNSScavengingForPrimaryDNSServer'
    #'DomainSysVolDFSR'
    #'DCRDPSecurity'
    #'DCSMBShares'
    'DomainGroupPolicyMissingPermissions'
    'DCWindowsRolesAndFeatures'
)
#$ExludeDomainControllers = 'ad1.ad.evotec.xyz', 'ad2.ad.evotec.xyz'
#$ExludeDomainControllers = 'dc1.ad.evotec.pl','adpreview2019.ad.evotec.pl'

$TestResults = Invoke-Testimo -ReturnResults  -ExtendedResults -Sources $Sources #-ExcludeDomains 'ad.evotec.xyz' -ExcludeDomainControllers $ExludeDomainControllers
$TestResults | Format-Table -AutoSize *

return

New-HTML -FilePath $PSScriptRoot\Output\TestimoSummary.html {
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
                if ($TestResults.ReportData[$Key]['SourceCode']) {

                    $Code = $TestResults.ReportData[$Key]['SourceCode'].ToString()
                    $ExtraCode = $Code.Split([System.Environment]::NewLine)
                    $Length = 500
                    $NewCode = foreach ($Line in $ExtraCode) {
                        if ($Line.Trim() -ne '') {
                            $TempLength = ($line -replace '^(\s+).+$', '$1').Length
                            if ($TempLength -le $Length) {
                                $Length = $TempLength
                            }
                            $Line
                        }
                    }
                    $FixedCode = foreach ($Line in $NewCode) {
                        $Line.Substring($Length)
                    }
                    $FinalCode = $FixedCode -join [System.Environment]::NewLine

                    New-HTMLContent -HeaderText 'Source Code for Test' {
                        New-HTMLCodeBlock -Code $FinalCode -Style 'PowerShell' -Theme enlighter
                    }
                }
                New-HTMLContainer {
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
    }

} -ShowHTML