$OrphanedForeignSecurityPrincipals = @{
    Enable = $true
    Source = @{
        Name           = "Orphaned Foreign Security Principals"
        Data           = {
            $AllFSP = Get-WinADUsersForeignSecurityPrincipalList -Domain $Domain
            $OrphanedObjects = $AllFSP | Where-Object { $_.TranslatedName -eq $null }
            $OrphanedObjects
        }
        ExpectedOutput = $false
        Details = [ordered] @{
            Area             = 'Cleanup'
            Explanation      = ''
            Recommendation   = ''
            RiskLevel        = 10
            RecommendedLinks = @(

            )
        }
    }
}