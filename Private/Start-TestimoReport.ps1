function Start-TestimoReport {
    [CmdletBinding()]
    param(
        [System.Collections.IDictionary] $TestResults,
        [string] $FilePath,
        [switch] $Online,
        [switch] $ShowHTML
    )

    if ($FilePath -eq '') {
        $FilePath = Get-FileName -Extension 'html' -Temporary
    }

    $ColorPassed = 'LawnGreen'
    $ColorSkipped = 'DeepSkyBlue'
    $ColorFailed = 'Tomato'
    $ColorPassedText = 'Black'
    $ColorFailedText = 'Black'
    $ColorSkippedText = 'Black'

    [Array] $PassedTests = $TestResults['Results'] | Where-Object { $_.Status -eq $true }
    [Array] $FailedTests = $TestResults['Results'] | Where-Object { $_.Status -eq $false }
    [Array] $SkippedTests = $TestResults['Results'] | Where-Object { $_.Status -ne $true -and $_.Status -ne $false }

    New-HTML -FilePath $FilePath -Online:$Online {
        New-HTMLSectionStyle -BorderRadius 0px -HeaderBackGroundColor Grey -RemoveShadow
        New-HTMLTableOption -DataStore JavaScript -BoolAsString
        New-HTMLTabStyle -BorderRadius 0px -BackgroundColorActive SlateGrey

        New-HTMLHeader {
            New-HTMLSection -Invisible {
                New-HTMLSection {
                    New-HTMLText -Text "Report generated on $(Get-Date)" -Color Blue
                } -JustifyContent flex-start -Invisible
                New-HTMLSection {
                    New-HTMLText -Text $Script:Reporting['Version'] -Color Blue
                } -JustifyContent flex-end -Invisible
            }
        }

        New-HTMLTab -Name 'Summary' -IconBrands galactic-senate {
            New-HTMLSection -HeaderText "Tests results" -HeaderBackGroundColor DarkGray {
                New-HTMLPanel {
                    New-HTMLChart {
                        New-ChartPie -Name 'Passed' -Value ($PassedTests.Count) -Color $ColorPassed
                        New-ChartPie -Name 'Failed' -Value ($FailedTests.Count) -Color $ColorFailed
                        New-ChartPie -Name 'Skipped' -Value ($SkippedTests.Count) -Color $ColorSkipped
                    }
                    New-HTMLTable -DataTable $TestResults['Summary'] -HideFooter -DisableSearch {
                        New-HTMLTableContent -ColumnName 'Passed' -BackGroundColor $ColorPassed -Color $ColorPassedText
                        New-HTMLTableContent -ColumnName 'Failed' -BackGroundColor $ColorFailed -Color $ColorFailedText
                        New-HTMLTableContent -ColumnName 'Skipped' -BackGroundColor $ColorSkipped -Color $ColorSkippedText
                    } -DataStore HTML #-DisablePaging -Buttons @()
                }
                New-HTMLPanel {
                    New-HTMLTable -DataTable $TestResults['Results'] {
                        New-HTMLTableCondition -Name 'Status' -Value $true -BackgroundColor $ColorPassed -Color $ColorPassedText #-Row
                        New-HTMLTableCondition -Name 'Status' -Value $false -BackgroundColor $ColorFailed -Color $ColorFailedText #-Row
                        New-HTMLTableCondition -Name 'Status' -Value $null -BackgroundColor $ColorSkipped -Color $ColorSkippedText #-Row
                    } #-Filtering
                }
            }
        }
        if ($TestResults['Forest']['Tests'].Count -gt 0) {
            New-HTMLTab -Name 'Forest' -IconBrands first-order {
                foreach ($Source in $TestResults['Forest']['Tests'].Keys) {
                    $Name = $TestResults['Forest']['Tests'][$Source]['Name']
                    $Data = $TestResults['Forest']['Tests'][$Source]['Data']
                    $SourceCode = $TestResults['Forest']['Tests'][$Source]['SourceCode']
                    $Results = $TestResults['Forest']['Tests'][$Source]['Results'] | Select-Object -Property Name, Type, Status, Extended
                    #$Details = $TestResults['Forest']['Tests'][$Source]['Details']
                    [Array] $PassedTestsSingular = $TestResults['Forest']['Tests'][$Source]['Results'] | Where-Object { $_.Status -eq $true }
                    [Array] $FailedTestsSingular = $TestResults['Forest']['Tests'][$Source]['Results'] | Where-Object { $_.Status -eq $false }
                    [Array] $SkippedTestsSingular = $TestResults['Forest']['Tests'][$Source]['Results'] | Where-Object { $_.Status -ne $true -and $_.Status -ne $false }

                    New-HTMLSection -HeaderText $Name -HeaderBackGroundColor DarkGray {
                        New-HTMLContainer {
                            New-HTMLPanel {
                                New-HTMLChart {
                                    New-ChartPie -Name 'Passed' -Value ($PassedTestsSingular.Count) -Color $ColorPassed
                                    New-ChartPie -Name 'Failed' -Value ($FailedTestsSingular.Count) -Color $ColorFailed
                                    New-ChartPie -Name 'Skipped' -Value ($SkippedTestsSingular.Count) -Color $ColorSkipped
                                }
                                #New-HTMLText -Text 'Following command was run to generate data on the right side. '
                                New-HTMLCodeBlock -Code $SourceCode -Style 'PowerShell' -Theme enlighter
                                if ($TestResults['Forest']['Tests'][$Source]['WarningsAndErrors']) {
                                    New-HTMLSection -HeaderText 'Warnings & Errors' -HeaderBackGroundColor OrangePeel {
                                        New-HTMLTable -DataTable $TestResults['Forest']['Tests'][$Source]['WarningsAndErrors'] -Filtering
                                    }
                                }
                            }
                        }
                        New-HTMLContainer {
                            New-HTMLPanel {
                                New-HTMLTable -DataTable $Data #-Filtering
                                New-HTMLTable -DataTable $Results {
                                    New-HTMLTableCondition -Name 'Status' -Value $true -BackgroundColor $ColorPassed -Color $ColorPassedText #-Row
                                    New-HTMLTableCondition -Name 'Status' -Value $false -BackgroundColor $ColorFailed -Color $ColorFailedText #-Row
                                    New-HTMLTableCondition -Name 'Status' -Value $null -BackgroundColor $ColorSkipped -Color $ColorSkippedText #-Row
                                } -Filtering
                            }
                        }
                    }
                }
            }
        }
        foreach ($Domain in $TestResults['Domains'].Keys) {
            if ($TestResults['Domains'][$Domain]['Tests'].Count -gt 0 -or $TestResults['Domains'][$Domain]['DomainControllers'].Count -gt 0) {
                New-HTMLTab -Name "Domain $Domain" -IconBrands deskpro {
                    foreach ($Source in $TestResults['Domains'][$Domain]['Tests'].Keys) {
                        $Name = $TestResults['Domains'][$Domain]['Tests'][$Source]['Name']
                        $Data = $TestResults['Domains'][$Domain]['Tests'][$Source]['Data']
                        $SourceCode = $TestResults['Domains'][$Domain]['Tests'][$Source]['SourceCode']
                        $Results = $TestResults['Domains'][$Domain]['Tests'][$Source]['Results'] | Select-Object -Property Name, Type, Status, Extended, Domain
                        # $Details = $TestResults['Domains'][$Domain]['Tests'][$Source]['Details']
                        [Array] $PassedTestsSingular = $TestResults['Domains'][$Domain]['Tests'][$Source]['Results'] | Where-Object { $_.Status -eq $true }
                        [Array] $FailedTestsSingular = $TestResults['Domains'][$Domain]['Tests'][$Source]['Results'] | Where-Object { $_.Status -eq $false }
                        [Array] $SkippedTestsSingular = $TestResults['Domains'][$Domain]['Tests'][$Source]['Results'] | Where-Object { $_.Status -ne $true -and $_.Status -ne $false }

                        New-HTMLSection -HeaderText $Name -HeaderBackGroundColor DarkGray {
                            New-HTMLContainer {
                                New-HTMLPanel {
                                    New-HTMLChart {
                                        New-ChartPie -Name 'Passed' -Value ($PassedTestsSingular.Count) -Color $ColorPassed
                                        New-ChartPie -Name 'Failed' -Value ($FailedTestsSingular.Count) -Color $ColorFailed
                                        New-ChartPie -Name 'Skipped' -Value ($SkippedTestsSingular.Count) -Color $ColorSkipped
                                    }
                                    New-HTMLCodeBlock -Code $SourceCode -Style 'PowerShell' -Theme enlighter
                                    if ($TestResults['Domains'][$Domain]['Tests'][$Source]['WarningsAndErrors']) {
                                        New-HTMLSection -HeaderText 'Warnings & Errors' -HeaderBackGroundColor OrangePeel {
                                            New-HTMLTable -DataTable $TestResults['Domains'][$Domain]['Tests'][$Source]['WarningsAndErrors'] -Filtering
                                        }
                                    }
                                }
                            }
                            New-HTMLContainer {
                                New-HTMLPanel {
                                    New-HTMLTable -DataTable $Data -Filtering
                                    New-HTMLTable -DataTable $Results {
                                        New-HTMLTableCondition -Name 'Status' -Value $true -BackgroundColor $ColorPassed -Color $ColorPassedText #-Row
                                        New-HTMLTableCondition -Name 'Status' -Value $false -BackgroundColor $ColorFailed -Color $ColorFailedText #-Row
                                        New-HTMLTableCondition -Name 'Status' -Value $null -BackgroundColor $ColorSkipped -Color $ColorSkippedText #-Row
                                    } -Filtering
                                }
                            }
                        }
                    }
                    if ($TestResults['Domains'][$Domain]['DomainControllers'].Count -gt 0) {
                        foreach ($DC in $TestResults['Domains'][$Domain]['DomainControllers'].Keys) {
                            New-HTMLSection -HeaderText "Domain Controller - $DC" -HeaderBackGroundColor DarkSlateGray {
                                New-HTMLContainer {
                                    foreach ($Source in  $TestResults['Domains'][$Domain]['DomainControllers'][$DC]['Tests'].Keys) {
                                        $Name = $TestResults['Domains'][$Domain]['DomainControllers'][$DC]['Tests'][$Source]['Name']
                                        $Data = $TestResults['Domains'][$Domain]['DomainControllers'][$DC]['Tests'][$Source]['Data']
                                        $SourceCode = $TestResults['Domains'][$Domain]['DomainControllers'][$DC]['Tests'][$Source]['SourceCode']
                                        $Results = $TestResults['Domains'][$Domain]['DomainControllers'][$DC]['Tests'][$Source]['Results']
                                        #$Details = $TestResults['Domains'][$Domain]['DomainControllers'][$DC]['Tests'][$Source]['Details']
                                        [Array] $PassedTestsSingular = $TestResults['Domains'][$Domain]['DomainControllers'][$DC]['Tests'][$Source]['Results'] | Where-Object { $_.Status -eq $true }
                                        [Array] $FailedTestsSingular = $TestResults['Domains'][$Domain]['DomainControllers'][$DC]['Tests'][$Source]['Results'] | Where-Object { $_.Status -eq $false }
                                        [Array] $SkippedTestsSingular = $TestResults['Domains'][$Domain]['DomainControllers'][$DC]['Tests'][$Source]['Results'] | Where-Object { $_.Status -ne $true -and $_.Status -ne $false }

                                        New-HTMLSection -HeaderText $Name -HeaderBackGroundColor DarkGray {
                                            New-HTMLContainer {
                                                New-HTMLPanel {
                                                    New-HTMLChart {
                                                        New-ChartPie -Name 'Passed' -Value ($PassedTestsSingular.Count) -Color $ColorPassed
                                                        New-ChartPie -Name 'Failed' -Value ($FailedTestsSingular.Count) -Color $ColorFailed
                                                        New-ChartPie -Name 'Skipped' -Value ($SkippedTestsSingular.Count) -Color $ColorSkipped
                                                    }
                                                    New-HTMLCodeBlock -Code $SourceCode -Style 'PowerShell' -Theme enlighter
                                                    if ($TestResults['Domains'][$Domain]['DomainControllers'][$DC]['Tests'][$Source]['WarningsAndErrors']) {
                                                        New-HTMLSection -HeaderText 'Warnings & Errors' -HeaderBackGroundColor OrangePeel {
                                                            New-HTMLTable -DataTable $TestResults['Domains'][$Domain]['DomainControllers'][$DC]['Tests'][$Source]['WarningsAndErrors'] -Filtering
                                                        }
                                                    }
                                                }
                                            }
                                            New-HTMLContainer {
                                                New-HTMLPanel {
                                                    New-HTMLTable -DataTable $Data -Filtering
                                                    New-HTMLTable -DataTable $Results {
                                                        New-HTMLTableCondition -Name 'Status' -Value $true -BackgroundColor $ColorPassed -Color $ColorPassedText #-Row
                                                        New-HTMLTableCondition -Name 'Status' -Value $false -BackgroundColor $ColorFailed -Color $ColorFailedText #-Row
                                                        New-HTMLTableCondition -Name 'Status' -Value $null -BackgroundColor $ColorSkipped -Color $ColorSkippedText #-Row
                                                    } -Filtering
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
        }
    } -ShowHTML:$ShowHTML
}