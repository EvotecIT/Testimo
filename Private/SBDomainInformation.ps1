$Script:SBDomainInformation = {
    param(
        [string] $Domain
    )

    Start-TestProcessing -Test "Domain $Domain - Is Available" -ExpectedStatus $true -OutputRequired -IsTest {
        Get-WinADDomain -Domain $Domain
    }
}