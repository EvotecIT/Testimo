$SecurityKRBGT = @{
    Enable = $true
    Source = @{
        Name           = "Security: Krbtgt password"
        Data           = {
            #Get-ADUser -Filter { name -like "krbtgt*" }  -Property Name, Created, logonCount, Modified, PasswordLastSet, PasswordExpired, msDS-KeyVersionNumber, CanonicalName, msDS-KrbTgtLinkBl -Server $Domain
            Get-ADUser -Identity "krbtgt" -Property Name, Created, logonCount, Modified, PasswordLastSet, PasswordExpired, msDS-KeyVersionNumber, CanonicalName, msDS-KrbTgtLinkBl -Server $Domain
        }
        Details        = [ordered] @{
            Area        = 'Security', 'Cleanup'
            Category    = ''
            Severity    = ''
            RiskLevel   = 0
            Description = ''
            Resolution  = ''
            Resources   = @(
                'https://docs.microsoft.com/en-us/windows-server/identity/ad-ds/manage/ad-forest-recovery-resetting-the-krbtgt-password'
                'https://gallery.technet.microsoft.com/Reset-the-krbtgt-account-581a9e51'
                'https://www.microsoft.com/security/blog/2015/02/11/krbtgt-account-password-reset-scripts-now-available-for-customers/'
            )
        }
        ExpectedOutput = $true
    }
    Tests  = [ordered] @{
        PasswordLastSet = @{
            Enable      = $true
            Name        = 'Krbtgt Last Password Change Should be less than 40 days ago'
            Parameters  = @{
                Property      = 'PasswordLastSet'
                ExpectedValue = '(Get-Date).AddDays(-40)'
                OperationType = 'gt'
            }
            Description = 'User account should be disabled or LastPasswordChange should be less than 1 year ago.'
        }

    }
}