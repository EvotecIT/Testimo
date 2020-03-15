$SecurityGroupsAccountOperators = @{
    Enable = $true
    Source = @{
        Name           = "Groups: Account operators should be empty"
        Data           = {
            Get-ADGroupMember -Identity 'S-1-5-32-548' -Recursive -Server $Domain
        }
        ExpectedOutput = $false
        Details        = [ordered] @{
            Area        = 'Cleanup', 'Security'
            Category    = ''
            Severity    = ''
            RiskLevel   = 0
            Description = "The Account Operators group should not be used. Custom delegate instead. This group is a great 'backdoor' priv group for attackers. Microsoft even says don't use this group!"
            Resolution  = ''
            Resources   = @()
        }
    }
}