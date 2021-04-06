$LDAP = @{
    Enable = $false
    Scope  = 'DC'
    Source = @{
        Name           = 'LDAP Connectivity'
        Data           = {
            Test-LDAP -ComputerName $DomainController -WarningAction SilentlyContinue -VerifyCertificate
        }
        Details        = [ordered] @{
            Category    = 'Health'
            Description = ''
            Resolution  = ''
            Importance  = 0
            ActionType  = 0
            Resources   = @(

            )
        }
        ExpectedOutput = $true
    }
    Tests  = [ordered] @{
        PortLDAP                 = @{
            Enable     = $true
            Name       = 'LDAP Port is Available'

            Parameters = @{
                Property      = 'LDAP'
                ExpectedValue = $true
                OperationType = 'eq'
            }
            Details    = [ordered] @{
                Category   = 'Health'
                Importance = 10
                ActionType = 2
            }
        }
        PortLDAPS                = @{
            Enable     = $true
            Name       = 'LDAP SSL Port is Available'
            Parameters = @{
                Property      = 'LDAPS'
                ExpectedValue = $true
                OperationType = 'eq'
            }
            Details    = [ordered] @{
                Category   = 'Health'
                Importance = 10
                ActionType = 2
            }
        }
        PortLDAP_GC              = @{
            Enable     = $true
            Name       = 'LDAP GC Port is Available'
            Parameters = @{
                Property      = 'GlobalCatalogLDAP'
                ExpectedValue = $true
                OperationType = 'eq'
            }
            Details    = [ordered] @{
                Category   = 'Health'
                Importance = 10
                ActionType = 2
            }
        }
        PortLDAPS_GC             = @{
            Enable     = $true
            Name       = 'LDAP SSL GC Port is Available'
            Parameters = @{
                Property      = 'GlobalCatalogLDAPS'
                ExpectedValue = $true
                OperationType = 'eq'
            }
            Details    = [ordered] @{
                Category   = 'Health'
                Importance = 10
                ActionType = 2
            }
        }
        BindLDAPS                = @{
            Enable     = $true
            Name       = 'LDAP SSL Bind available'
            Parameters = @{
                Property      = 'LDAPSBind'
                ExpectedValue = $true
                OperationType = 'eq'
            }
            Details    = [ordered] @{
                Category   = 'Health'
                Importance = 10
                ActionType = 2
            }
        }
        BindLDAPS_GC             = @{
            Enable     = $true
            Name       = 'LDAP SSL GC Bind is Available'
            Parameters = @{
                Property      = 'GlobalCatalogLDAPSBind'
                ExpectedValue = $true
                OperationType = 'eq'
            }
            Details    = [ordered] @{
                Category   = 'Health'
                Importance = 10
                ActionType = 2
            }
        }
        X509NotBefore            = @{
            Enable     = $true
            Name       = 'Not Before Date should be within required range'
            Parameters = @{
                Property      = 'X509NotBefore'
                ExpectedValue = Get-Date
                OperationType = 'lt'
            }
            Details    = [ordered] @{
                Category   = 'Health'
                Importance = 0
                ActionType = 0
            }
        }
        X509NotAfter             = @{
            Enable     = $true
            Name       = 'Not After Date should be within required range'
            Parameters = @{
                Property      = 'X509NotAfter'
                ExpectedValue = Get-Date
                OperationType = 'gt'
            }
            Details    = [ordered] @{
                Category   = 'Health'
                Importance = 0
                ActionType = 0
            }
        }
        X509NotBeforeDays        = @{
            Enable     = $true
            Name       = 'Not Before Days should be less/equal 0'
            Parameters = @{
                Property      = 'X509NotBeforeDays'
                ExpectedValue = 0
                OperationType = 'le'
            }
            Details    = [ordered] @{
                Category   = 'Health'
                Importance = 10
                ActionType = 2
            }
        }
        X509NotAfterDaysWarning  = @{
            Enable     = $true
            Name       = 'Not After Days should be more than 10 days'
            Parameters = @{
                Property      = 'X509NotAfterDays'
                ExpectedValue = 10
                OperationType = 'gt'
            }
            Details    = [ordered] @{
                Category   = 'Health'
                Importance = 10
                ActionType = 1
            }
        }
        X509NotAfterDaysCritical = @{
            Enable     = $true
            Name       = 'Not After Days should be more than 0 days'
            Parameters = @{
                Property      = 'X509NotAfterDays'
                ExpectedValue = 0
                OperationType = 'gt'
            }
            Details    = [ordered] @{
                Category   = 'Health'
                Importance = 10
                ActionType = 2
            }
        }
    }
}