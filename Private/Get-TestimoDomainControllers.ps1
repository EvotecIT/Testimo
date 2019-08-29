function Get-TestimoDomainControllers {
    [CmdletBinding()]
    param(
        [string] $Domain
    )
    try {
        $DomainControllers = Get-ADDomainController -Server $Domain -Filter * -ErrorAction Stop
        foreach ($_ in $DomainControllers) {
            if ($_.HostName -notin $Script:TestimoConfiguration['Exclusions']['DomainControllers']) {
                [PSCustomObject] @{
                    Name  = $($_.HostName).ToLower()
                    IsPDC = $_.OperationMasterRoles -contains 'PDCEmulator'
                }
            }
        }
    } catch {
        return
    }
}