$DomainSecurityAdministrator = @{
    Name            = 'DomainSecurityAdministrator'
    Enable          = $true
    Scope           = 'Domain'
    Source          = @{
        Name           = "Security: Administrator (SID-500)"
        Data           = {
            $DomainSID = (Get-ADDomain -Server $Domain).DomainSID
            Get-ADUser -Server $Domain -Identity "$DomainSID-500" -Properties PasswordLastSet,LastLogonDate,servicePrincipalName | Select-Object -Property DistinguishedName, DisplayName, Enabled, PasswordLastSet,LastLogonDate,servicePrincipalName, SID
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
    Tests           = [ordered] @{
        LastLogonDate = @{
            Enable      = $true
            Name        = 'Last Logon Date should not be recent'
            Parameters = @{
                Property              = 'LastLogonDate'
                ExpectedValue         = (Get-Date).AddDays(-60)
                OperationType         = 'lt'
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
            Parameters = @{
                Property              = 'servicePrincipalName'
                ExpectedValue         = $null
                OperationType         = 'eq'
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
    }
}