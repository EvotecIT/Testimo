$SecurityUsers = @{
    Enable          = $true
    Scope           = 'Domain'
    Source          = @{
        Name           = "Users: Standard"
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
                'PrimaryGroup'
                'PrimaryGroupID'
                'DistinguishedName'
                'Name'
                #'ObjectClass'
                #'ObjectGUID'
                'SID'
                'SamAccountType'
                #'GivenName'
                #'Surname'
            )
            $GuestSID = "$($DomainInformation.DomainSID)-501"
            # Skipping trusts with SamAccountType and Guests
            # Skipping Exchange_Online-ApplicationAccount because it doesn't require password by default (also disabled)
            Get-ADUser -Filter { (AllowReversiblePasswordEncryption -eq $true -or UseDESKeyOnly -eq $true -or PrimaryGroupID -ne '513' -or PasswordNotRequired -eq $true) -and (SID -ne $GuestSID -and SamAccountType -ne 805306370) } -Properties $Properties -Server $Domain | Where-Object { $_.UserPrincipalName -notlike 'Exchange_Online-ApplicationAccount*' } | Select-Object -Property $Properties
        }
        Details        = [ordered] @{
            Category    = 'Security', 'Cleanup'
            Importance  = 0
            ActionType  = 0
            Description = 'Account by default have certain settings that make sure the account is fairly safe and can be used within Active Directory.'
            Resources   = @(

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
            Description = "User accounts shouldn't use DES encryption. Having UseDESKeyOnly forces the Kerberos encryption to be DES instead of RC4 which is the Microsoft default. DES is 56 bit encryption and is regarded as weak these days so this setting is not recommended."
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
            Description = "User accounts shouldn't use Reversible Password Encryption. Having AllowReversiblePasswordEncryption allows for easy password decryption."
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
            Description = "User accounts shouldn't use PasswordNotRequired. Having PasswordNotRequired is dangerous and shoudn't be used."
        }
        PrimaryGroup                      = @{
            Enable      = $true
            Name        = "Primary Group shouldn't be changed from default Domain Users."
            Parameters  = @{
                #WhereObject    = { $_.PrimaryGroupID -ne 513 -and $_.SID -ne "$((Get-ADDomain).DomainSID.Value)-501" }
                WhereObject    = { $_.PrimaryGroupID -ne 513 -and $_.SID -ne "$($DomainInformation.DomainSID)-501" }
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
            Description = "User accounts shouldn't have different group then Domain Users as their primary group."
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
                New-HTMLListItem -Text "Password is not reverisble"
                New-HTMLListItem -Text "Keberos Encryption is set to RC4"
                New-HTMLListItem -Text "Primary Group is always Domain Users with exception of Domain Guests"
            }
            New-HTMLText -Text @(
                "It's important that all those settings are set as expected."
            )
        }
    }
    DataHighlights  = {
        New-HTMLTableCondition -Name 'Enabled' -ComparisonType string -BackgroundColor PaleGreen -Value $true -Operator eq -FailBackgroundColor Salmon
        New-HTMLTableCondition -Name 'PasswordNotRequired' -ComparisonType string -BackgroundColor PaleGreen -Value $false -Operator eq -FailBackgroundColor Salmon
        New-HTMLTableCondition -Name 'AllowReversiblePasswordEncryption' -ComparisonType string -BackgroundColor PaleGreen -Value $false -Operator eq -FailBackgroundColor Salmon
        New-HTMLTableCondition -Name 'UseDESKeyOnly' -ComparisonType string -BackgroundColor PaleGreen -Value $false -Operator eq -FailBackgroundColor Salmon
        New-HTMLTableCondition -Name 'PrimaryGroupID' -ComparisonType string -BackgroundColor PaleGreen -Value '513' -Operator eq -FailBackgroundColor Salmon -HighlightHeaders 'PrimaryGroupID', 'PrimaryGroup'
        New-HTMLTableCondition -Name 'PasswordLastSet' -ComparisonType date -BackgroundColor PaleGreen -Value (Get-Date).AddDays(-180) -Operator gt -FailBackgroundColor Salmon -DateTimeFormat 'DD.MM.YYYY HH:mm:ss'
        New-HTMLTableCondition -Name 'LastLogonDate' -ComparisonType date -BackgroundColor PaleGreen -Value (Get-Date).AddDays(-180) -Operator gt -FailBackgroundColor Salmon -DateTimeFormat 'DD.MM.YYYY HH:mm:ss'
    }
    DataInformation = {
        New-HTMLText -Text 'Explanation to table columns:' -FontSize 10pt
        New-HTMLList {
            New-HTMLListItem -FontWeight bold, normal -Text "PasswordNotRequired", " - means password is not required by the account. This should be investigated right away. "
            New-HTMLListItem -FontWeight bold, normal -Text "AllowReversiblePasswordEncryption", " - means the password is stored insecurely in Active Directory. Removing this flag is required. "
            New-HTMLListItem -FontWeight bold, normal -Text "UseDESKeyOnly", " - means the kerberos encryption is set to DES which is very weak. Removing flag is required. "
            New-HTMLListItem -FontWeight bold, normal -Text "PrimaryGroupID", " - if primary group ID is something else then 513 it means someone made a primary group change to something else than Domain Users. This should be fixed. "
        } -FontSize 10pt
    }
}