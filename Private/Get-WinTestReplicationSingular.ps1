function Get-WinTestReplicationSingular {
    [CmdletBinding()]
    param(
        [PSCustomObject] $Replication
    )
    if ($Replication.Status -eq $true) {
        [ordered] @{ Status = $true; Output = ''; Extended = $Replication.StatusMessage }
    } else {
        [ordered] @{ Status = $false; Output = ''; Extended = $Replication.StatusMessage }
    }
}
