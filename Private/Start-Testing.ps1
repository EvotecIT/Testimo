function Start-Testing {
    param(
        [string] $Scope,
        [string] $Domain,
        $DomainController
    )
    foreach ($Source in $($Script:Configuration.$Scope.Sources.Keys)) {
        $CurrentSource = $Script:Configuration.$Scope.Sources[$Source]
        if ($CurrentSource['Enable'] -eq $true) {
            # $Data = & $CurrentSource['Data'] -DomainController $DomainController
            $Time = Start-TimeLog
            $Object = Start-TestProcessing -Test $CurrentSource['SourceName'] -Level 0 -OutputRequired {
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
                        & $CurrentTest['TestSource'] -Object $Object -Domain $Domain -DomainController $DomainController @Parameters -Level 1 #-TestName $CurrentTest['TestName']
                    } else {
                        Out-Failure -Text $CurrentTest['TestName'] -Level 3
                    }
                }
            }
            Out-Summary -Text $CurrentSource['SourceName'] -Time $Time
        }
    }
}