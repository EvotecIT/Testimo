function Get-WinADForest {
    [CmdletBinding()]
    param()
    <#
    try {
        $Output = Get-ADForest -ErrorAction Stop
        [ordered] @{ Status = $true; Output = $Output; Extended = 'No error.' }
    } catch {
        $ErrorMessage = $_.Exception.Message -replace "`n", " " -replace "`r", " "
        [ordered] @{ Status = $false; Output = @(); Extended = $ErrorMessage }
    }
    #>
    $Output = Get-ADForest -ErrorAction Stop
    $Output
}