function Get-ForestOptionalFeatures {
    [CmdletBinding()]
    param(

    )
    try {
        $ADModule = Import-Module PSWinDocumentation.AD -PassThru
        try {
            $OptionalFeatures = & $ADModule { Get-WinADForestOptionalFeatures -WarningAction SilentlyContinue }
        } catch {
            $ErrorMessage = $_.Exception.Message -replace "`n", " " -replace "`r", " "
        }

        if ($OptionalFeatures.Count -gt 0) {
            [ordered] @{ Status = $true; Output = $OptionalFeatures; Extended = "" }
        } else {
            [ordered] @{ Status = $false; Output = $OptionalFeatures; Extended = $ErrorMessage }
        }
    } catch {
        $ErrorMessage = $_.Exception.Message -replace "`n", " " -replace "`r", " "
        [ordered] @{ Status = $false; Output = @(); Extended = $ErrorMessage }
    }
}