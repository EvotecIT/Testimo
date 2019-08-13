function Start-Testing {
    [CmdletBinding()]
    param(
        [ScriptBlock] $Execute,
        [string] $Scope,
        [string] $Domain,
        [string] $DomainController
    )
    $GlobalTime = Start-TimeLog

    <#
    if ($Scope -eq 'Forest') {
        $Level = 3
        $LevelTest = 6
        $LevelSummary = 3
        $LevelTestFailure = 6
    } elseif ($Scope -eq 'Domain') {
        $Level = 3
        $LevelTest = 6
        $LevelSummary = 3
        $LevelTestFailure = 6
    } elseif ($Scope -eq 'DomainControllers') {
        $Level = 6
        $LevelTest = 9
        $LevelSummary = 6
        $LevelTestFailure = 9
    } else {
        # Write-Color 'x'
    }
    #>


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
        # Write-Color 'x'
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
                    TestsPassed  = 0
                    TestsFailed  = 0
                    TestsSkipped = 0
                    TestsTotal   = 0 # $AllTests.Count + 1 # +1 includes availability of data test
                }
                # $Data = & $CurrentSource['Data'] -DomainController $DomainController
                $Time = Start-TimeLog
                $Object = Start-TestProcessing -Test $CurrentSource['SourceName'] -Level $Level -OutputRequired -Domain $Domain -DomainController $DomainController {
                    & $CurrentSource['SourceData'] -DomainController $DomainController -Domain $Domain
                }
                # If there's no output from Source Data all other tests will fail
                if ($Object) {
                    $FailAllTests = $false
                    Out-Begin -Text $CurrentSource['SourceName'] -Level $LevelTest -Domain $Domain -DomainController $DomainController
                    Out-Status -Text $CurrentSource['SourceName'] -Status $true -ExtendedValue 'Data is available.' -Domain $Domain -DomainController $DomainController
                    $TestsSummary.TestsPassed = $TestsSummary.TestsPassed + 1
                } else {
                    $FailAllTests = $true
                    Out-Failure -Text $CurrentSource['SourceName'] -Level $LevelTest -ExtendedValue 'No data available.' -Domain $Domain -DomainController $DomainController
                    $TestsSummary.TestsFailed = $TestsSummary.TestsFailed + 1
                }
                foreach ($Test in $AllTests) {
                    $CurrentTest = $CurrentSource['Tests'][$Test]
                    if ($CurrentTest['Enable'] -eq $True) {
                        if (-not $FailAllTests) {
                            if ($CurrentTest['TestParameters']) {
                                $Parameters = $CurrentTest['TestParameters']
                            } else {
                                $Parameters = $null
                            }
                            $TestsResults = Start-TestingTest -Test $CurrentTest['TestName'] -Level $LevelTest -Domain $Domain -DomainController $DomainController {
                                & $CurrentTest['TestSource'] -Object $Object -Domain $Domain -DomainController $DomainController @Parameters -Level $LevelTest #-TestName $CurrentTest['TestName']
                            }
                            #if ($TestsResults) {
                                $TestsSummary.TestsPassed = $TestsSummary.TestsPassed + ($TestsResults | Where-Object { $_ -eq $true }).Count
                           # } else {
                                $TestsSummary.TestsFailed = $TestsSummary.TestsFailed + ($TestsResults | Where-Object { $_ -eq $false }).Count
                           # }
                        } else {
                            $TestsSummary.TestsFailed = $Tests.TestsFailed + 1
                            Out-Failure -Text $CurrentTest['TestName'] -Level $LevelTestFailure -Domain $Domain -DomainController $DomainController
                        }
                    } else {
                        $TestsSummary.TestsSkipped = $TestsSummary.TestsSkipped + 1
                    }
                }
                $TestsSummary.TestsTotal = $TestsSummary.TestsFailed + $TestsSummary.TestsPassed + $TestsSummary.TestsSkipped
                $TestsSummary
                Out-Summary -Text $CurrentSource['SourceName'] -Time $Time -Level $LevelSummary -Domain $Domain -DomainController $DomainController -TestsSummary $TestsSummary
            }
        }
        if ($Execute) {
            & $Execute
        }
    )
    $TestsSummary1 = [PSCustomObject] @{
        TestsPassed  = ($TestsSummaryTogether.TestsPassed | Measure-Object -Sum).Sum
        TestsFailed  = ($TestsSummaryTogether.TestsFailed | Measure-Object -Sum).Sum
        TestsSkipped = ($TestsSummaryTogether.TestsSkipped | Measure-Object -Sum).Sum
        TestsTotal   = ($TestsSummaryTogether.TestsTotal | Measure-Object -Sum).Sum
    }
    $TestsSummary1


    Out-Summary -Text $SummaryText -Time $GlobalTime -Level ($LevelSummary - 3) -Domain $Domain -DomainController $DomainController -TestsSummary $TestsSummary1
}