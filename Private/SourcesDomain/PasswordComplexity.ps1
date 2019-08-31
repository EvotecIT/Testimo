$PasswordComplexity = @{
    Enable = $false
    Source = @{
        Name       = 'Password Complexity Requirements'
        Data       = {
            # Imports all commands / including private ones from PSWinDocumentation.AD
            $ADModule = Import-Module PSWinDocumentation.AD -PassThru
            & $ADModule { param($Domain); Get-WinADDomainDefaultPasswordPolicy -Domain $Domain } $Domain
        }
    }
    Tests  = [ordered] @{
        ComplexityEnabled               = @{
            Enable     = $true
            Name       = 'Complexity Enabled'
            Parameters = @{
                Property      = 'Complexity Enabled'
                ExpectedValue = $true
                OperationType = 'eq'
            }
        }
        'Lockout Duration'              = @{
            Enable     = $true
            Name       = 'Lockout Duration'
            Parameters = @{
                Property      = 'Lockout Duration'
                ExpectedValue = 30
                OperationType = 'ge'
            }
        }
        'Lockout Observation Window'    = @{
            Enable     = $true
            Name       = 'Lockout Observation Window'
            Parameters = @{
                Property      = 'Lockout Observation Window'
                ExpectedValue = 30
                OperationType = 'ge'
            }
        }
        'Lockout Threshold'             = @{
            Enable     = $true
            Name       = 'Lockout Threshold'
            Parameters = @{
                Property      = 'Lockout Threshold'
                ExpectedValue = 5
                OperationType = 'gt'
            }
        }
        'Max Password Age'              = @{
            Enable     = $true
            Name       = 'Max Password Age'
            Parameters = @{
                Property      = 'Max Password Age'
                ExpectedValue = 60
                OperationType = 'le'
            }
        }
        'Min Password Length'           = @{
            Enable     = $true
            Name       = 'Min Password Length'
            Parameters = @{
                Property      = 'Min Password Length'
                ExpectedValue = 8
                OperationType = 'gt'
            }
        }
        'Min Password Age'              = @{
            Enable     = $true
            Name       = 'Min Password Age'
            Parameters = @{
                Property      = 'Min Password Age'
                ExpectedValue = 1
                OperationType = 'le'
            }
        }
        'Password History Count'        = @{
            Enable     = $true
            Name       = 'Password History Count'
            Parameters = @{
                Property      = 'Password History Count'
                ExpectedValue = 10
                OperationType = 'ge'
            }
        }
        'Reversible Encryption Enabled' = @{
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