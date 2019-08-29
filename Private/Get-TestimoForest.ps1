function Get-TestimoForest {
    [CmdletBinding()]
    param()
    try {
        $Forest = Get-ADForest -ErrorAction Stop
        $ForestInformation = foreach ($_ in $Forest) {
            if ($_.Domains -notin $Script:TestimoConfiguration['Exclusions']['Domains']) {
                $_.Domains.ToLower()
                $_
            }
        }
        $ForestInformation
    } catch {
        return
    }
}