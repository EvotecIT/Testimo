$ForestSubnets = @{
    Enable          = $true
    Scope           = 'Forest'
    Source          = [ordered] @{
        Name           = 'Subnets verification'
        Data           = {
            Get-WinADForestSubnet -VerifyOverlap -Forest $ForestName
        }
        Details        = [ordered] @{
            Category    = 'Configuration'
            Description = "AD subnets are used so that a machine can work out which AD site they should be in. If you have a subnet that hasn’t been defined to Active Directory, any machines will have difficulty identifying which AD site they should be in. This can easily lead to them authenticating against a domain controller that’s inappropriate from a network standpoint, which will cause a poor logon experience for those users."
            Importance  = 3
            ActionType  = 1
            Resources   = @(
                "[Configuring Active Directory Sites and Subnets](https://theitbros.com/active-directory-sites-and-subnets/)"
                "[How to Create an Active Directory Subnet/Site with /32 or /128 and Why](https://techcommunity.microsoft.com/t5/core-infrastructure-and-security/how-to-create-an-active-directory-subnet-site-with-32-or-128-and/ba-p/256105)"
                "[Active Directory subnets, sites, and site links](https://www.windows-active-directory.com/active-directory-subnets-sites-and-site-links.html)"
                "[Chapter 16. Managing sites and subnets](https://livebook.manning.com/book/learn-active-directory-management-in-a-month-of-lunches/chapter-16/44)"
            )
            StatusTrue  = 1
            StatusFalse = 2
        }
        ExpectedOutput = $true
    }
    Tests           = [ordered] @{
        SubnetsWithoutSites = @{
            Enable      = $true
            Name        = 'Subnets without Sites'
            Description = 'Verify each subnet is attached to a site'
            Parameters  = @{
                WhereObject   = { $_.SiteStatus -eq $false }
                ExpectedCount = 0
            }
            Details     = [ordered] @{
                Category    = 'Configuration'
                Importance  = 5
                ActionType  = 2
                StatusTrue  = 1
                StatusFalse = 3
            }
        }
        SubnetsOverlapping  = @{
            Enable     = $true
            Name       = 'Subnets overlapping'
            Parameters = @{
                WhereObject   = { $_.Overlap -eq $true }
                ExpectedCount = 0
            }
            Details    = [ordered] @{
                Category    = 'Configuration'
                Importance  = 5
                ActionType  = 2
                StatusTrue  = 1
                StatusFalse = 4
            }
        }
    }
    DataDescription = {
        New-HTMLSpanStyle -FontSize 10pt {
            New-HTMLText -Text @(
                "AD subnets are used so that a machine can work out which AD site they should be in. "
                "If you have a subnet that hasn’t been defined to Active Directory, any machines will have difficulty identifying which AD site they should be in. "
                "This can easily lead to them authenticating against a domain controller that’s inappropriate from a network standpoint, which will cause a poor logon experience for those users."
                "There are 3 stages to this test: "
            )
            New-HTMLList {
                New-HTMLListItem -Text "Gather data about subnets. It should return at least one subnet to pass a test. "
                New-HTMLListItem -Text "Find subnets that are not attached to any sites. "
                New-HTMLListItem -Text "Find subnets that are overlapping with other subnets. "
            }
            New-HTMLText -Text @(
                "All three tests are required for properly configured Active Directory. "
            )
        }
    }
    DataHighlights  = {
        New-HTMLTableCondition -Name 'SiteStatus' -ComparisonType string -BackgroundColor PaleGreen -Value $true -Operator eq
        New-HTMLTableCondition -Name 'SiteStatus' -ComparisonType string -BackgroundColor Salmon -Value $false -Operator eq
        New-HTMLTableCondition -Name 'Overlap' -ComparisonType string -BackgroundColor PaleGreen -Value $false -Operator eq
        New-HTMLTableCondition -Name 'Overlap' -ComparisonType string -BackgroundColor Salmon -Value $true -Operator eq

    }
}