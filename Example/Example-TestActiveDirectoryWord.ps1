
Import-Module .\Testimo.psd1 -Force #-Verbose

$Sources = @(
    'ForestRoles'
    'ForestOptionalFeatures'
    <#
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
    #>
)

$TestResults = Invoke-Testimo -ReturnResults  -ExtendedResults -Sources $Sources

Documentimo -FilePath "$PSScriptRoot\Starter-AD.docx" {
    DocToc -Title 'Table of content'

    DocPageBreak

    #DocText {
    #    "This document provides low-level documentation of Active Directory infrastructure in Evotec organization. This document contains general data that has been exported from Active Directory and provides an overview of the whole environment."
    #}

    DocNumbering -Text 'Forest Information' -Level 0 -Type Numbered -Heading Heading1 {


        foreach ($Source in $TestResults['Forest']['Tests'].Keys) {

            $Name = $TestResults['Forest']['Tests'][$Source]['Name']
            $Data = $TestResults['Forest']['Tests'][$Source]['Data']
            $SourceCode = $TestResults['Forest']['Tests'][$Source]['SourceCode']
            $Results = $TestResults['Forest']['Tests'][$Source]['Results']
            $Details = $TestResults['Forest']['Tests'][$Source]['Details']
            $DetailsTest = $TestResults['Forest']['Tests'][$Source]['DetailsTests']
            $ResultsTest = $TestResults['Forest']['Tests'][$Source]['ResultsTest']

            #$Details = $TestResults['Forest']['Tests'][$Source]['Details']
            [Array] $PassedTestsSingular = $TestResults['Forest']['Tests'][$Source]['Results'] | Where-Object { $_.Status -eq $true }
            [Array] $FailedTestsSingular = $TestResults['Forest']['Tests'][$Source]['Results'] | Where-Object { $_.Status -ne $true }


            DocNumbering -Text "General Information - $Name" -Level 1 -Type Numbered -Heading Heading1 {


                #DocTable -DataTable $Results
            }
        }
    }
    foreach ($Domain in $TestResults['Domains'].Keys) {
        DocNumbering -Text "Domain $Domain" -Level 0 -Type Numbered -Heading Heading1 {
            foreach ($Source in $TestResults['Domains'][$Domain]['Tests'].Keys) {
                $Name = $TestResults['Domains'][$Domain]['Tests'][$Source]['Name']
                $Data = $TestResults['Domains'][$Domain]['Tests'][$Source]['Data']
                $SourceCode = $TestResults['Domains'][$Domain]['Tests'][$Source]['SourceCode']
                $Results = $TestResults['Domains'][$Domain]['Tests'][$Source]['Results']
                $Details = $TestResults['Domains'][$Domain]['Tests'][$Source]['Details']

                [Array] $PassedTestsSingular = $TestResults['Domains'][$Domain]['Tests'][$Source]['Results'] | Where-Object { $_.Status -eq $true }
                [Array] $FailedTestsSingular = $TestResults['Domains'][$Domain]['Tests'][$Source]['Results'] | Where-Object { $_.Status -ne $true }


                DocNumbering -Text "$Name" -Level 1 -Type Numbered -Heading Heading1 {
                    <#
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
                    #>
                }
            }
            foreach ($DC in $TestResults['Domains'][$Domain]['DomainControllers'].Keys) {
                DocNumbering -Text "Domain Controller - $DC" -Level 1 -Type Numbered -Heading Heading1 {
                    #New-HTMLSection -HeaderText "Domain Controller - $DC" -HeaderBackGroundColor DarkSlateGray {

                    foreach ($Source in  $TestResults['Domains'][$Domain]['DomainControllers'][$DC]['Tests'].Keys) {
                        $Name = $TestResults['Domains'][$Domain]['DomainControllers'][$DC]['Tests'][$Source]['Name']
                        $Data = $TestResults['Domains'][$Domain]['DomainControllers'][$DC]['Tests'][$Source]['Data']
                        $SourceCode = $TestResults['Domains'][$Domain]['DomainControllers'][$DC]['Tests'][$Source]['SourceCode']
                        $Results = $TestResults['Domains'][$Domain]['DomainControllers'][$DC]['Tests'][$Source]['Results']
                        $Details = $TestResults['Domains'][$Domain]['DomainControllers'][$DC]['Tests'][$Source]['Details']
                        [Array] $PassedTestsSingular = $TestResults['Domains'][$Domain]['DomainControllers'][$DC]['Tests'][$Source]['Results'] | Where-Object { $_.Status -eq $true }
                        [Array] $FailedTestsSingular = $TestResults['Domains'][$Domain]['DomainControllers'][$DC]['Tests'][$Source]['Results'] | Where-Object { $_.Status -ne $true }

                        DocNumbering -Text "$Name" -Level 2 -Type Numbered -Heading Heading1 {


                            DocText -Text "Area: ", $Details.Area
                            DocText -Text "Description: ", $Details.Description
                            DocText -Text "Resolution: ", $Details.Resolution
                            DocText -Text "RiskLevel: ", $Details.RiskLevel

                            DocList -Type Bulleted {
                                foreach ($Resource in $Details.Resources) {
                                    DocListItem -Text $Resource
                                }
                            }
                            #DocList -Type Numbered {
                            #    DocListItem -Text 'Test' -Level 0
                            #    DocListItem -Text 'Test1' -Level 2
                            #}
                            # New-HTMLSection -HeaderText $Name -HeaderBackGroundColor DarkGray {
                            <#
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
                            #>
                        }
                    }

                }
            }
        }
    }

    <#
    DocNumbering -Text 'General Information - Forest Summary' -Level 0 -Type Numbered -Heading Heading1 {
        DocText {
            "Active Directory at $CompanyName has a forest name $($ADForest.ForestInformation.Name). Following table contains forest summary with important information:"
        }
        DocTable -DataTable $ADForest.ForestInformation -Design ColorfulGridAccent5 -AutoFit Window -OverwriteTitle 'Forest Summary'
        DocText -LineBreak

        DocText -Text 'Following table contains FSMO servers:'
        DocTable -DataTable $ADForest.ForestFSMO -Design ColorfulGridAccent5 -AutoFit Window -OverwriteTitle 'FSMO Roles'
        DocText -LineBreak

        DocText -Text 'Following table contains optional forest features:'
        DocTable -DataTable $ADForest.ForestOptionalFeatures -Design ColorfulGridAccent5 -AutoFit Window -OverwriteTitle 'Optional Features'
        DocText -LineBreak

    }
    #>
} -Open