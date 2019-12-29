function Get-TestimoDomainControllers {
    [CmdletBinding()]
    param(
        [string] $Domain,
        [switch] $SkipRODC
    )
    try {
        $DomainControllers = Get-ADDomainController -Server $Domain -Filter * -ErrorAction Stop
        if ($SkipRODC) {
            $DomainControllers = $DomainControllers | Where-Object { $_.IsReadOnly -eq $false }
        }
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