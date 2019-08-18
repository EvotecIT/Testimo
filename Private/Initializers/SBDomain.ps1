function Get-WinADDomain {
    [CmdletBinding()]
    param(
        [string] $Domain
    )
    <#
    @(
        try {
            $Output = Get-ADDomain -Server $Domain -ErrorAction Stop

            [ordered] @{ Status = $true; Output = $Output; Error = '' }
        } catch {
            $ErrorMessage = $_.Exception.Message -replace "`n", " " -replace "`r", " "
            [ordered] @{ Status = $false; Output = @(); Error = $ErrorMessage }
        }
    )
    #>

    $Output = Get-ADDomain -Server $Domain -ErrorAction Stop
    $Output
}

$Script:SBDomain = {
    param(
        [string] $Domain
    )

    #Start-TestProcessing -Test "Domain $Domain - Is Available" -ExpectedStatus $null -OutputRequired -Level 3 {
    # $Domains = Get-WinADDomain -Domain $Domain
    #  $Domains
    #}
}