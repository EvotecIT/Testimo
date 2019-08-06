$Script:SBForest = {
    Start-TestProcessing -Test 'Forest Information - Is Available' -ExpectedStatus $null -OutputRequired {
        Get-WinADForest
    }
}