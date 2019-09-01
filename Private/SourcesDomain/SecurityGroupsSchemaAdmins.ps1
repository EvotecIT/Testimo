$SecurityGroupsSchemaAdmins = @{
    Enable = $true
    Source = @{
        Name           = "Groups: Schema Admins should be empty"
        Data           = {
            $DomainSID = (Get-ADDomain -Server $Domain).DomainSID
            Get-ADGroupMember -Recursive -Server $Domain -Identity "$DomainSID-518"
        }
        Requirements   = @{
            IsDomainRoot = $true
        }
        ExpectedOutput = $false

        Details        = [ordered] @{
            Area             = ''
            Explanation      = "Schema Admins group should be empty. If you need to manage schema you can always add user for the time of modification."
            Recommendation   = 'Keep Schema group empty.'
            RiskLevel        = 10
            RecommendedLinks = @(
                'https://www.stigviewer.com/stig/active_directory_forest/2016-12-19/finding/V-72835'
            )
        }
    }
}