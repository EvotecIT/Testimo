$KerberosAccountAge = @{
    Enable = $true
    Source = @{
        Name       = "Kerberos Account Age"
        Data       = {
            Get-ADUser -Identity krbtgt -Properties Created, PasswordLastSet, msDS-KeyVersionNumber -Server $Domain
        }
        Details = [ordered] @{
            Area        = 'Security'
            Category    = ''
            Severity    = ''
            RiskLevel   = 0
            Description = ''
            Resolution  = ''
            Resources   = @(

            )
        }
        ExpectedOutput = $true
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
        }
    }
}