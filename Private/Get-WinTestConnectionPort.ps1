function Get-WinTestConnectionPort {
    [CmdletBinding()]
    param(
        [string] $Computer,
        [int] $Port
    )
    try {
        $Output = Test-NetConnection -ComputerName $Computer -WarningAction SilentlyContinue -Port $Port
        if ($Output.TcpTestSucceeded) {
            [ordered] @{ Status = $true; Output = $Output; Extended = "Port available for connection." }
        } else {
            [ordered] @{ Status = $false; Output = $Output; Extended = "$($Output.PingReplyDetails.Status) - $($Output.PingReplyDetails.Address)" }
        }
    } catch {
        $ErrorMessage = $_.Exception.Message -replace "`n", " " -replace "`r", " "
        [ordered] @{ Status = $false; Output = @(); Extended = $ErrorMessage }
    }
}