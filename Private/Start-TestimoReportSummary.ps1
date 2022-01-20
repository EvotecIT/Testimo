function Start-TestimoReportSummary {
    [CmdletBinding()]
    param(
        [System.Collections.IDictionary] $TestResults
    )
    $ChartData = New-ChartData -Results $TestResults['Results']
    $TableData = [ordered] @{}
    foreach ($Chart in $ChartData.Keys) {
        $TableData[$Chart] = $ChartData[$Chart].Count
    }
    $TableData['Total'] = $TestResults['Summary'].Total
    $DisplayTableData = [PSCustomObject] $TableData

    New-HTMLTab -Name 'Summary' -IconBrands galactic-senate {
        New-HTMLSection -HeaderText "Tests results" -HeaderBackGroundColor DarkGray {
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
            } -Width '35%'
            New-HTMLContainer {
                New-HTMLText -Text @(
                    "Below you can find overall summary of all tests executed in this Testimo run."
                ) -FontSize 10pt

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
    }
}