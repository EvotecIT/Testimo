function Get-TestimoDomain {
    [CmdletBinding()]
    param(
        [string] $Domain
    )
    $Output = Get-ADDomain -Server $Domain -ErrorAction Stop
    $Output
}