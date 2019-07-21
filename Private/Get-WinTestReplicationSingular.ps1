function Get-WinTestReplicationSingular {
    [CmdletBinding()]
    param(
        [PSCustomObject] $Replication
    )
    try {
        if ($Replication.Status -eq $true) {
            [ordered] @{ Status = $true; Output = ''; Extended = $Replication.StatusMessage }
        } else {
            [ordered] @{ Status = $false; Output = ''; Extended = $Replication.StatusMessage }
        }
    } catch {
        $ErrorMessage = $_.Exception.Message -replace "`n", " " -replace "`r", " "
        [ordered] @{ Status = $false; Output = @(); Extended = $ErrorMessage }
    }
}
