$DuplicateObjects = @{
    Enable = $true
    Source = @{
        Name    = "Duplicate Objects: 0ACNF"
        Data    = {
            Get-ADObject -LDAPFilter "(|(cn=*\0ACNF:*)(ou=*OACNF:*))" -SearchScope Subtree -Server $Domain
        }
        Implementation = {
            # This may not work for all types of objects. Please make sure to understand what it does first.
            $CNF = Get-ADObject -LDAPFilter "(|(cn=*\0ACNF:*)(ou=*OACNF:*))" -SearchScope Subtree
            foreach ($_ in $CNF) {
                Remove-ADObject -Identity $_.ObjectGUID.Guid -Recursive
            }
        }
        Details = [ordered] @{
            Area        = ''
            Category    = ''
            Severity    = ''
            RiskLevel   = 0
            Description = "CNF objects are objects that are created when two or more objects with the same name are created on different domain controllers. When replication occurs the conflict is resolved by renaming the object with the older timestamp to a name with CNF in it's distinguished name."
            Resolution  = ''
            Resources   = @(
                'https://jorgequestforknowledge.wordpress.com/2014/09/17/finding-conflicting-objects-in-your-ad/'
                'https://social.technet.microsoft.com/Forums/en-US/e9327be6-922c-4b9f-8357-417c3ab6a1af/cnf-remove-from-ad?forum=winserverDS'
                'https://ganeshnadarajanblog.wordpress.com/2017/12/18/find-cnf-objects-in-active-directory/'
                'https://kickthatcomputer.wordpress.com/2014/11/22/seek-and-destroy-duplicate-ad-objects-with-cnf-in-the-name/'
                'https://community.spiceworks.com/topic/2113346-active-directory-replication-cnf-guid-entries'
            )

        }
        ExpectedOutput = $false
    }
}
<# Alternative: dsquery * forestroot -gc -attr distinguishedName -scope subtree -filter "(|(cn=*\0ACNF:*)(ou=*OACNF:*))" #>