$SecurityUsersAcccountAdministrator = @{
    Name   = 'DomainSecurityUsersAcccountAdministrator'
    Enable = $true
    Scope  = 'Domain'
    Source = @{
        Name           = "Users: Administrator"
        Data           = {
            # this test is kind of special
            # basically when account is disabled it doesn't make sense to check for PasswordLastSet
            # therefore i'm adding setting PasswordLastSet to current date to be able to test just that field
            # At least until support for multiple checks is added

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
        }
        Details        = [ordered] @{
            Area        = ''
            Category    = ''
            Severity    = ''
            Importance  = 0
            Description = ''
            Resolution  = ''
            Resources   = @(

            )
        }
        ExpectedOutput = $true
    }
    Tests  = [ordered] @{
        PasswordLastSet = @{
            Enable      = $true
            Name        = 'Administrator Last Password Change Should be less than 360 days ago'
            Parameters  = @{
                Property      = 'PasswordLastSet'
                ExpectedValue = '(Get-Date).AddDays(-360)'
                OperationType = 'gt'
            }
            Description = 'Administrator account should be disabled or LastPasswordChange should be less than 1 year ago.'
        }
    }
}