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
        Details        = [ordered] @{
            Area        = 'Cleanup', 'Security'
            Category    = ''
            Severity    = ''
            RiskLevel   = 0
            Description = "Schema Admins group should be empty. If you need to manage schema you can always add user for the time of modification."
            Resolution  = 'Keep Schema group empty.'
            Resources   = @(
                'https://www.stigviewer.com/stig/active_directory_forest/2016-12-19/finding/V-72835'
            )

        }
        ExpectedOutput = $false
    }
}