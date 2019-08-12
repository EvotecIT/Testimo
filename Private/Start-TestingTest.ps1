function Start-TestingTest {
    [CmdletBinding()]
    param(
        [ScriptBlock] $Execute,
        $Test,
        [int] $Level,
        [string] $Domain,
        [string] $DomainController
    )
    if ($Execute) {
        if ($Script:TestimoConfiguration.Debug.DisableTryCatch) {
            [Array] $Output = & $Execute
        } else {
            try {
                [Array] $Output = & $Execute
            } catch {
                $ErrorMessage = $_.Exception.Message -replace "`n", " " -replace "`r", " "
            }
            if (-not $ErrorMessage) {
                #Out-Status -Text $Test -Status $TestResult -ExtendedValue $O.Extended
            } else {
                # Out-Status -Text $Test -Status $false -ExtendedValue $ErrorMessage
                Out-Failure -Text $CurrentTest['TestName'] -Level $Level -ExtendedValue $ErrorMessage -Domain $Domain -DomainController $DomainController
            }
        }
    }
}