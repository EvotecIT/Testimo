$PasswordComplexity = @{
    Name   = 'DomainPasswordComplexity'
    Enable = $true
    Scope  = 'Domain'
    Source = @{
        Name           = 'Password Complexity Requirements'
        Data           = {
            Get-ADDefaultDomainPasswordPolicy -Server $Domain
        }
        Details        = [ordered] @{
            Area        = 'Security'
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
        ComplexityEnabled             = @{
            Enable     = $true
            Name       = 'Complexity Enabled'
            Details    = [ordered] @{
                Area        = ''
                Category    = ''
                Severity    = ''
                Importance  = 0
                Description = ''
                Resolution  = ''
                Resources   = @(

                )
            }
            Parameters = @{
                Property      = 'ComplexityEnabled'
                ExpectedValue = $true
                OperationType = 'eq'
            }
        }
        'LockoutDuration'             = @{
            Enable     = $true
            Name       = 'Lockout Duration'
            Parameters = @{
                Property      = 'LockoutDuration'
                ExpectedValue = 30
                OperationType = 'ge'
            }
        }
        'LockoutObservationWindow'    = @{
            Enable     = $true
            Name       = 'Lockout Observation Window'
            Parameters = @{
                #PropertyExtendedValue = 'LockoutObservationWindow'
                Property      = 'LockoutObservationWindow', 'TotalMinutes'
                ExpectedValue = 30
                OperationType = 'ge'
            }
        }
        'LockoutThreshold'            = @{
            Enable     = $true
            Name       = 'Lockout Threshold'
            Parameters = @{
                Property      = 'LockoutThreshold'
                ExpectedValue = 4
                OperationType = 'gt'
            }
        }
        'MaxPasswordAge'              = @{
            Enable     = $true
            Name       = 'Maximum Password Age'
            Parameters = @{
                Property      = 'MaxPasswordAge', 'TotalDays'
                ExpectedValue = 60
                OperationType = 'le'
            }
        }
        'MinPasswordLength'           = @{
            Enable     = $true
            Name       = 'Minimum Password Length'
            Parameters = @{
                Property      = 'MinPasswordLength'
                ExpectedValue = 8
                OperationType = 'gt'
            }
        }
        'MinPasswordAge'              = @{
            Enable     = $true
            Name       = 'Minimum Password Age'
            Parameters = @{
                #PropertyExtendedValue = 'MinPasswordAge', 'TotalDays'
                Property      = 'MinPasswordAge', 'TotalDays'
                ExpectedValue = 1
                OperationType = 'le'
            }
        }
        'PasswordHistoryCount'        = @{
            Enable     = $true
            Name       = 'Password History Count'
            Parameters = @{
                Property      = 'PasswordHistoryCount'
                ExpectedValue = 10
                OperationType = 'ge'
            }
        }
        'ReversibleEncryptionEnabled' = @{
            Enable     = $true
            Name       = 'Reversible Encryption Enabled'
            Parameters = @{
                Property      = 'ReversibleEncryptionEnabled'
                ExpectedValue = $false
                OperationType = 'eq'
            }
        }
    }
}