$SecurityKRBGT = @{
    Enable          = $true
    Scope           = 'Domain'
    Source          = @{
        Name           = "Security: Krbtgt password"
        Data           = {
            #Get-ADUser -Filter { name -like "krbtgt*" }  -Property Name, Created, logonCount, Modified, PasswordLastSet, PasswordExpired, msDS-KeyVersionNumber, CanonicalName, msDS-KrbTgtLinkBl -Server $Domain
            Get-ADUser -Filter { name -like "krbtgt*" } -Property Name, Created, logonCount, Modified, PasswordLastSet, PasswordExpired, msDS-KeyVersionNumber, CanonicalName, msDS-KrbTgtLinkBl -Server $Domain | Select-Object Name, Created, logonCount, Modified, PasswordLastSet, PasswordExpired, msDS-KeyVersionNumber, CanonicalName, msDS-KrbTgtLinkBl
        }
        Details        = [ordered] @{
            Category    = 'Security'
            Importance  = 10
            ActionType  = 1
            Description = 'A stolen krbtgt account password can wreak havoc on an organization because it can be used to impersonate authentication throughout the organization thereby giving an attacker access to sensitive data.'
            Resources   = @(
                'https://docs.microsoft.com/en-us/windows-server/identity/ad-ds/manage/ad-forest-recovery-resetting-the-krbtgt-password'
                'https://gallery.technet.microsoft.com/Reset-the-krbtgt-account-581a9e51'
                'https://www.microsoft.com/security/blog/2015/02/11/krbtgt-account-password-reset-scripts-now-available-for-customers/'
            )
            StatusTrue  = 0
            StatusFalse = 0
        }
        ExpectedOutput = $true
    }
    Tests           = [ordered] @{
        PasswordLastSet = @{
            Enable      = $true
            Name        = 'Krbtgt Last Password Change Should be less than 180 days ago'
            Parameters  = @{
                Property      = 'PasswordLastSet'
                ExpectedValue = '(Get-Date).AddDays(-180)'
                OperationType = 'gt'
            }
            Details     = [ordered] @{
                Category    = 'Security'
                Importance  = 8
                ActionType  = 2
                StatusTrue  = 1
                StatusFalse = 5
            }
            Description = 'LastPasswordChange should be less than 180 days ago.'
        }
    }
    DataInformation = {
        New-HTMLText -Text 'Explanation to table columns:' -FontSize 10pt
        New-HTMLList {
            New-HTMLListItem -FontWeight bold, normal -Text "PasswordLastSet", " - shows the last date password for Kerberos was changed."
        } -FontSize 10pt

        New-HTMLText -Text "Please keep in mind that if there are more than one keberos account it means there are RODC having own krbtgt account. " -FontSize 10pt
    }
    DataHighlights  = {
        New-HTMLTableCondition -Name 'PasswordLastSet' -ComparisonType date -BackgroundColor PaleGreen -Value (Get-Date).AddDays(-180) -Operator gt -FailBackgroundColor Salmon -DateTimeFormat 'DD.MM.YYYY HH:mm:ss'
    }
}