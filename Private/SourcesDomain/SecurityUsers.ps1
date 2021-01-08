$SecurityUsers = @{
    Enable = $true
    Scope  = 'Domain'
    Source = @{
        Name    = "Users: Standard"
        Data    = {
            # this test is kind of special
            # basically when account is disabled it doesn't make sense to check for PasswordLastSet
            # therefore i'm adding setting PasswordLastSet to current date to be able to test just that field
            # At least until support for multiple checks is added
            <#
            $DomainSID = (Get-ADDomain -Server $Domain).DomainSID
            $User = Get-ADUser -Identity "$DomainSID-500" -Properties PasswordLastSet, LastLogonDate, servicePrincipalName -Server $Domain
            if ($User.Enabled -eq $false) {
                [PSCustomObject] @{
                    Name            = 'Administrator'
                    PasswordLastSet = Get-Date
                }
            } else {
                [PSCustomObject] @{
                    Name            = 'Administrator'
                    PasswordLastSet = $User.PasswordLastSet
                }
            }
            #>
            #Get-ADUser -Filter { AllowReversiblePasswordEncryption -eq $true -or UseDESKeyOnly -eq $true -or (PrimaryGroupID -ne '513' -and PrimaryGroupID -ne '514') } -Properties AllowReversiblePasswordEncryption, UseDESKeyOnly, PrimaryGroup, PrimaryGroupID, PasswordLastSet, Enabled -Server $Domain
            $GuestSID = "$((Get-ADDomain -Server $Domain).DomainSID.Value)-501"
            Get-ADUser -Filter { (AllowReversiblePasswordEncryption -eq $true -or UseDESKeyOnly -eq $true -or PrimaryGroupID -ne '513') -and (SID -ne $GuestSID) } -Properties AllowReversiblePasswordEncryption, UseDESKeyOnly, PrimaryGroup, PrimaryGroupID, PasswordLastSet, Enabled -Server $Domain
        }
        Details = [ordered] @{
            Area        = ''
            Category    = ''
            Severity    = ''
            RiskLevel   = 0
            Description = ''
            Resolution  = ''
            Resources   = @(

            )
        }
        ExpectedOutput = $false
    }
    Tests  = [ordered] @{
        <#
        PasswordLastSet                   = @{
            Enable      = $true
            Name        = 'User Last Password Change Should be less than 360 days ago'
            Parameters  = @{
                Property      = 'PasswordLastSet'
                ExpectedValue = '(Get-Date).AddDays(-360)'
                OperationType = 'gt'
            }
            Description = 'User account should be disabled or LastPasswordChange should be less than 1 year ago.'
        }
        #>
        KeberosDES                        = @{
            Enable      = $true
            Name        = 'Kerberos DES detection'
            Parameters  = @{
                WhereObject   = { $_.UseDESKeyOnly -eq $true }
                ExpectedCount = 0
                OperationType = 'eq'
                ExpectedOutput = $false
            }
            Description = "User accounts shouldn't use DES encryption. Having UseDESKeyOnly forces the Kerberos encryption to be DES instead of RC4 which is the Microsoft default. DES is 56 bit encryption and is regarded as weak these days so this setting is not recommended."
        }
        AllowReversiblePasswordEncryption = @{
            Enable      = $true
            Name        = 'Reversible Password detection'
            Parameters  = @{
                WhereObject   = { $_.AllowReversiblePasswordEncryption -eq $true }
                ExpectedCount = 0
                OperationType = 'eq'
                ExpectedOutput = $false
            }
            Description = "User accounts shouldn't use Reversible Password Encryption. Having AllowReversiblePasswordEncryption allows for easy password decryption."
        }
        PrimaryGroup                      = @{
            Enable      = $true
            Name        = "Primary Group shouldn't be changed from default Domain Users."
            Parameters  = @{
                WhereObject   = { $_.PrimaryGroupID -ne 513 -and $_.SID -ne "$((Get-ADDomain).DomainSID.Value)-501" }
                ExpectedCount = 0
                OperationType = 'eq'
                ExpectedOutput = $false
            }
            Description = "User accounts shouldn't have different group then Domain Users as their primary group."
        }
    }
}