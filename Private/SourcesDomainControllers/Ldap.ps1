$LDAP = @{
    Enable = $true
    Source = @{
        Name       = 'LDAP Connectivity'
        Data       = {
            Test-LDAP -ComputerName $DomainController -WarningAction SilentlyContinue
        }
        Details = [ordered] @{
            Area             = ''
            Description      = ''
            Resolution   = ''
            RiskLevel        = 10
            Resources = @(

            )
        }
        ExpectedOutput = $true
    }
    Tests  = [ordered] @{
        PortLDAP     = @{
            Enable     = $true
            Name       = 'LDAP Port is Available'

            Parameters = @{
                Property      = 'LDAP'
                ExpectedValue = $true
                OperationType = 'eq'
            }
        }
        PortLDAPS    = @{
            Enable     = $true
            Name       = 'LDAP SSL Port is Available'
            Parameters = @{
                Property      = 'LDAPS'
                ExpectedValue = $true
                OperationType = 'eq'
            }
        }
        PortLDAP_GC  = @{
            Enable     = $true
            Name       = 'LDAP GC Port is Available'
            Parameters = @{
                Property      = 'GlobalCatalogLDAP'
                ExpectedValue = $true
                OperationType = 'eq'
            }
        }
        PortLDAPS_GC = @{
            Enable     = $true
            Name       = 'LDAP SSL GC Port is Available'
            Parameters = @{
                Property      = 'GlobalCatalogLDAPS'
                ExpectedValue = $true
                OperationType = 'eq'
            }
        }
    }
}