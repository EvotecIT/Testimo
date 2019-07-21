function Get-WinTestConnection {
    [CmdletBinding()]
    param(
        [string] $Computer
    )
    try {
        $Output = Test-NetConnection -ComputerName $Computer -WarningAction SilentlyContinue
        if ($Output.PingSucceeded) {
            [ordered] @{ Status = $true; Output = $Output; Extended = "Ping Replay Details (RTT): $($Output.PingReplyDetails.RoundtripTime)" }
        } else {
            [ordered] @{ Status = $false; Output = $Output; Extended = "$($Output.PingReplyDetails.Status) - $($Output.PingReplyDetails.Address)" }
        }
    } catch {
        $ErrorMessage = $_.Exception.Message -replace "`n", " " -replace "`r", " "
        [ordered] @{ Status = $false; Output = @(); Extended = $ErrorMessage }
    }
}