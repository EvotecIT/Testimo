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

$Script:SBDomainControllers = {
    param(
        [string] $Domain
    )
    #Start-TestProcessing -Test "Domain Controllers - List is Available" -ExpectedStatus $null -OutputRequired -Level 6 -Domain $Domain {
    #Get-WinADDC -Domain $Domain
    # }

    try {
        $DomainControllers = Get-ADDomainController -Server $Domain -Filter * -ErrorAction Stop
        foreach ($_ in $DomainControllers.HostName) {
            if ($_ -notin $Script:TestimoConfiguration['Exclusions']['DomainControllers']) {
                $_.ToLower()
            }
        }
    } catch {
        return
    }
}