$Script:SBDomainOrphanedFSP = {
    param(
        $Domain
    )
    $AllFSP = Get-WinADUsersForeignSecurityPrincipalList1 -Domain $Domain
    $OrphanedObjects = $AllFSP | Where-Object { $_.TranslatedName -eq $null }
    $OrphanedObjects
}