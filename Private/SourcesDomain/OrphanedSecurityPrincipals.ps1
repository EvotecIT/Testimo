$OrphanedForeignSecurityPrincipals = @{
    Enable = $true
    Scope  = 'Domain'
    Source = @{
        Name           = "Orphaned Foreign Security Principals"
        Data           = {
            $AllFSP = Get-WinADUsersForeignSecurityPrincipalList -Domain $Domain
            $OrphanedObjects = $AllFSP | Where-Object { $_.TranslatedName -eq $null }
            $OrphanedObjects
        }
        Details = [ordered] @{
            Area        = 'Cleanup'
            Category    = ''
            Severity    = ''
            RiskLevel   = 0
            Description = ''
            Resolution  = ''
            Resources   = @(

            )
        }
        ExpectedOutput = $false
    }
}