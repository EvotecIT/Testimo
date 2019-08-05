$Script:SBForestOptionalFeatures = {
    Start-TestProcessing -Test "Optional features" -Level 1 -Data {
        Get-ForestOptionalFeatures
    } -Tests {
        Test-Value -TestName 'Is Recycle Bin Enabled?' -Property 'Recycle Bin Enabled' -ExpectedValue $true
        Test-Value -TestName 'is Laps Enabled?' -Property 'Laps Enabled' -ExpectedValue $true
    }
}