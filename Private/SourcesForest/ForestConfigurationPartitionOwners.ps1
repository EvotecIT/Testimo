$ForestConfigurationPartitionOwners = @{
    Enable         = $true
    Scope          = 'Forest'
    Source         = @{
        Name           = "Configuration Partitions: Owners"
        Data           = {
            Get-WinADACLConfiguration -Forest $ForestName -Owner -ObjectType site, subnet, siteLink
        }
        Details        = [ordered] @{
            Category    = 'Security'
            Severity    = ''
            RiskLevel   = 5
            Description = "Owners of Active Directory Configuration Partition, and more specifically Sites, Subnets and Sitelinks should always be set to Administrative (Domain Admins / Enterprise Admins). Being an owner of a site, subnet or sitelink is potentially dangerous and can lead to domain compromise. "
            Resources   = @(
                '[Escalating privileges with ACLs in Active Directory](https://blog.fox-it.com/2018/04/26/escalating-privileges-with-acls-in-active-directory/)'
            )
        }
        ExpectedOutput = $true
    }
    Tests          = [ordered] @{
        SiteOwners     = @{
            Enable     = $true
            Name       = 'Site Owners should be Administrative'
            Parameters = @{
                ExpectedCount = 0
                OperationType = 'eq'
                WhereObject   = { $_.ObjectType -eq 'Site' -and $_.OwnerType -ne 'Administrative' }
            }
            Details    = [ordered] @{
                Category  = 'Security'
                RiskLevel = 5
            }
        }
        SubnetOwners   = @{
            Enable     = $true
            Name       = 'Subnet Owners should be Administrative'
            Parameters = @{
                ExpectedCount = 0
                OperationType = 'eq'
                WhereObject   = { $_.ObjectType -eq 'Subnet' -and $_.OwnerType -ne 'Administrative' }
            }
            Details    = [ordered] @{
                Category  = 'Security'
                RiskLevel = 5
            }
        }
        SiteLinkOwners = @{
            Enable     = $true
            Name       = 'SiteLink Owners should be Administrative'
            Parameters = @{
                ExpectedCount = 0
                OperationType = 'eq'
                WhereObject   = { $_.ObjectType -eq 'SiteLink' -and $_.OwnerType -ne 'Administrative' }
            }
            Details    = [ordered] @{
                Category  = 'Security'
                RiskLevel = 5
            }
        }
    }
    DataHighlights = {
        New-HTMLTableCondition -Name 'OwnerType' -ComparisonType string -BackgroundColor Salmon -Value 'Administrative' -Operator ne -Row
        New-HTMLTableCondition -Name 'OwnerType' -ComparisonType string -BackgroundColor PaleGreen -Value 'Administrative' -Operator eq -Row
    }
}