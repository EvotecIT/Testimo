function Start-TestingTest {
    [CmdletBinding()]
    param(
        [ScriptBlock] $Execute,
        $Test,
        [int] $Level,
        [string] $Domain,
        [string] $DomainController,
        [string] $ReferenceID
    )
    if ($Execute) {
        if ($Script:TestimoConfiguration.Debug.ShowErrors) {
            [Array] $Output = & $Execute
            $Output
        } else {
            try {
                [Array] $Output = & $Execute
                $Output
            } catch {
                $ErrorMessage = $_.Exception.Message -replace "`n", " " -replace "`r", " "
            }
            if (-not $ErrorMessage) {

            } else {
                Out-Failure -Text $CurrentTest['TestName'] -Level $Level -ExtendedValue $ErrorMessage -Domain $Domain -DomainController $DomainController -ReferenceID $ReferenceID
            }
        }
    }
}