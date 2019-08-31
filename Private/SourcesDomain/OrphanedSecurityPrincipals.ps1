$OrphanedForeignSecurityPrincipals = @{
    Enable = $true
    Source = @{
        Name           = "Orphaned Foreign Security Principals"
        Data           = {
            $AllFSP = Get-WinADUsersForeignSecurityPrincipalList -Domain $Domain
            $OrphanedObjects = $AllFSP | Where-Object { $_.TranslatedName -eq $null }
            $OrphanedObjects
        }
        Area           = 'Cleanup'
        ExpectedOutput = $false
    }
}