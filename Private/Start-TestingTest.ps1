function Start-TestingTest {
    param(
        [ScriptBlock] $Execute,
        $Test,
        $Level
    )
    if ($Execute) {
        try {
            [Array] $Output = & $Execute
        } catch {
            $ErrorMessage = $_.Exception.Message -replace "`n", " " -replace "`r", " "
        }
        if (-not $ErrorMessage) {
            #Out-Status -Text $Test -Status $TestResult -ExtendedValue $O.Extended
        } else {
            # Out-Status -Text $Test -Status $false -ExtendedValue $ErrorMessage
            Out-Failure -Text $CurrentTest['TestName'] -Level $Level -ExtendedValue $ErrorMessage
        }
    }
}