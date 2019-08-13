function Get-WinADDC {
    [CmdletBinding()]
    param(
        [string] $Domain = $Env:USERDNSDOMAIN
    )
    <#
    try {
        $Output = Get-ADDomainController -Server $Domain -Filter * -ErrorAction Stop
        [ordered] @{ Status = $true; Output = $Output; Extended = 'No error.' }
    } catch {
        $ErrorMessage = $_.Exception.Message -replace "`n", " " -replace "`r", " "
        [ordered] @{ Status = $false; Output = @(); Extended = $ErrorMessage }
    }
    #>
    $Output = Get-ADDomainController -Server $Domain -Filter * -ErrorAction Stop
    $Output
}