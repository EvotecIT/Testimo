function Start-Testing {
    param(
        [string] $Scope,
        [string] $Domain,
        $DomainController
    )
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
    }

    foreach ($Source in $($Script:TestimoConfiguration.$Scope.Sources.Keys)) {
        $CurrentSource = $Script:TestimoConfiguration.$Scope.Sources[$Source]
        if ($CurrentSource['Enable'] -eq $true) {
            # $Data = & $CurrentSource['Data'] -DomainController $DomainController
            $Time = Start-TimeLog
            $Object = Start-TestProcessing -Test $CurrentSource['SourceName'] -Level $Level -OutputRequired {
                & $CurrentSource['SourceData'] -DomainController $DomainController -Domain $Domain
            }
            # If there's no output from Source Data all other tests will fail
            if ($Object) {
                $FailAllTests = $false
            } else {
                $FailAllTests = $true
            }
            foreach ($Test in $CurrentSource['Tests'].Keys) {
                $CurrentTest = $CurrentSource['Tests'][$Test]
                if ($CurrentTest['Enable'] -eq $True) {
                    if (-not $FailAllTests) {
                        if ($CurrentTest['TestParameters']) {
                            $Parameters = $CurrentTest['TestParameters']
                        } else {
                            $Parameters = $null
                        }
                        Start-TestingTest -Test $CurrentTest['TestName'] -Level $LevelTest {
                            & $CurrentTest['TestSource'] -Object $Object -Domain $Domain -DomainController $DomainController @Parameters -Level $LevelTest #-TestName $CurrentTest['TestName']
                        }
                    } else {
                        Out-Failure -Text $CurrentTest['TestName'] -Level $LevelTestFailure
                    }
                }
            }
            Out-Summary -Text $CurrentSource['SourceName'] -Time $Time -Level $LevelSummary
        }
    }
}