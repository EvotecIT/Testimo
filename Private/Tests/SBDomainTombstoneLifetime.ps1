$Script:SBDomainTombstoneLifetime = {
    # Check tombstone lifetime (if blank value is 60)
    # Recommended value 720
    # Minimum value 180
    $Output = (Get-ADObject -Identity "CN=Directory Service,CN=Windows NT,CN=Services,$((Get-ADRootDSE).configurationNamingContext)" -Properties tombstoneLifetime).tombstoneLifetime
    if ($null -eq $Output) {
        [PSCustomObject] @{
            TombstoneLifeTime = 60
        }
    } else {
        [PSCustomObject] @{
            TombstoneLifeTime = $Output
        }
    }
}