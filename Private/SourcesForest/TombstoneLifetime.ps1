$TombstoneLifetime = @{
    Name           = "ForestTombstoneLifetime"
    Enable         = $true
    Scope          = 'Forest'
    Source         = [ordered]@{
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
            Category    = 'Configuration'
            Description = "A tombstone is a container object consisting of the deleted objects from AD. These objects have not been physically removed from the database. When an AD object, such as a user is deleted, the object technically remains in the directory for a given period of time; known as the Tombstone Lifetime.  At that point, Active Directory sets the ‘isDeleted' attribute of the deleted object to TRUE and moves it to a special container called Tombstone (previously known as CN=Deleted Objects.)  Once the object is older than the tombstone lifetime, it will be removed (physically deleted) by the garbage collection process."
            Importance  = 0
            ActionType  = 0
            Resources   = @(
                '[Understanding Tombstones, Active Directory, and How To Protect It](https://support.storagecraft.com/s/article/Understanding-Tombstones-Active-Directory-and-How-To-Protect-It?language=en_US)'
                '[Adjust Active Directory Tombstone Lifetime](https://helpcenter.netwrix.com/NA/Configure_IT_Infrastructure/AD/AD_Tombstone.html)'
            )
            StatusTrue  = 0
            StatusFalse = 2
        }
        ExpectedOutput = $true
    }
    Tests          = [ordered] @{
        TombstoneLifetime = [ordered] @{
            Enable     = $true
            Name       = 'TombstoneLifetime should be set to minimum of 180 days'
            Parameters = @{
                ExpectedValue = 180
                Property      = 'TombstoneLifeTime'
                OperationType = 'ge'
            }
            Details    = [ordered] @{
                Category    = 'Configuration'
                Importance  = 7
                ActionType  = 2
                StatusTrue  = 1
                StatusFalse = 3
            }
        }
    }
    DataHighlights = {
        New-HTMLTableCondition -Name 'tombstoneLifetime' -ComparisonType number -BackgroundColor PaleGreen -Value 180 -Operator ge -Row
        New-HTMLTableCondition -Name 'tombstoneLifetime' -ComparisonType number -BackgroundColor Orange -Value 180 -Operator lt -Row
        New-HTMLTableCondition -Name 'tombstoneLifetime' -ComparisonType number -BackgroundColor Salmon -Value 60 -Operator le -Row
    }
}