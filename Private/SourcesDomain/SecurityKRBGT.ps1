$SecurityKRBGT = @{
    Name            = 'DomainSecurityKRBGT'
    Enable          = $true
    Scope           = 'Domain'
    Source          = @{
        Name           = "Security: Krbtgt password"
        Data           = {
            #Get-ADUser -Filter { name -like "krbtgt*" }  -Property Name, Created, logonCount, Modified, PasswordLastSet, PasswordExpired, msDS-KeyVersionNumber, CanonicalName, msDS-KrbTgtLinkBl -Server $Domain
            Get-ADUser -Filter { name -like "krbtgt*" } -Property Name, Created, Modified, PasswordLastSet, PasswordExpired, msDS-KeyVersionNumber, CanonicalName, msDS-KrbTgtLinkBl, Description -Server $Domain | Select-Object Name, Enabled, Description, PasswordLastSet, PasswordExpired, msDS-KrbTgtLinkBl, msDS-KeyVersionNumber, CanonicalName, Created, Modified
        }
        Details        = [ordered] @{
            Category    = 'Security'
            Importance  = 10
            ActionType  = 1
            Description = 'A stolen krbtgt account password can wreak havoc on an organization because it can be used to impersonate authentication throughout the organization thereby giving an attacker access to sensitive data.'
            Resources   = @(
                '[AD Forest Recovery - Resetting the krbtgt password](https://docs.microsoft.com/en-us/windows-server/identity/ad-ds/manage/ad-forest-recovery-resetting-the-krbtgt-password)'
                '[KRBTGT Account Password Reset Scripts now available for customers](https://www.microsoft.com/security/blog/2015/02/11/krbtgt-account-password-reset-scripts-now-available-for-customers/)'
                "[Kerberos & KRBTGT: Active Directory's Domain Kerberos Service Account](https://adsecurity.org/?p=483)"
                "[Attacking Read-Only Domain Controllers to Own Active Directory](https://adsecurity.org/?p=3592)"
                '[DETECTING AND PREVENTING A GOLDEN TICKET ATTACK](https://frsecure.com/blog/golden-ticket-attack/)'
                '[Adversary techniques for credential theft and data compromise - Golden Ticket](https://attack.stealthbits.com/how-golden-ticket-attack-works)'
                '[Do You Need to Update KRBTGT Account Password?](https://www.kjctech.net/do-you-need-to-update-krbtgt-account-password/)'
            )
            StatusTrue  = 0
            StatusFalse = 0
        }
        ExpectedOutput = $true
    }
    Tests           = [ordered] @{
        PasswordLastSet        = @{
            Enable      = $false
            Name        = 'Krbtgt Last Password Change should changed frequently'
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
        PasswordLastSetPrimary = @{
            Enable      = $true
            Name        = 'Krbtgt DC password should be changed frequently'
            Parameters  = @{
                WhereObject   = { $_.Name -eq 'krbtgt' -and $_.PasswordLastSet -lt (Get-Date).AddDays(-180) }
                ExpectedCount = 0
                OperationType = 'eq'
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
        PasswordLastSetRODC    = @{
            Enable      = $true
            Name        = 'Krbtgt RODC password should be changed frequently'
            Parameters  = @{
                WhereObject   = { $_.Name -ne 'krbtgt' -and $_.PasswordLastSet -lt (Get-Date).AddDays(-180) }
                ExpectedCount = 0
                OperationType = 'eq'
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
        DeadKerberosAccount    = @{
            Enable      = $true
            Name        = 'Krbtgt RODC account without RODC'
            Parameters  = @{
                WhereObject   = { $_.Name -ne 'krbtgt' -and $_.'msDS-KrbTgtLinkBl'.Count -eq 0 }
                ExpectedCount = 0
                OperationType = 'eq'
            }
            Details     = [ordered] @{
                Category    = 'Security', 'Cleanup'
                Importance  = 5
                ActionType  = 2
                StatusTrue  = 1
                StatusFalse = 2
            }
            Description = 'Kerberos accounts for dead RODCs should be removed'
        }
    }
    DataInformation = {
        New-HTMLText -Text 'Explanation to table columns:' -FontSize 10pt
        New-HTMLList {
            New-HTMLListItem -FontWeight bold, normal -Text "PasswordLastSet", " - shows the last date password for Kerberos was changed."
            New-HTMLListItem -FontWeight bold, normal -Text "msDS-KrbTgtLinkBl", " - shows linked RODC. If name contains numbers and msDS-KrbTgtLinkBl is empty the kerberos account is not required."
        } -FontSize 10pt

        New-HTMLText -Text "Please keep in mind that if there are more than one keberos account it means there are RODC having own krbtgt account. " -FontSize 10pt
    }
    DataHighlights  = {
        New-HTMLTableConditionGroup {
            New-HTMLTableCondition -Name 'Name' -Value 'krbtgt' -Operator ne -ComparisonType string
            New-HTMLTableCondition -Name 'msDS-KrbTgtLinkBl' -Value '' -Operator eq -ComparisonType string
        } -Row -BackgroundColor Salmon
        New-HTMLTableCondition -Name 'PasswordLastSet' -ComparisonType date -BackgroundColor PaleGreen -Value (Get-Date).AddDays(-180) -Operator gt -FailBackgroundColor Salmon -DateTimeFormat 'DD.MM.YYYY HH:mm:ss'
        New-HTMLTableCondition -Name 'Enabled' -ComparisonType string -BackgroundColor PaleGreen -Value $false -Operator eq -FailBackgroundColor Salmon
    }
}