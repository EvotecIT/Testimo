$Script:SBDomainControllers = {
    param(
        [string] $Domain
    )
    Start-TestProcessing -Test "Domain Controllers - List is Available" -ExpectedStatus $null -OutputRequired -Level 6 {
        Get-WinADDC -Domain $Domain
    }
}