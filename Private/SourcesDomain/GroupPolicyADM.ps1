$GroupPolicyADM = @{
    Name   = 'DomainGroupPolicyADM'
    Enable = $true
    Scope  = 'Domain'
    Source = @{
        Name           = 'Group Policy Legacy ADM Files'
        Data           = {
            Get-GPOZaurrLegacyFiles -Forest $ForestName -IncludeDomains $Domain
        }
        Implementation = {
            Remove-GPOZaurrLegacyFiles -Verbose -WhatIf
        }
        Details        = [ordered] @{
            Area        = 'GroupPolicy'
            Category    = 'Cleanup'
            Severity    = ''
            Importance  = 0
            Description = ''
            Resolution  = ''
            Resources   = @(
                'https://support.microsoft.com/en-us/help/816662/recommendations-for-managing-group-policy-administrative-template-adm'
                'https://docs.microsoft.com/en-us/previous-versions/windows/it-pro/windows-vista/cc709647(v=ws.10)?redirectedfrom=MSDN'
                'https://sdmsoftware.com/group-policy-blog/tips-tricks/understanding-the-role-of-admx-and-adm-files-in-group-policy/'
                'https://social.technet.microsoft.com/Forums/en-US/bbbe04f5-218b-4526-ae67-cf82a20d49fc/deleting-adm-templates?forum=winserverGP'
                'https://gallery.technet.microsoft.com/scriptcenter/Removing-ADM-files-from-b532e3b6#content'
            )
        }
        ExpectedOutput = $false
    }
}