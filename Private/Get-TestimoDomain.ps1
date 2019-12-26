function Get-TestimoDomain {
    [CmdletBinding()]
    param(
        [string] $Domain
    )
    try {
        $DC = Get-ADDomainController -Discover -DomainName $Domain
        $Output = Get-ADDomain -ErrorAction Stop -Server $DC.HostName[0]
        $Output
    } catch {
        Out-Failure -Text "Gathering Domain Information failed. Tests for domains/domain controllers will be skipped." -Level 3 -ExtendedValue $_.Exception.Message -Type 'e' -Domain $Domain
    }
}