Import-Module .\Testimo.psd1 -Force #-Verbose

$Sources = @(
    #'ForestFSMORoles'
    #'ForestOptionalFeatures'
    #'ForestOrphanedAdmins'
    #'DomainPasswordComplexity'
    #'DomainKerberosAccountAge'
    #'DomainDNSScavengingForPrimaryDNSServer'
)


$TestResults = Test-IMO -ReturnResults -ExcludeDomains 'ad.evotec.pl' -ExtendedResults #-Sources $Sources   #-ShowErrors #-ExludeDomainControllers 'ADRODC.ad.evotec.pl'
$TestResults | Format-Table -AutoSize *

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
                if ($TestResults.ReportData[$Key]['SourceCode']) {

                    #$Code = $TestResults.ReportData[$Key]['SourceCode']
                    <#
                    # Fixing space
                    $Fulllength = (($TestResults.ReportData[$Key]['SourceCode'])[0]).ToString().Length
                    $TrimmedLength = (($TestResults.ReportData[$Key]['SourceCode'])[0]).ToString().TrimStart().Length
                    $RemoveChars = $Fulllength - $TrimmedLength

                    $ConvertedScriptBlock = ($TestResults.ReportData[$Key]['SourceCode']).ToString().Split([System.Environment]::NewLine)
                    $CoolCode = foreach ($C in $ConvertedScriptBlock) {
                        if (-not $C.Trim().Length -eq 0) {
                            $C
                        }
                    }


                    $Code = foreach ($C in $CoolCode) {
                        ($C).Substring($RemoveChars)
                    }
                    $Code = $Code -join [System.Environment]::NewLine
                    #>

                    New-HTMLContent -HeaderText 'Source Code for Test' {
                        New-HTMLCodeBlock -Code $TestResults.ReportData[$Key]['SourceCode'] -Style 'PowerShell' -Theme enlighter
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