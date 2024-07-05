function Get-TestimoDomainControllers {
    <#
    .SYNOPSIS
    Retrieves domain controllers in a specified domain, with an option to skip read-only domain controllers.

    .DESCRIPTION
    This function retrieves domain controllers in the specified domain. It can skip read-only domain controllers if desired.

    .PARAMETER Domain
    Specifies the name of the domain to retrieve domain controllers from.

    .PARAMETER SkipRODC
    Indicates whether to skip read-only domain controllers.

    .EXAMPLE
    Get-TestimoDomainControllers -Domain "contoso.com"
    Retrieves all domain controllers in the "contoso.com" domain.

    .EXAMPLE
    Get-TestimoDomainControllers -Domain "contoso.com" -SkipRODC
    Retrieves all domain controllers in the "contoso.com" domain, excluding read-only domain controllers.

    #>
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