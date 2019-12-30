function Get-TestimoDomainControllers {
    [CmdletBinding()]
    param(
        [string] $Domain,
        [switch] $SkipRODC
    )
    try {
        $DC = Get-ADDomainController -Discover -DomainName $Domain
        $DomainControllers = Get-ADDomainController -Server $DC.HostName[0] -Filter * -ErrorAction Stop
        if ($SkipRODC) {
            $DomainControllers = $DomainControllers | Where-Object { $_.IsReadOnly -eq $false }
        }
        foreach ($_ in $DomainControllers) {
            if ($Script:TestimoConfiguration['Inclusions']['DomainControllers']) {
                if ($_ -in $Script:TestimoConfiguration['Inclusions']['DomainControllers']) {
                    [PSCustomObject] @{
                        Name  = $($_.HostName).ToLower()
                        IsPDC = $_.OperationMasterRoles -contains 'PDCEmulator'
                    }
                }
                # We skip checking for exclusions
                continue
            }
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