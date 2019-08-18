function Get-WinADForest {
    [CmdletBinding()]
    param()
    <#
    try {
        $Output = Get-ADForest -ErrorAction Stop
        [ordered] @{ Status = $true; Output = $Output; Extended = 'No error.' }
    } catch {
        $ErrorMessage = $_.Exception.Message -replace "`n", " " -replace "`r", " "
        [ordered] @{ Status = $false; Output = @(); Extended = $ErrorMessage }
    }
    #>
    #$Output = Get-ADForest -ErrorAction Stop
    # $Output
}

$Script:SBForest = {
    #Start-TestProcessing -Test 'Forest Information - Is Available' -ExpectedStatus $null -OutputRequired {
    #Get-WinADForest

    try {
        $Forest = Get-ADForest -ErrorAction Stop
        foreach ($_ in $Forest.Domains) {
            if ($_ -notin $Script:TestimoConfiguration['Exclusions']['Domains']) {
                $_.ToLower()
            }
        }
    } catch {
        return
    }
    #}
}