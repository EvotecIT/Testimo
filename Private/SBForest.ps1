$Script:SBForest = {
    Start-TestProcessing -Test 'Forest Information - Is Available' -ExpectedStatus $true -OutputRequired {
        Get-WinADForest
    }
}