$TombstoneLifetime = @{
    Enable    = $true
    Scope     = 'Forest'
    Source    = [ordered]@{
        Name           = 'Tombstone Lifetime'
        Data           = {
            # Check tombstone lifetime (if blank value is 60)
            # Recommended value 720
            # Minimum value 180
            $Output = (Get-ADObject -Identity "CN=Directory Service,CN=Windows NT,CN=Services,$((Get-ADRootDSE -Server $ForestName).configurationNamingContext)" -Server $ForestName -Properties tombstoneLifetime) | Select-Object -Property DistinguishedName, Name, objectClass, ObjectGuid, tombstoneLifetime
            if ($null -eq $Output) {
                [PSCustomObject] @{
                    TombstoneLifeTime = 60
                }
            } else {
                $Output
            }
        }
        Details        = [ordered] @{
            Area        = 'Configuration'
            Category    = 'Backup'
            Description = ''
            Resolution  = ''
            RiskLevel   = 10
            Severity    = 'High'
            Resources   = @(

            )
        }
        ExpectedOutput = $true
    }
    Tests     = [ordered] @{
        TombstoneLifetime = @{
            Enable     = $true
            Name       = 'TombstoneLifetime should be set to minimum of 180 days'
            Parameters = @{
                ExpectedValue = 180
                Property      = 'TombstoneLifeTime'
                OperationType = 'ge'
            }
        }
    }
    Resources = @(
        'https://helpcenter.netwrix.com/Configure_IT_Infrastructure/AD/AD_Tombstone.html'
    )
}