$Script:SBDomain = {
    param(
        [string] $Domain
    )

    Start-TestProcessing -Test "Domain $Domain - Is Available" -ExpectedStatus $null -OutputRequired -Level 3 {
        Get-WinADDomain -Domain $Domain
    }
}