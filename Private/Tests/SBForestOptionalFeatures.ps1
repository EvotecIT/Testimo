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
    # Imports all commands / including private ones from PSWinDocumentation.AD
    $ADModule = Import-Module PSWinDocumentation.AD -PassThru
    & $ADModule { Get-WinADForestOptionalFeatures -WarningAction SilentlyContinue }
}
$Script:SBForestOptionalFeaturesTest1 = {
    Test-Value -TestName 'Recycle Bin Enabled' -Property 'Recycle Bin Enabled' @args
}
$Script:SBForestOptionalFeaturesTest2 = {
    Test-Value -TestName 'LAPS Schema Extended' -Property 'Laps Enabled' @args
}