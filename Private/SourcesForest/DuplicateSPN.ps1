$DuplicateSPN = @{
    Enable          = $true
    Scope           = 'Forest'
    Source          = @{
        Name           = 'Duplicate SPN'
        Data           = {
            Get-WinADDuplicateSPN -Forest $ForestName
        }
        Details        = [ordered] @{
            Category    = 'Security'
            Description = "SPNs must be unique, so if an SPN already exists for a service on a server then you must delete the SPN that is is already registered to one account and recreate the SPN registered to the correct account."
            Importance  = 5
            ActionType  = 1
            Resources   = @(
                "[Duplicate SPN found - Troubleshooting Duplicate SPNs](https://support.squaredup.com/hc/en-us/articles/4406616176657-Duplicate-SPN-found-Troubleshooting-Duplicate-SPNs)"
                "[SPN and UPN uniqueness](https://docs.microsoft.com/en-us/windows-server/identity/ad-ds/manage/component-updates/spn-and-upn-uniqueness)"
                "[Name Formats for Unique SPNs](https://docs.microsoft.com/en-us/windows/win32/ad/name-formats-for-unique-spns)"
                "[Kerberos - duplicate SPNs](https://itworldjd.wordpress.com/2017/02/15/kerberos-duplicate-spns/)"
            )
            StatusTrue  = 0
            StatusFalse = 5
        }
        ExpectedOutput = $false
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
        # New-HTMLTableCondition -Name 'IsOrphaned' -ComparisonType string -BackgroundColor Salmon -Value $true
        # New-HTMLTableCondition -Name 'IsOrphaned' -ComparisonType string -BackgroundColor PaleGreen -Value $false
        # New-HTMLTableCondition -Name 'IsCriticalSystemObject' -ComparisonType string -BackgroundColor PaleGreen -Value $true
        # New-HTMLTableCondition -Name 'IsCriticalSystemObject' -ComparisonType string -BackgroundColor TangerineYellow -Value $false
    }
}