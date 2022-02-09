function Start-TestimoReportSummaryAdvanced {
    [CmdletBinding()]
    param(
        [System.Collections.IDictionary] $TestResults
    )

    $ChartData = New-ChartData -Results $TestResults['Results']
    $TableData = [ordered] @{}
    $TableData['Total'] = 0
    foreach ($Chart in $ChartData.Keys) {
        $TableData[$Chart] = $ChartData[$Chart].Count
        $TableData['Total'] = $TableData['Total'] + $ChartData[$Chart].Count
    }
    $DisplayTableData = [PSCustomObject] $TableData

    New-HTMLTab -Name 'Summary' -IconBrands galactic-senate {
        New-HTMLSection -Invisible {
            New-HTMLContainer {
                New-HTMLPanel {
                    New-HTMLSummary -Title 'Testimo Summary' {
                        foreach ($Source in $TestResults.BySource.Keys) {
                            $SourceData = $TestResults.BySource[$Source]
                            $Results = $TestResults.BySource[$Source].Results

                            $CountBad = 0
                            $CountGood = 0
                            foreach ($Result in $Results) {
                                if ($Result.Assessment -in 'Informational', 'Good') {
                                    $CountGood++
                                } else {
                                    $CountBad++
                                }
                            }

                            if ($CountGood -gt 0 -and $CountBad -gt 0) {
                                $ItemConfiguration = @{
                                    IconColor = 'Orange'
                                    IconSolid = 'exclamation-circle'
                                }
                            } elseif ($CountBad -gt 0) {
                                $ItemConfiguration = @{
                                    IconColor = 'Red'
                                    IconSolid = 'window-close'
                                }
                            } else {
                                $ItemConfiguration = @{
                                    IconColor   = 'DarkPastelGreen'
                                    IconRegular = 'check-circle'
                                }
                            }
                            $NameOfItem = "$($SourceData.Name) (number of tests: $($Results.Count))"
                            Write-Verbose -Message "Generating SummaryItem for $NameOfItem"
                            New-HTMLSummaryItem -Text $NameOfItem {
                                foreach ($Result in $Results) {
                                    if ($Result.Assessment -in 'Informational', 'Good') {
                                        $ItemConfigurationTest = @{
                                            IconColor   = 'DarkPastelGreen'
                                            IconRegular = 'check-circle'
                                        }
                                    } else {
                                        $ItemConfigurationTest = @{
                                            IconColor = 'Red'
                                            IconSolid = 'window-close'
                                        }
                                    }
                                    New-HTMLSummaryItem -Text $Result.DisplayName {
                                        New-HTMLSummaryItemData -Text "type" -Value ($Result.Type -join ",")
                                        New-HTMLSummaryItemData -Text "category" -Value ($Result.Category -join ",")
                                        # New-HTMLSummaryItemData -Text "assesment" -Value $Result.Assessment
                                        # New-HTMLSummaryItemData -Text "action" -Value $Result.Action
                                        # New-HTMLSummaryItemData -Text "importance" -Value $Result.Importance
                                    } @ItemConfigurationTest
                                }
                            } @ItemConfiguration
                        }
                    }
                } -BorderRadius 0px
            } -Width '40%'
            New-HTMLContainer {
                New-HTMLPanel {
                    New-HTMLContainer {
                        New-HTMLChart {
                            #New-ChartPie -Name 'Passed' -Value ($PassedTests.Count) -Color $ColorPassed
                            #New-ChartPie -Name 'Failed' -Value ($FailedTests.Count) -Color $ColorFailed
                            #New-ChartPie -Name 'Skipped' -Value ($SkippedTests.Count) -Color $ColorSkipped
                            foreach ($Key in $ChartData.Keys) {
                                New-ChartPie -Name $Key -Value $ChartData[$Key].Count -Color $ChartData[$Key].Color
                            }
                        }
                        New-HTMLTable -DataTable $DisplayTableData -HideFooter -DisableSearch {
                            foreach ($Chart in $ChartData.Keys) {
                                New-HTMLTableContent -ColumnName $Chart -BackGroundColor $ChartData[$Chart].Color -Color Black
                            }
                            #New-HTMLTableContent -ColumnName 'Passed' -BackGroundColor $TestResults['Configuration']['Colors']['ColorPassed'] -Color $TestResults['Configuration']['Colors']['ColorPassedText']
                            #New-HTMLTableContent -ColumnName 'Failed' -BackGroundColor $TestResults['Configuration']['Colors']['ColorFailed'] -Color $TestResults['Configuration']['Colors']['ColorFailedText']
                            #New-HTMLTableContent -ColumnName 'Skipped' -BackGroundColor $TestResults['Configuration']['Colors']['ColorSkipped'] -Color $TestResults['Configuration']['Colors']['ColorSkippedText']
                        } -DataStore HTML -Buttons @() -DisablePaging -DisableInfo -DisableOrdering
                    }
                    New-HTMLContainer {
                        New-HTMLSection -HeaderText "Tests results" -HeaderBackGroundColor DarkGray {
                            $ResultsDisplay = $TestResults['Results'] | Select-Object -Property DisplayName, Type, Category, Assessment, Importance, Action, Extended, Domain, DomainController
                            New-HTMLTable -DataTable $ResultsDisplay {
                                #New-HTMLTableCondition -Name 'Status' -Value $true -BackgroundColor $TestResults['Configuration']['Colors']['ColorPassed'] -Color $TestResults['Configuration']['Colors']['ColorPassedText']  #-Row
                                #New-HTMLTableCondition -Name 'Status' -Value $false -BackgroundColor $TestResults['Configuration']['Colors']['ColorFailed'] -Color $TestResults['Configuration']['Colors']['ColorFailedText']  #-Row
                                #New-HTMLTableCondition -Name 'Status' -Value $null -BackgroundColor $TestResults['Configuration']['Colors']['ColorSkipped'] -Color $TestResults['Configuration']['Colors']['ColorSkippedText']  #-Row
                                foreach ($Status in $Script:StatusTranslation.Keys) {
                                    New-HTMLTableCondition -Name 'Assessment' -Value $Script:StatusTranslation[$Status] -BackgroundColor $Script:StatusTranslationColors[$Status] -Row
                                }
                                New-HTMLTableCondition -Name 'Assessment' -Value $true -BackgroundColor $TestResults['Configuration']['Colors']['ColorPassed'] -Color $TestResults['Configuration']['Colors']['ColorPassedText'] -Row
                                New-HTMLTableCondition -Name 'Assessment' -Value $false -BackgroundColor $TestResults['Configuration']['Colors']['ColorFailed'] -Color $TestResults['Configuration']['Colors']['ColorFailedText'] -Row
                            } -Filtering
                        }
                    }
                } -BorderRadius 0px
            }
        }
    }

}