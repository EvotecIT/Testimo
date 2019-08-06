function Out-SummaryWithExecute {
    param(
        [ScriptBlock] $Execute

    )
    if ($Execute) {
        try {
            & $Execute
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