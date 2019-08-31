$SecurityGroupsAccountOperators     = @{
    Enable = $false
    Source = @{
        Name           = "Groups: Account operators should be empty"
        Data           = {
            Get-ADGroupMember -Identity 'S-1-5-32-548' -Recursive -Server $Domain
        }
        Area           = ''
        Parameters     = @{

        }
        ExpectedOutput = $false
        Explanation    = "The Account Operators group should not be used. Custom delegate instead. This group is a great 'backdoor' priv group for attackers. Microsoft even says don't use this group!"
    }
}