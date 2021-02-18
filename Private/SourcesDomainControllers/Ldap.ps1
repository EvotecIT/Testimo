$LDAP = @{
    Enable = $true
    Scope  = 'DC'
    Source = @{
        Name           = 'LDAP Connectivity'
        Data           = {
            Test-LDAP -ComputerName $DomainController -WarningAction SilentlyContinue -VerifyCertificate
        }
        Details        = [ordered] @{
            Area        = ''
            Description = ''
            Resolution  = ''
            Importance  = 10
            Resources   = @(

            )
        }
        ExpectedOutput = $true
    }
    Tests  = [ordered] @{
        PortLDAP      = @{
            Enable     = $true
            Name       = 'LDAP Port is Available'

            Parameters = @{
                Property      = 'LDAP'
                ExpectedValue = $true
                OperationType = 'eq'
            }
        }
        PortLDAPS     = @{
            Enable     = $true
            Name       = 'LDAP SSL Port is Available'
            Parameters = @{
                Property      = 'LDAPS'
                ExpectedValue = $true
                OperationType = 'eq'
            }
        }
        PortLDAP_GC   = @{
            Enable     = $true
            Name       = 'LDAP GC Port is Available'
            Parameters = @{
                Property      = 'GlobalCatalogLDAP'
                ExpectedValue = $true
                OperationType = 'eq'
            }
        }
        PortLDAPS_GC  = @{
            Enable     = $true
            Name       = 'LDAP SSL GC Port is Available'
            Parameters = @{
                Property      = 'GlobalCatalogLDAPS'
                ExpectedValue = $true
                OperationType = 'eq'
            }
        }
        BindLDAPS     = @{
            Enable     = $true
            Name       = 'LDAP SSL Bind available'
            Parameters = @{
                Property      = 'LDAPSBind'
                ExpectedValue = $true
                OperationType = 'eq'
            }
        }
        BindLDAPS_GC  = @{
            Enable     = $true
            Name       = 'LDAP SSL GC Bind is Available'
            Parameters = @{
                Property      = 'GlobalCatalogLDAPSBind'
                ExpectedValue = $true
                OperationType = 'eq'
            }
        }
        X509NotBefore = @{
            Enable     = $true
            Name       = 'Not Before Date should be within required range'
            Parameters = @{
                Property      = 'X509NotBefore'
                ExpectedValue = Get-Date
                OperationType = 'lt'
            }
        }
        X509NotAfter  = @{
            Enable     = $true
            Name       = 'Not After Date should bee within required range'
            Parameters = @{
                Property      = 'X509NotAfter'
                ExpectedValue = Get-Date
                OperationType = 'gt'
            }
        }
    }
}