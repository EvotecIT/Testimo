$Script:SBDomainControllers = {
    param(
        [string] $Domain
    )
    Start-TestProcessing -Test "Domain Controllers - List is Available" -ExpectedStatus $true -OutputRequired -Level 1 {
        Get-WinADDC -Domain $Domain
    }
}