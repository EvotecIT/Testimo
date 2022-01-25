$SysVolDFSR = @{
    Name   = 'DomainSysVolDFSR'
    Enable = $true
    Scope  = 'Domain'
    Source = @{
        Name           = "DFSR Flags"
        Data           = {
            $DistinguishedName = (Get-ADDomain -Server $Domain).DistinguishedName
            $ADObject = "CN=DFSR-GlobalSettings,CN=System,$DistinguishedName"
            $Object = Get-ADObject -Identity $ADObject -Properties * -Server $Domain
            if ($Object.'msDFSR-Flags' -gt 47) {
                [PSCustomObject] @{
                    'SysvolMode' = 'DFS-R'
                    'Flags'      = $Object.'msDFSR-Flags'
                }
            } else {
                [PSCustomObject] @{
                    'SysvolMode' = 'Not DFS-R'
                    'Flags'      = $Object.'msDFSR-Flags'
                }
            }
        }
        Details        = [ordered] @{
            Area        = 'Health'
            Category    = 'SYSVOL'
            Severity    = ''
            Importance  = 0
            Description = 'Checks if DFS-R is available.'
            Resolution  = ''
            Resources   = @(
                'https://blogs.technet.microsoft.com/askds/2009/01/05/dfsr-sysvol-migration-faq-useful-trivia-that-may-save-your-follicles/'
                'https://dirteam.com/sander/2019/04/10/knowledgebase-in-place-upgrading-domain-controllers-to-windows-server-2019-while-still-using-ntfrs-breaks-sysvol-replication-and-dslocator/'
            )
        }
        ExpectedOutput = $true
    }
    Tests  = [ordered] @{
        DFSRSysvolState = @{
            Enable     = $true
            Name       = 'DFSR Sysvol State'
            Parameters = @{
                Property              = 'SysvolMode'
                ExpectedValue         = 'DFS-R'
                OperationType         = 'eq'
                PropertyExtendedValue = 'Flags'
            }
        }
    }
}