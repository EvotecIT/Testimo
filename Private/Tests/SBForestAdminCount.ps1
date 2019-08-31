$Script:SBForestAdminCount = {
    Get-WinADPriviligedObjects -OrphanedOnly
}