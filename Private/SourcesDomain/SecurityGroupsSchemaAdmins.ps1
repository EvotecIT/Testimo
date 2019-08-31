$SecurityGroupsSchemaAdmins         = @{
    Enable = $false
    Source = @{
        Name           = "Groups: Schema Admins should be empty"
        Data           = {
            $DomainSID = (Get-ADDomain -Server $Domain).DomainSID
            Get-ADGroupMember -Recursive -Server $Domain -Identity "$DomainSID-518"
        }
        Area           = ''
        Parameters     = @{

        }
        Requirements   = @{
            IsDomainRoot = $true
        }
        ExpectedOutput = $false
        Explanation    = "Schema Admins should be empty."
    }
}