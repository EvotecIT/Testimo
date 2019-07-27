function Get-WinTestReplication {
    [CmdletBinding()]
    param(
        [bool] $Status
    )
    try {
        $Replication = Get-WinADForestReplication -WarningAction SilentlyContinue
        #$Replication = & $ADModule { Get-WinADForestReplicationPartnerMetaData -WarningAction SilentlyContinue }
        if ($Replication.Status -contains (-not $Status)) {
            [ordered] @{ Status = $false; Output = $Replication; Extended = "There were some errors." }
        } else {
            [ordered] @{ Status = $true; Output = $Replication; Extended = "No errors." }
        }
    } catch {
        $ErrorMessage = $_.Exception.Message -replace "`n", " " -replace "`r", " "
        [ordered] @{ Status = $false; Output = @(); Extended = $ErrorMessage }
    }
}