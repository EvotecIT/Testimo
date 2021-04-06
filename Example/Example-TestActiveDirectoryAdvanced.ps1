﻿Import-Module .\Testimo.psd1 -Force #-Verbose

$Sources = @(
    'ForestRoles'
    'ForestOptionalFeatures'
    'ForestOrphanedAdmins'
    'DomainPasswordComplexity'
    'DomainKerberosAccountAge'
    'DomainDNSScavengingForPrimaryDNSServer'
    'DomainSysVolDFSR'
    'DCRDPSecurity'
    'DCSMBShares'
    'DomainGroupPolicyMissingPermissions'
    'DCWindowsRolesAndFeatures'
    'DCNTDSParameters'
    'DCInformation'
    'ForestReplicationStatus'
)

$TestResults = Invoke-Testimo -ReturnResults  -ExtendedResults -Sources $Sources #-ExcludeDomains 'ad.evotec.pl' #-ExcludeDomainControllers $ExludeDomainControllers

New-HTML -FilePath $PSScriptRoot\Output\TestimoSummary.html -Online {
    [Array] $PassedTests = $TestResults['Results'] | Where-Object { $_.Status -eq $true }
    [Array] $FailedTests = $TestResults['Results'] | Where-Object { $_.Status -ne $true }
    New-HTMLTab -Name 'Summary' -IconBrands galactic-senate {
        New-HTMLSection -HeaderText "Tests results" -HeaderBackGroundColor DarkGray {
            New-HTMLPanel {
                New-HTMLChart {
                    New-ChartPie -Name 'Passed' -Value ($TestResults['Summary'].Passed) -Color ForestGreen
                    New-ChartPie -Name 'Failed' -Value ($TestResults['Summary'].Failed) -Color OrangeRed
                    New-ChartPie -Name 'Failed' -Value ($TestResults['Summary'].Skipped) -Color LightBlue
                }
                New-HTMLTable -DataTable $TestResults['Summary'] -HideFooter -DisableSearch {
                    New-HTMLTableContent -ColumnName 'Passed' -BackGroundColor ForestGreen -Color White
                    New-HTMLTableContent -ColumnName 'Failed' -BackGroundColor OrangeRed -Color White
                    New-HTMLTableContent -ColumnName 'Skipped' -BackGroundColor LightBlue -Color White
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
    New-HTMLTab -Name 'Forest' -IconBrands first-order {
        foreach ($Source in $TestResults['Forest']['Tests'].Keys) {

            $Name = $TestResults['Forest']['Tests'][$Source]['Name']
            $Data = $TestResults['Forest']['Tests'][$Source]['Data']
            $SourceCode = $TestResults['Forest']['Tests'][$Source]['SourceCode']
            $Results = $TestResults['Forest']['Tests'][$Source]['Results']
            #$Details = $TestResults['Forest']['Tests'][$Source]['Details']
            [Array] $PassedTestsSingular = $TestResults['Forest']['Tests'][$Source]['Results'] | Where-Object { $_.Status -eq $true }
            [Array] $FailedTestsSingular = $TestResults['Forest']['Tests'][$Source]['Results'] | Where-Object { $_.Status -ne $true }

            New-HTMLSection -HeaderText $Name -HeaderBackGroundColor DarkGray -CanCollapse {
                New-HTMLContainer {
                    New-HTMLPanel {
                        New-HTMLChart {
                            New-ChartPie -Name 'Passed' -Value ($PassedTestsSingular.Count) -Color ForestGreen
                            New-ChartPie -Name 'Failed' -Value ($FailedTestsSingular.Count) -Color OrangeRed
                        }
                        New-HTMLCodeBlock -Code $SourceCode -Style 'PowerShell' -Theme enlighter
                    }
                }
                New-HTMLContainer {
                    New-HTMLPanel {
                        New-HTMLTable -DataTable $Data
                        New-HTMLTable -DataTable $Results {
                            New-HTMLTableCondition -Name 'Status' -Value $true -Color Green -Row
                            New-HTMLTableCondition -Name 'Status' -Value $false -Color Red -Row
                        }
                    }
                }
            }
        }
    }

    foreach ($Domain in $TestResults['Domains'].Keys) {
        New-HTMLTab -Name "Domain $Domain" -IconBrands deskpro {
            foreach ($Source in $TestResults['Domains'][$Domain]['Tests'].Keys) {
                $Name = $TestResults['Domains'][$Domain]['Tests'][$Source]['Name']
                $Data = $TestResults['Domains'][$Domain]['Tests'][$Source]['Data']
                $SourceCode = $TestResults['Domains'][$Domain]['Tests'][$Source]['SourceCode']
                $Results = $TestResults['Domains'][$Domain]['Tests'][$Source]['Results']
                # $Details = $TestResults['Domains'][$Domain]['Tests'][$Source]['Details']
                [Array] $PassedTestsSingular = $TestResults['Domains'][$Domain]['Tests'][$Source]['Results'] | Where-Object { $_.Status -eq $true }
                [Array] $FailedTestsSingular = $TestResults['Domains'][$Domain]['Tests'][$Source]['Results'] | Where-Object { $_.Status -ne $true }

                New-HTMLSection -HeaderText $Name -HeaderBackGroundColor DarkGray -CanCollapse {
                    New-HTMLContainer {
                        New-HTMLPanel {
                            New-HTMLChart {
                                New-ChartPie -Name 'Passed' -Value ($PassedTestsSingular.Count) -Color ForestGreen
                                New-ChartPie -Name 'Failed' -Value ($FailedTestsSingular.Count) -Color OrangeRed
                            }
                            New-HTMLCodeBlock -Code $SourceCode -Style 'PowerShell' -Theme enlighter
                        }
                    }
                    New-HTMLContainer {
                        New-HTMLPanel {
                            New-HTMLTable -DataTable $Data
                            New-HTMLTable -DataTable $Results {
                                New-HTMLTableCondition -Name 'Status' -Value $true -Color Green -Row
                                New-HTMLTableCondition -Name 'Status' -Value $false -Color Red -Row
                            }
                        }
                    }
                }
            }
            foreach ($DC in $TestResults['Domains'][$Domain]['DomainControllers'].Keys) {
                New-HTMLSection -HeaderText "Domain Controller - $DC" -HeaderBackGroundColor DarkSlateGray -CanCollapse {
                    New-HTMLContainer {
                        foreach ($Source in  $TestResults['Domains'][$Domain]['DomainControllers'][$DC]['Tests'].Keys) {
                            $Name = $TestResults['Domains'][$Domain]['DomainControllers'][$DC]['Tests'][$Source]['Name']
                            $Data = $TestResults['Domains'][$Domain]['DomainControllers'][$DC]['Tests'][$Source]['Data']
                            $SourceCode = $TestResults['Domains'][$Domain]['DomainControllers'][$DC]['Tests'][$Source]['SourceCode']
                            $Results = $TestResults['Domains'][$Domain]['DomainControllers'][$DC]['Tests'][$Source]['Results']
                            #$Details = $TestResults['Domains'][$Domain]['DomainControllers'][$DC]['Tests'][$Source]['Details']
                            [Array] $PassedTestsSingular = $TestResults['Domains'][$Domain]['DomainControllers'][$DC]['Tests'][$Source]['Results'] | Where-Object { $_.Status -eq $true }
                            [Array] $FailedTestsSingular = $TestResults['Domains'][$Domain]['DomainControllers'][$DC]['Tests'][$Source]['Results'] | Where-Object { $_.Status -ne $true }

                            New-HTMLSection -HeaderText $Name -HeaderBackGroundColor DarkGray {
                                New-HTMLContainer {
                                    New-HTMLPanel {
                                        New-HTMLChart {
                                            New-ChartPie -Name 'Passed' -Value ($PassedTestsSingular.Count) -Color ForestGreen
                                            New-ChartPie -Name 'Failed' -Value ($FailedTestsSingular.Count) -Color OrangeRed
                                        }
                                        New-HTMLCodeBlock -Code $SourceCode -Style 'PowerShell' -Theme enlighter
                                    }
                                }
                                New-HTMLContainer {
                                    New-HTMLPanel {
                                        New-HTMLTable -DataTable $Data
                                        New-HTMLTable -DataTable $Results {
                                            New-HTMLTableCondition -Name 'Status' -Value $true -Color Green -Row
                                            New-HTMLTableCondition -Name 'Status' -Value $false -Color Red -Row
                                        }
                                    }
                                }
                            }
                        }
                    }
                }
            }
        }
    }
} -ShowHTML