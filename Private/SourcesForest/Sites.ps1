$Sites = @{
    Name            = "ForestSites"
    Enable          = $true
    Scope           = 'Forest'
    Source          = [ordered] @{
        Name           = 'Forest Sites'
        Data           = {
            Get-WinADForestSites -Forest $ForestName
        }
        Details        = [ordered] @{
            Category    = 'Configuration'
            Description = 'Sites are Active Directory objects that represent one or more TCP/IP subnets with highly reliable and fast network connections. Site information allows administrators to configure Active Directory access and replication to optimize usage of the physical network. Site objects are associated with a set of subnets, and each domain controller in a forest is associated with an Active Directory site according to its IP address. Sites can host domain controllers from more than one domain, and a domain can be represented in more than one site.'
            Importance  = 0
            ActionType  = 0
            Resources   = @(
                "[Site Functions](https://docs.microsoft.com/en-us/windows-server/identity/ad-ds/plan/site-functions)"
                "[Active Directory Sites](https://www.windows-active-directory.com/active-directory-sites.html)"
            )
            StatusTrue  = 0
            StatusFalse = 0
        }
        ExpectedOutput = $true
    }
    Tests           = [ordered] @{
        SitesWithoutDC      = @{
            Enable      = $true
            Name        = 'Sites without Domain Controllers'
            Description = 'Verify each `site has at least [one subnet configured]`'
            Parameters  = @{
                WhereObject   = { $_.DomainControllersCount -eq 0 }
                ExpectedCount = 0
            }
            Details     = [ordered] @{
                Category    = 'Configuration'
                Importance  = 0
                ActionType  = 0
                StatusTrue  = 1
                StatusFalse = 0
            }
        }
        SitesWithoutSubnets = @{
            Enable     = $true
            Name       = 'Sites without Subnets'
            Parameters = @{
                WhereObject   = { $_.SubnetsCount -eq 0 }
                ExpectedCount = 0
            }
            Details    = [ordered] @{
                Category    = 'Configuration'
                Importance  = 5
                ActionType  = 2
                StatusTrue  = 1
                StatusFalse = 2
            }
        }
    }
    DataDescription = {
        New-HTMLSpanStyle -FontSize 10pt {
            New-HTMLText -Text @(
                "Sites are Active Directory objects that represent one or more TCP/IP subnets with highly reliable and fast network connections. "
                "Site information allows administrators to configure Active Directory access and replication to optimize usage of the physical network. "
                "Site objects are associated with a set of subnets, and each domain controller in a forest is associated with an Active Directory site according to its IP address. "
                "Sites can host domain controllers from more than one domain, and a domain can be represented in more than one site."
            ) #-LineBreak
            New-HTMLText -Text @(
                "Sites without subnets have no role and just stay there unused. "
                "Sites without Domain Controllers still have their role in the Active Directory Topology. "
                "Following tests finds "
                "sites without subnets "
                "and Domain Admins role is to asses whether such stie is still needed and is just missing a subnet, or should be deleted because it's no longer required. "
                "Following tests also finds "
                "sites without Domain Controllers"
                ", but this test is just informational - although if Domain Admin is aware of a site that is no longer required it should be deleted. "
            ) -FontWeight normal, normal, normal, bold, normal, normal, bold, normal
        }
    }
    DataHighlights  = {
        New-HTMLTableCondition -Name 'SubnetsCount' -ComparisonType number -BackgroundColor PaleGreen -Value 0 -Operator gt
        New-HTMLTableCondition -Name 'SubnetsCount' -ComparisonType number -BackgroundColor Salmon -Value 0 -Operator eq
        New-HTMLTableCondition -Name 'DomainControllersCount' -ComparisonType number -BackgroundColor PaleGreen -Value 0 -Operator gt
    }
    Solution        = {
        New-HTMLContainer {
            New-HTMLSpanStyle -FontSize 10pt {
                New-HTMLWizard {
                    New-HTMLWizardStep -Name 'Investigate Sites without Subnets' {
                        New-HTMLText -Text @(
                            "Sites without subnets have no use. "
                            "It can mean the site is no longer in use and can be safely deleted. "
                            ""
                            "Please investigate and find out if that's really the case. "
                            "Otherwise you should create proper subnet for given site. "
                        )
                    }
                    New-HTMLWizardStep -Name 'Investigate Sites without Domain Controllers (optional)' {
                        New-HTMLText -Text @(
                            "Sites without Domain Controllers do happen and are quite common. "
                            "But this isn't always true. "
                            "Consider investigating whether sites without Domain Controller are as expected. "
                        ) -FontWeight normal, bold, normal, normal, normal, normal, bold, bold
                    }
                } -RemoveDoneStepOnNavigateBack -Theme arrows -ToolbarButtonPosition center -EnableAllAnchors
            }
        }
    }
}