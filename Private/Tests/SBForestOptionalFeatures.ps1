$Script:SBForestOptionalFeatures = {
    # Imports all commands / including private ones from PSWinDocumentation.AD
    $ADModule = Import-Module PSWinDocumentation.AD -PassThru
    & $ADModule { Get-WinADForestOptionalFeatures -WarningAction SilentlyContinue }
}