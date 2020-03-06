$ObjectsWithConflict = @{
    Enable = $true
    Source = @{
        Name           = 'Objects with Conflict (Duplicate RDN)'
        Data           = {
            Get-WinADForestObjectsConflict -Forest $ForestName
        }
        ExpectedOutput = $false
        Details        = [ordered] @{
            Area        = 'Features'
            Description = "When two objects are created with the same Relative Distinguished Name (RDN) in the same parent Organizational Unit or container, the conflict is recognized by the system when one of the new objects replicates to another domain controller. When this happens, one of the objects is renamed. Some sources say the RDN is mangled to make it unique. The new RDN will be <Old RDN>\0ACNF:<objectGUID>"
            Resolution  = ''
            RiskLevel   = 10
            Resources   = @(
                'https://social.technet.microsoft.com/wiki/contents/articles/15435.active-directory-duplicate-object-name-resolution.aspx'
                'http://ourwinblog.blogspot.com/2011/05/resolving-computer-object-replication.html'
                'https://kickthatcomputer.wordpress.com/2014/11/22/seek-and-destroy-duplicate-ad-objects-with-cnf-in-the-name/'
                'https://gallery.technet.microsoft.com/scriptcenter/Get-ADForestConflictObjects-4667fa37'
            )
        }
    }
}