function Start-Testing {
    [CmdletBinding()]
    param(
        [ScriptBlock] $Execute,
        [string] $Scope,
        [string] $Domain,
        [string] $DomainController
    )
    $GlobalTime = Start-TimeLog

    if ($Scope -eq 'Forest') {
        $Level = 3
        $LevelTest = 6
        $LevelSummary = 3
        $LevelTestFailure = 6
    } elseif ($Scope -eq 'Domain') {
        $Level = 6
        $LevelTest = 9
        $LevelSummary = 6
        $LevelTestFailure = 9
    } elseif ($Scope -eq 'DomainControllers') {
        $Level = 9
        $LevelTest = 12
        $LevelSummary = 9
        $LevelTestFailure = 12
    } else {

    }

    if ($Domain -and $DomainController) {
        $SummaryText = "Domain $Domain, $DomainController"
    } elseif ($Domain) {
        Write-Color
        $SummaryText = "Domain $Domain"
    } else {
        $SummaryText = "Forest"
    }


    Out-Begin -Type 'i' -Text $SummaryText -Level ($LevelSummary - 3) -Domain $Domain -DomainController $DomainController
    Out-Status -Text $SummaryText -Status $null -ExtendedValue '' -Domain $Domain -DomainController $DomainController

    $TestsSummaryTogether = @(
        foreach ($Source in $($Script:TestimoConfiguration.$Scope.Sources.Keys)) {
            $CurrentSource = $Script:TestimoConfiguration.$Scope.Sources[$Source]
            if ($CurrentSource['Enable'] -eq $true) {
                [Array] $AllTests = $CurrentSource['Tests'].Keys
                $TestsSummary = [PSCustomobject] @{
                    Passed  = 0
                    Failed  = 0
                    Skipped = 0
                    Total   = 0 # $AllTests.Count + 1 # +1 includes availability of data test
                }
                # $Data = & $CurrentSource['Data'] -DomainController $DomainController
                $Time = Start-TimeLog
                $Object = Start-TestProcessing -Test $CurrentSource['Source']['Name'] -Level $Level -OutputRequired -Domain $Domain -DomainController $DomainController {
                    & $CurrentSource['Source']['Data'] -DomainController $DomainController -Domain $Domain
                }
                # If there's no output from Source Data all other tests will fail
                if ($Object) {
                    $FailAllTests = $false
                    Out-Begin -Text $CurrentSource['Source']['Name'] -Level $LevelTest -Domain $Domain -DomainController $DomainController
                    Out-Status -Text $CurrentSource['Source']['Name'] -Status $true -ExtendedValue 'Data is available.' -Domain $Domain -DomainController $DomainController
                    $TestsSummary.Passed = $TestsSummary.Passed + 1
                } elseif ($null -eq $Object -and $CurrentSource['Source']['ExpectedOutput'] -eq $false) {
                    # This tests whether there was an output from Source or not.
                    # Sometimes it makes sense to ask for data and get null/empty in return
                    # you just need to make sure to define ExpectedOutput = $false in source definition
                    $FailAllTests = $false
                    Out-Begin -Text $CurrentSource['Source']['Name'] -Level $LevelTest -Domain $Domain -DomainController $DomainController
                    Out-Status -Text $CurrentSource['Source']['Name'] -Status $true -ExtendedValue 'No data returned, which is a good thing.' -Domain $Domain -DomainController $DomainController
                    $TestsSummary.Passed = $TestsSummary.Passed + 1
                } else {
                    $FailAllTests = $true
                    Out-Failure -Text $CurrentSource['Source']['Name'] -Level $LevelTest -ExtendedValue 'No data available.' -Domain $Domain -DomainController $DomainController
                    $TestsSummary.Failed = $TestsSummary.Failed + 1
                }
                foreach ($Test in $AllTests) {
                    $CurrentTest = $CurrentSource['Tests'][$Test]
                    if ($CurrentTest['Enable'] -eq $True) {
                        if (-not $FailAllTests) {
                            if ($CurrentTest['Parameters']) {
                                $Parameters = $CurrentTest['Parameters']
                            } else {
                                $Parameters = $null
                            }
                            $TestsResults = Start-TestingTest -Test $CurrentTest['Name'] -Level $LevelTest -Domain $Domain -DomainController $DomainController {
                                if ($CurrentTest['Data'] -is [ScriptBlock]) {
                                    & $CurrentTest['Data'] -Object $Object -Domain $Domain -DomainController $DomainController @Parameters -Level $LevelTest #-TestName $CurrentTest['TestName']
                                } else {
                                    Test-Value -Object $Object -Domain $Domain -DomainController $DomainController @Parameters -Level $LevelTest -TestName $CurrentTest['Name']
                                }
                            }
                            $TestsSummary.Passed = $TestsSummary.Passed + ($TestsResults | Where-Object { $_ -eq $true }).Count
                            $TestsSummary.Failed = $TestsSummary.Failed + ($TestsResults | Where-Object { $_ -eq $false }).Count
                        } else {
                            $TestsSummary.Failed = $TestsSummary.Failed + 1
                            Out-Failure -Text $CurrentTest['Name'] -Level $LevelTestFailure -Domain $Domain -DomainController $DomainController
                        }
                    } else {
                        $TestsSummary.Skipped = $TestsSummary.Skipped + 1
                    }
                }
                $TestsSummary.Total = $TestsSummary.Failed + $TestsSummary.Passed + $TestsSummary.Skipped
                $TestsSummary
                Out-Summary -Text $CurrentSource['Source']['Name'] -Time $Time -Level $LevelSummary -Domain $Domain -DomainController $DomainController -TestsSummary $TestsSummary
            }
        }
        if ($Execute) {
            & $Execute
        }
    )
    $TestsSummaryFinal = [PSCustomObject] @{
        Passed  = ($TestsSummaryTogether.Passed | Measure-Object -Sum).Sum
        Failed  = ($TestsSummaryTogether.Failed | Measure-Object -Sum).Sum
        Skipped = ($TestsSummaryTogether.Skipped | Measure-Object -Sum).Sum
        Total   = ($TestsSummaryTogether.Total | Measure-Object -Sum).Sum
    }
    $TestsSummaryFinal

    Out-Summary -Text $SummaryText -Time $GlobalTime -Level ($LevelSummary - 3) -Domain $Domain -DomainController $DomainController -TestsSummary $TestsSummaryFinal
}