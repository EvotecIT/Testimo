$TombstoneLifetime = @{
    Enable           = $true
    Source           = [ordered]@{
        Name = 'Tombstone Lifetime'
        Data = {
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
        Details = [ordered] @{
            Area             = ''
            Description      = ''
            Resolution   = ''
            RiskLevel        = 10
            Resources = @(

            )
        }
    }
    Tests            = [ordered] @{
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