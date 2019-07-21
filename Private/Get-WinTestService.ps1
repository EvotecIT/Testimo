function Get-WinTestService {
    [CmdletBinding()]
    param(
        [string] $Computer,
        [string] $Service,
        [string] $Status = 'Running'
    )
    try {
        $DNSsvc = Get-Service -ComputerName $Computer -DisplayName 'DNS Server' -ErrorAction Stop
        if ($DNSsvc.Status -eq $Status) {
            [ordered] @{ Status = $true; Output = $Output; Extended = "Status is $Status" }
        } else {
            [ordered] @{ Status = $false; Output = $Output; Extended = "$($DNSsvc.Status)" }
        }
    } catch {
        $ErrorMessage = $_.Exception.Message -replace "`n", " " -replace "`r", " "
        [ordered] @{ Status = $false; Output = @(); Extended = $ErrorMessage }
    }
}