$GroupPolicyADM = @{
    Enable = $true
    Source = @{
        Name           = "Group Policy Legacy ADM Files"
        Data           = {
            #$Domain = 'ad.evotec.xyz'
            Get-ChildItem -Path "\\$Domain\SYSVOL\$Domain\policies" -ErrorAction Stop -Recurse -Filter '*.adm' | Select-Object Name, FullName, CreationTime, LastWriteTime, Attributes
        }
        ExpectedOutput = $false
        Details        = [ordered] @{
            Area        = 'Cleanup'
            Category    = 'Group Policy'
            Severity    = ''
            RiskLevel   = 0
            Description = ""
            Resolution  = ''
            Resources   = @(
                'https://sdmsoftware.com/group-policy-blog/tips-tricks/understanding-the-role-of-admx-and-adm-files-in-group-policy/'
                'https://social.technet.microsoft.com/Forums/en-US/bbbe04f5-218b-4526-ae67-cf82a20d49fc/deleting-adm-templates?forum=winserverGP'
                'https://gallery.technet.microsoft.com/scriptcenter/Removing-ADM-files-from-b532e3b6#content'
            )
        }
    }
}