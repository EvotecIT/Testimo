$KerberosAccountAge = @{
    Enable = $true
    Source = @{
        Name       = "Kerberos Account Age"
        Data       = {
            Get-ADUser -Identity krbtgt -Properties Created, PasswordLastSet, msDS-KeyVersionNumber -Server $Domain
        }
        Area       = ''
        Parameters = @{

        }
    }
    Tests  = [ordered] @{
        EnabledAgingEnabled = @{
            Enable      = $true
            Name        = 'Kerberos Last Password Change Should be less than 180 days'
            Parameters  = @{
                Property      = 'PasswordLastSet'
                ExpectedValue = '(Get-Date).AddDays(-180)'
                OperationType = 'gt'
            }
            Explanation = ''
        }
    }
}