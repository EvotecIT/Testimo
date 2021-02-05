$OrphanedAdmins = @{
    Enable          = $true
    Scope           = 'Forest'
    Source          = @{
        Name           = 'Orphaned Administrative Objects (AdminCount)'
        Data           = {
            Get-WinADPrivilegedObjects -Forest $ForestName
        }
        Details        = [ordered] @{
            Category    = 'Security'
            Description = "Active Directory user, group, and computer objects possess an AdminCount attribute. The AdminCount attribute’s value defaults to NOT SET. Its utility comes from the fact when a user, group, or computer is added, either directly or transitively, to any of a specific set of protected groups its value is updated to 1. This can provide a relatively simple method by which objects with inherited administrative privileges may be identified. Consider this: a user is stamped with an AdminCount of 1, as a result of being added to Domain Admins; the user is removed from Domain Admins; the AdminCount value persists. In this instance the user is considered as orphaned. The ramifications? The AdminSDHolder ACL will be stamped upon this user every hour to protect against tampering. In turn, this can cause unexpected issues with delegation and application permissions."
            Importance  = 4
            Severity    = 'Medium'
            Resources   = @(
                '[Security Focus: Orphaned AdminCount -eq 1 AD Users](https://blogs.technet.microsoft.com/poshchap/2016/07/29/security-focus-orphaned-admincount-eq-1-ad-users/)'
                "[Fun with Active Directory's AdminCount Attiribute](https://stealthbits.com/blog/fun-with-active-directorys-admincount-attribute/)"
                'https://docs.microsoft.com/en-us/previous-versions/windows/it-pro/windows-server-2012-r2-and-2012/dn535495(v=ws.11)'
                'https://technet.microsoft.com/en-us/magazine/2009.09.sdadminholder.aspx'
                '[Scanning for Active Directory Privileges & Privileged Accounts](https://adsecurity.org/?p=3658)'
            )
        }
        ExpectedOutput = $true
    }
    Tests           = [ordered] @{
        Enabled = @{
            Enable     = $true
            Name       = 'No orphaned AdminCount'
            Parameters = @{
                ExpectedCount = 0
                OperationType = 'eq'
                WhereObject   = { $_.IsOrphaned -ne $false }
            }
            Details    = [ordered] @{
                Category   = 'Security'
                Importance = 4
            }
        }
    }
    DataInformation = {
        New-HTMLText -Text 'Explanation to table columns:' -FontSize 10pt
        New-HTMLList {
            New-HTMLListItem -FontWeight bold, normal -Text "IsOrphaned", " - means object contains AdminCount set to 1, while not being a critical object or direct or indirect member of any critical system groups. "
            New-HTMLListItem -FontWeight bold, normal -Text "IsMember", " - means object is memberof (direct or indirect) of critical system groups. "
            New-HTMLListItem -FontWeight bold, normal -Text "IsCriticalSystemObject", " - means object is critical system object. "
        } -FontSize 10pt
    }
    DataHighlights  = {
        New-HTMLTableCondition -Name 'IsOrphaned' -ComparisonType string -BackgroundColor Salmon -Value $true
        New-HTMLTableCondition -Name 'IsOrphaned' -ComparisonType string -BackgroundColor PaleGreen -Value $false
        New-HTMLTableCondition -Name 'IsCriticalSystemObject' -ComparisonType string -BackgroundColor PaleGreen -Value $true
        New-HTMLTableCondition -Name 'IsCriticalSystemObject' -ComparisonType string -BackgroundColor TangerineYellow -Value $false
    }
}