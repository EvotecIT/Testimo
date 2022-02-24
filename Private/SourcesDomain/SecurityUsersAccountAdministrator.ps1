$SecurityUsersAcccountAdministrator = @{
    Name   = 'DomainSecurityUsersAcccountAdministrator'
    Enable = $true
    Scope  = 'Domain'
    Source = @{
        Name           = "Users: Administrator (SID-500)"
        Data           = {
            # this test is kind of special
            # basically when account is disabled it doesn't make sense to check for PasswordLastSet
            # therefore i'm adding setting PasswordLastSet to current date to be able to test just that field
            # At least until support for multiple checks is added

            $DomainSID = (Get-ADDomain -Server $Domain).DomainSID
            $User = Get-ADUser -Identity "$DomainSID-500" -Properties PasswordLastSet, LastLogonDate, servicePrincipalName -Server $Domain
            if ($User.Enabled -eq $false) {
                [PSCustomObject] @{
                    Name                 = $User.SamAccountName
                    Enabled              = $User.Enabled
                    PasswordLastSet      = Get-Date
                    ServicePrincipalName = $User.ServicePrincipalName
                    LastLogonDate        = $User.LastLogonDate
                    DistinguishedName    = $User.DistinguishedName
                    SID                  = $User.SID
                }
            } else {
                [PSCustomObject] @{
                    Name                 = $User.SamAccountName
                    Enabled              = $User.Enabled
                    PasswordLastSet      = $User.PasswordLastSet
                    ServicePrincipalName = $User.ServicePrincipalName
                    LastLogonDate        = $User.LastLogonDate
                    DistinguishedName    = $User.DistinguishedName
                    SID                  = $User.SID
                }
            }
        }
        Details        = [ordered] @{
            Category    = 'Security'
            Importance  = 0
            ActionType  = 0
            Description = "Administrator (SID-500) account is critical account in Active Directory. Due to it's role it shouldn't be used as a daily driver, and only as emeregency account."
            Resources   = @(

            )
            StatusTrue  = 0
            StatusFalse = 0
        }
        ExpectedOutput = $true
    }
    Tests  = [ordered] @{
        LastLogonDate        = @{
            Enable      = $true
            Name        = 'Last Logon Date should not be recent'
            Parameters  = @{
                Property      = 'LastLogonDate'
                ExpectedValue = (Get-Date).AddDays(-60)
                OperationType = 'lt'
            }
            Details     = [ordered] @{
                Category    = 'Security'
                Importance  = 9
                ActionType  = 2
                StatusTrue  = 1
                StatusFalse = 5
            }
            Description = ""
        }
        ServicePrincipalName = @{
            Enable      = $true
            Name        = 'Service Principal Name should be empty'
            Parameters  = @{
                Property      = 'servicePrincipalName'
                ExpectedValue = $null
                OperationType = 'eq'
            }
            Details     = [ordered] @{
                Category    = 'Security'
                Importance  = 10
                ActionType  = 2
                StatusTrue  = 1
                StatusFalse = 5
            }
            Description = ""
        }
        PasswordLastSet      = @{
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