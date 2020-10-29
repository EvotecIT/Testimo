$ForestDuplicateObjects = @{
    Enable = $false
    Source = @{
        Name           = 'Duplicate Objects: 0ACNF (Duplicate RDN)'
        Data           = {
            Get-WinADDuplicateObject -Forest $ForestName
        }
        Implementation = {
            # This may not work for all types of objects. Please make sure to understand what it does first.
            $CNF = Get-ADObject -LDAPFilter "(|(cn=*\0ACNF:*)(ou=*OACNF:*))" -SearchScope Subtree
            foreach ($_ in $CNF) {
                Remove-ADObject -Identity $_.ObjectGUID.Guid -Recursive
            }
        }
        Details        = [ordered] @{
            Area        = 'Cleanup'
            Category    = 'Objects'
            Description = "When two objects are created with the same Relative Distinguished Name (RDN) in the same parent Organizational Unit or container, the conflict is recognized by the system when one of the new objects replicates to another domain controller. When this happens, one of the objects is renamed. Some sources say the RDN is mangled to make it unique. The new RDN will be <Old RDN>\0ACNF:<objectGUID>"
            Resolution  = ''
            RiskLevel   = 10
            Severity    = 'Low'
            Resources   = @(
                'https://social.technet.microsoft.com/wiki/contents/articles/15435.active-directory-duplicate-object-name-resolution.aspx'
                'http://ourwinblog.blogspot.com/2011/05/resolving-computer-object-replication.html'
                'https://kickthatcomputer.wordpress.com/2014/11/22/seek-and-destroy-duplicate-ad-objects-with-cnf-in-the-name/'
                'https://gallery.technet.microsoft.com/scriptcenter/Get-ADForestConflictObjects-4667fa37'
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