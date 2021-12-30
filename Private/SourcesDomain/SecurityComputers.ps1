$DomainSecurityComputers = @{
    Enable          = $true
    Scope           = 'Domain'
    Source          = @{
        Name           = "Computers: Standard"
        Data           = {
            $Properties = @(
                'SamAccountName'
                'UserPrincipalName'
                'Enabled'
                'PasswordNotRequired'
                'AllowReversiblePasswordEncryption'
                'UseDESKeyOnly'
                'PasswordLastSet'
                'LastLogonDate'
                'PasswordNeverExpires'
                'PrimaryGroup'
                'PrimaryGroupID'
                'DistinguishedName'
                'Name'
                'SID'
            )
            Get-ADComputer -Filter { (PasswordNeverExpires -eq $true -or AllowReversiblePasswordEncryption -eq $true -or UseDESKeyOnly -eq $true -or (PrimaryGroupID -ne '515' -and PrimaryGroupID -ne '516' -and PrimaryGroupID -ne '521') -or PasswordNotRequired -eq $true) } -Properties $Properties -Server $Domain | Where-Object { $_.SamAccountName -ne 'AZUREADSSOACC$' } | Select-Object -Property $Properties
        }
        Details        = [ordered] @{
            Category    = 'Security', 'Cleanup'
            Importance  = 0
            ActionType  = 0
            Description = 'Account by default have certain settings that make sure the account is fairly safe and can be used within Active Directory.'
            Resources   = @(
                '[Understanding and Remediating "PASSWD_NOTREQD](https://docs.microsoft.com/en-us/archive/blogs/russellt/passwd_notreqd)'
                '[Miscellaneous facts about computer passwords in Active Directory](https://blog.joeware.net/2012/09/12/2590/)'
                '[Domain member: Maximum machine account password age](https://docs.microsoft.com/en-us/previous-versions/windows/it-pro/windows-server-2012-R2-and-2012/jj852252(v=ws.11)?redirectedfrom=MSDN)'
                '[Machine Account Password Process](https://techcommunity.microsoft.com/t5/ask-the-directory-services-team/machine-account-password-process/ba-p/396026)'
            )
            StatusTrue  = 1
            StatusFalse = 0
        }
        ExpectedOutput = $false
    }
    Tests           = [ordered] @{
        KeberosDES                        = @{
            Enable      = $true
            Name        = 'Kerberos DES detection'
            Parameters  = @{
                WhereObject    = { $_.UseDESKeyOnly -eq $true }
                ExpectedCount  = 0
                OperationType  = 'eq'
                ExpectedOutput = $false
            }
            Details     = [ordered] @{
                Category    = 'Security'
                Importance  = 5
                ActionType  = 2
                StatusTrue  = 1
                StatusFalse = 5
            }
            Description = "Computer accounts shouldn't use DES encryption. Having UseDESKeyOnly forces the Kerberos encryption to be DES instead of RC4 which is the Microsoft default. DES is 56 bit encryption and is regarded as weak these days so this setting is not recommended."
        }
        AllowReversiblePasswordEncryption = @{
            Enable      = $true
            Name        = 'Reversible Password detection'
            Parameters  = @{
                WhereObject    = { $_.AllowReversiblePasswordEncryption -eq $true }
                ExpectedCount  = 0
                OperationType  = 'eq'
                ExpectedOutput = $false
            }
            Details     = [ordered] @{
                Category    = 'Security'
                Importance  = 5
                ActionType  = 2
                StatusTrue  = 1
                StatusFalse = 5
            }
            Description = "Computer accounts shouldn't use Reversible Password Encryption. Having AllowReversiblePasswordEncryption allows for easy password decryption."
        }
        PasswordNeverExpires              = @{
            Enable      = $true
            Name        = 'PasswordNeverExpires detection'
            Parameters  = @{
                WhereObject    = { $_.PasswordNeverExpires -eq $true }
                ExpectedCount  = 0
                OperationType  = 'eq'
                ExpectedOutput = $false
            }
            Details     = [ordered] @{
                Category    = 'Security'
                Importance  = 5
                ActionType  = 2
                StatusTrue  = 1
                StatusFalse = 5
            }
            Description = "Computer accounts shouldn't use PasswordNeverExpires. Having PasswordNeverExpires is dangerous and shoudn't be used."
        }
        PasswordNotRequired               = @{
            Enable      = $true
            Name        = 'PasswordNotRequired detection'
            Parameters  = @{
                WhereObject    = { $_.PasswordNotRequired -eq $true }
                ExpectedCount  = 0
                OperationType  = 'eq'
                ExpectedOutput = $false
            }
            Details     = [ordered] @{
                Category    = 'Security'
                Importance  = 5
                ActionType  = 2
                StatusTrue  = 1
                StatusFalse = 5
            }
            Description = "Computer accounts shouldn't use PasswordNotRequired. Having PasswordNotRequired is dangerous and shoudn't be used."
        }
        PrimaryGroup                      = @{
            Enable      = $true
            Name        = "Domain Computers or Domain Controllers or Read-Only Domain Controllers."
            Parameters  = @{
                #WhereObject    = { $_.PrimaryGroupID -ne 513 -and $_.SID -ne "$((Get-ADDomain).DomainSID.Value)-501" }
                WhereObject    = { $_.PrimaryGroupID -notin 515, 516, 521 }
                ExpectedCount  = 0
                OperationType  = 'eq'
                ExpectedOutput = $false
            }
            Details     = [ordered] @{
                Category    = 'Security'
                Importance  = 5
                ActionType  = 2
                StatusTrue  = 1
                StatusFalse = 4
            }
            Description = "Computer accounts shouldn't have different group then Domain Computers or Domain Controllers or Read-Only Domain Controllers as their primary group."
        }
    }
    DataDescription = {
        New-HTMLSpanStyle -FontSize 10pt {
            New-HTMLText -Text @(
                "Account by default have certain settings that make sure the account is fairly safe and can be used within Active Directory. "
                "Those settings are: "
            )
            New-HTMLList {
                New-HTMLListItem -Text "Password is always required"
                New-HTMLListItem -Text "Password is expiring"
                New-HTMLListItem -Text "Password is not reverisble"
                New-HTMLListItem -Text "Keberos Encryption is set to RC4"
                New-HTMLListItem -Text "Primary Group is always Domain Computers/Domain Cotrollers or Domain Read-Only Controllers"
            }
            New-HTMLText -Text @(
                "It's important that all those settings are set as expected."
            )
        }
    }
    DataHighlights  = {
        New-HTMLTableCondition -Name 'Enabled' -ComparisonType string -BackgroundColor PaleGreen -Value $true -Operator eq -FailBackgroundColor Salmon
        New-HTMLTableCondition -Name 'PasswordNotRequired' -ComparisonType string -BackgroundColor PaleGreen -Value $false -Operator eq -FailBackgroundColor Salmon
        New-HTMLTableCondition -Name 'PasswordNeverExpires' -ComparisonType string -BackgroundColor PaleGreen -Value $false -Operator eq -FailBackgroundColor Salmon
        New-HTMLTableCondition -Name 'AllowReversiblePasswordEncryption' -ComparisonType string -BackgroundColor PaleGreen -Value $false -Operator eq -FailBackgroundColor Salmon
        New-HTMLTableCondition -Name 'UseDESKeyOnly' -ComparisonType string -BackgroundColor PaleGreen -Value $false -Operator eq -FailBackgroundColor Salmon
        New-HTMLTableCondition -Name 'PrimaryGroupID' -ComparisonType number -BackgroundColor PaleGreen -Value 515, 516, 521 -Operator in -FailBackgroundColor Salmon -HighlightHeaders 'PrimaryGroupID', 'PrimaryGroup'
        New-HTMLTableCondition -Name 'PasswordLastSet' -ComparisonType date -BackgroundColor PaleGreen -Value (Get-Date).AddDays(-180) -Operator gt -FailBackgroundColor Salmon -DateTimeFormat 'DD.MM.YYYY HH:mm:ss'
        New-HTMLTableCondition -Name 'LastLogonDate' -ComparisonType date -BackgroundColor PaleGreen -Value (Get-Date).AddDays(-180) -Operator gt -FailBackgroundColor Salmon -DateTimeFormat 'DD.MM.YYYY HH:mm:ss'
    }
    DataInformation = {
        New-HTMLText -Text 'Explanation to table columns:' -FontSize 10pt
        New-HTMLList {
            New-HTMLListItem -FontWeight bold, normal -Text "PasswordNotRequired", " - means password is not required by the account. This should be investigated right away. "
            New-HTMLListItem -FontWeight bold, normal -Text "PasswordNeverExpires", " - means password is not required by the account. This should be investigated right away. "
            New-HTMLListItem -FontWeight bold, normal -Text "AllowReversiblePasswordEncryption", " - means the password is stored insecurely in Active Directory. Removing this flag is required. "
            New-HTMLListItem -FontWeight bold, normal -Text "UseDESKeyOnly", " - means the kerberos encryption is set to DES which is very weak. Removing flag is required. "
            New-HTMLListItem -FontWeight bold, normal -Text "PrimaryGroupID", " - if primary group ID is something else then 513 it means someone made a primary group change to something else than Domain Users. This should be fixed. "
        } -FontSize 10pt
    }
}