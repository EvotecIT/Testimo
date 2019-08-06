<#
$Script:SBForestOptionalFeatures = {
    Start-TestProcessing -Test "Optional features" -Level 1 -Data {
        Get-ForestOptionalFeatures
    } -Tests {
        Test-Value -TestName 'Is Recycle Bin Enabled?' -Property 'Recycle Bin Enabled' -ExpectedValue $true
        Test-Value -TestName 'is Laps Enabled?' -Property 'Laps Enabled' -ExpectedValue $true
    }
}
#>
$Script:SBForestOptionalFeatures = {
    Get-ForestOptionalFeatures
}
$Script:SBForestOptionalFeaturesTest1 = {
    Test-Value -TestName 'RecycleBin Enabled' -Property 'Recycle Bin Enabled' @args #-ExpectedValue $true
}
$Script:SBForestOptionalFeaturesTest2 = {
    Test-Value -TestName 'LAPS Available' -Property 'Laps Enabled' @args #-ExpectedValue $true
}