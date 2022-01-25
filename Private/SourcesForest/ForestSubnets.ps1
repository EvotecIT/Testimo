$ForestSubnets = @{
    Name            = 'ForestSubnets'
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
                "This can easily lead to them authenticating against a domain controller that’s inappropriate from a network standpoint, which will cause a poor logon experience for those users. "
                "There are 3 stages to this test: "
            )
            New-HTMLList {
                New-HTMLListItem -Text "Gather data about subnets. It should return at least one subnet to pass a test. "
                New-HTMLListItem -Text "Find subnets that are not attached to any sites. "
                New-HTMLListItem -Text "Find subnets that are overlapping with other subnets. "
            }
            New-HTMLText -Text @(
                "All three tests are required to pass for properly configured Active Directory. "
            )
        }
    }
    DataHighlights  = {
        New-HTMLTableCondition -Name 'SiteStatus' -ComparisonType string -BackgroundColor PaleGreen -Value $true -Operator eq -FailBackgroundColor Salmon
        #New-HTMLTableCondition -Name 'SiteStatus' -ComparisonType string -BackgroundColor Salmon -Value $false -Operator eq
        New-HTMLTableCondition -Name 'Overlap' -ComparisonType string -BackgroundColor PaleGreen -Value $false -Operator eq
        New-HTMLTableCondition -Name 'Overlap' -ComparisonType string -BackgroundColor Salmon -Value $true -Operator eq
    }
    DataInformation = {
        New-HTMLText -Text 'Explanation to table columns:' -FontSize 10pt
        New-HTMLList {
            New-HTMLListItem -FontWeight bold, normal -Text "SiteStatus", " - means subnet is assigned to a site. If it's false that means subnet is orphaned and it should be reassigned to proper site or deleted. "
            New-HTMLListItem -FontWeight bold, normal -Text "Overlap", " - means subnet is overlapping with other subnets which are shown in OverLapList column. This needs to be resolved by working with Network Team. "
        } -FontSize 10pt

        New-HTMLText -Text "Please keep in mind that overlapping is only assesed for IPv4. IPv6 is not assed. Site Status however works as expected for IPv6 as well." -FontSize 10pt
    }
    Solution        = {
        New-HTMLContainer {
            New-HTMLSpanStyle -FontSize 10pt {
                New-HTMLWizard {
                    New-HTMLWizardStep -Name 'Investigate Subnets without Sites' {
                        New-HTMLText -Text @(
                            "Subnets without sites are pretty uncommon. "
                            "This usually happens if site is deleted while the subnets are still attached to it. "
                            "Subnets without sites have no use. "
                            ""
                            "Please move subnet to proper site, or if it's no longer needed, remove it totally. "
                        )
                    }
                    New-HTMLWizardStep -Name 'Investigate Subnets overlapping' {
                        New-HTMLText -Text @(
                            "Subnets are supposed to be unique across forest. "
                            "You can assign only one subnet to only one site. "
                            "However it's possible to define subnets that overlap already defined subnets such as 10.0.0.0/8 will overlap with 10.0.20.32/32. "
                            "This shouldn't happen as it will influence authentication process and cause poor logon experience. "
                            ""
                            "Investigate why subnets are added with overlap and fix it. "
                            "Please make sure to consult it with appriopriate people or/and network team. "
                        ) -FontWeight normal, bold, normal, normal, normal, normal, bold, bold
                    }
                } -RemoveDoneStepOnNavigateBack -Theme arrows -ToolbarButtonPosition center -EnableAllAnchors
            }
        }
    }
}