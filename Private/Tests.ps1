$Script:Tests = [ordered] @{
    Forest            = @{
        Tests = [ordered]  @{
            OptionalFeatures = @{
                Enable      = $true
                ScriptBlock = $Script:SBForestOptionalFeatures
            }
            Replication      = @{
                Enable      = $false
                ScriptBlock = $Script:SBForestReplication
            }
            LastBackup       = @{
                Enable      = $true
                ScriptBlock = $Script:SBForestLastBackup
            }
        }
    }
    Domain            = @{
        Tests = [ordered] @{
            PasswordComplexity = @{
                Enable      = $true
                ScriptBlock = $Script:SBDomainPasswordComplexity
            }
        }
    }
    DomainControllers = @{
        Tests = [ordered] @{
            LDAP = @{
                Enable      = $true
                ScriptBlock = $Script:SBDomainControllersLDAP
            }
        }
    }
}