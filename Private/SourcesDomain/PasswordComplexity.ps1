$PasswordComplexity = @{
    Enable = $true
    Source = @{
        Name    = 'Password Complexity Requirements'
        Data    = {
            # Imports all commands / including private ones from PSWinDocumentation.AD
            #$ADModule = Import-Module PSWinDocumentation.AD -PassThru
            $ADModule = Import-PrivateModule PSWinDocumentation.AD
            & $ADModule { param($Domain); Get-WinADDomainDefaultPasswordPolicy -Domain $Domain } $Domain
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
        ComplexityEnabled             = @{
            Enable     = $true
            Name       = 'Complexity Enabled'
            Details    = [ordered] @{
                Area        = ''
                Category    = ''
                Severity    = ''
                RiskLevel   = 0
                Description = ''
                Resolution  = ''
                Resources   = @(

                )
            }
            Parameters = @{
                Property      = 'Complexity Enabled'
                ExpectedValue = $true
                OperationType = 'eq'
            }
        }
        'LockoutDuration'             = @{
            Enable     = $true
            Name       = 'Lockout Duration'
            Parameters = @{
                Property      = 'Lockout Duration'
                ExpectedValue = 30
                OperationType = 'ge'
            }
        }
        'LockoutObservationWindow'    = @{
            Enable     = $true
            Name       = 'Lockout Observation Window'
            Parameters = @{
                Property      = 'Lockout Observation Window'
                ExpectedValue = 30
                OperationType = 'ge'
            }
        }
        'LockoutThreshold'            = @{
            Enable     = $true
            Name       = 'Lockout Threshold'
            Parameters = @{
                Property      = 'Lockout Threshold'
                ExpectedValue = 4
                OperationType = 'gt'
            }
        }
        'MaxPasswordAge'              = @{
            Enable     = $true
            Name       = 'Max Password Age'
            Parameters = @{
                Property      = 'Max Password Age'
                ExpectedValue = 60
                OperationType = 'le'
            }
        }
        'MinPasswordLength'           = @{
            Enable     = $true
            Name       = 'Min Password Length'
            Parameters = @{
                Property      = 'Min Password Length'
                ExpectedValue = 8
                OperationType = 'gt'
            }
        }
        'MinPasswordAge'              = @{
            Enable     = $true
            Name       = 'Min Password Age'
            Parameters = @{
                Property      = 'Min Password Age'
                ExpectedValue = 1
                OperationType = 'le'
            }
        }
        'PasswordHistoryCount'        = @{
            Enable     = $true
            Name       = 'Password History Count'
            Parameters = @{
                Property      = 'Password History Count'
                ExpectedValue = 10
                OperationType = 'ge'
            }
        }
        'ReversibleEncryptionEnabled' = @{
            Enable     = $true
            Name       = 'Reversible Encryption Enabled'
            Parameters = @{
                Property      = 'Reversible Encryption Enabled'
                ExpectedValue = $false
                OperationType = 'eq'
            }
        }
    }
}