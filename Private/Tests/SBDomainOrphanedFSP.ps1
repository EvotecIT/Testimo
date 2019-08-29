$Script:SBDomainOrphanedFSP = {
    param(
        $Domain
    )
    $AllFSP = Get-WinADUsersFP -Domain $Domain
    $OrphanedObjects = $AllFSP | Where-Object { $_.TranslatedName -eq $null }
    $OrphanedObjects
}