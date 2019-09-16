$LanManagerSettings = @{
    Enable = $true
    Source = @{
        Name           = "Lan Manager Settings"
        Data           = {
            Get-WinADLMSettings -DomainController $DomainController
        }
        Details        = [ordered] @{
            Area        = ''
            Description = ''
            Resolution  = ''
            RiskLevel   = 10
            Resources   = @(
                'https://adsecurity.org/?p=3377'
            )
        }
        ExpectedOutput = $true
    }
    Tests  = [ordered] @{
        Level                    = @{
            Enable     = $true
            Name       = 'LM Level'
            Parameters = @{
                Property      = 'Level'
                ExpectedValue = 5
                OperationType = 'eq'
            }
            Details    = [ordered] @{
                Area        = ''
                Description = ''
                Resolution  = ''
                RiskLevel   = 10
                Resources   = @(

                )
            }
        }
        AuditBaseObjects         = @{
            Enable     = $true
            Name       = 'Audit Base Objects'
            Parameters = @{
                Property      = 'AuditBaseObjects'
                ExpectedValue = $false
                OperationType = 'eq'
            }
            Details    = [ordered] @{
                Area        = ''
                Description = ''
                Resolution  = ''
                RiskLevel   = 10
                Resources   = @(
                    'https://docs.microsoft.com/en-us/openspecs/windows_protocols/ms-gpac/262a2bed-93d4-4c04-abec-cf06e9ec72fd'
                )
            }
        }
        CrashOnAuditFail         = @{
            Enable     = $true
            Name       = 'Crash On Audit Fail'
            Parameters = @{
                Property      = 'CrashOnAuditFail'
                ExpectedValue = 0
                OperationType = 'eq'
            }
            Details    = [ordered] @{
                Area        = ''
                Description = ''
                Resolution  = ''
                RiskLevel   = 10
                Resources   = @(
                    'http://systemmanager.ru/win2k_regestry.en/46686.htm'
                )
            }
        }
        SecureBoot               = @{
            Enable     = $true
            Name       = 'Secure Boot'
            Parameters = @{
                Property      = 'SecureBoot'
                ExpectedValue = $true
                OperationType = 'eq'
            }
            Details    = [ordered] @{
                Area        = ''
                Description = ''
                Resolution  = ''
                RiskLevel   = 10
                Resources   = @(

                )
            }
        }
        LSAProtectionCredentials = @{
            Enable     = $true
            Name       = 'LSAProtectionCredentials'
            Parameters = @{
                Property      = 'LSAProtectionCredentials'
                ExpectedValue = $true
                OperationType = 'eq'
            }
            Details    = [ordered] @{
                Area        = ''
                Description = ''
                Resolution  = ''
                RiskLevel   = 10
                Resources   = @(

                )
            }
        }
        LimitBlankPasswordUse    = @{
            Enable     = $true
            Name       = 'LimitBlankPasswordUse'
            Parameters = @{
                Property      = 'LimitBlankPasswordUse'
                ExpectedValue = $true
                OperationType = 'eq'
            }
            Details    = [ordered] @{
                Area        = ''
                Description = ''
                Resolution  = ''
                RiskLevel   = 10
                Resources   = @(

                )
            }
        }
        NoLmHash                 = @{
            Enable     = $true
            Name       = 'NoLmHash'
            Parameters = @{
                Property      = 'NoLmHash'
                ExpectedValue = $true
                OperationType = 'eq'
            }
            Details    = [ordered] @{
                Area        = ''
                Description = ''
                Resolution  = ''
                RiskLevel   = 10
                Resources   = @(

                )
            }
        }
        DisableDomainCreds       = @{
            Enable     = $true
            Name       = 'DisableDomainCreds'
            Parameters = @{
                Property      = 'DisableDomainCreds'
                ExpectedValue = $false
                OperationType = 'eq'
            }
            Details    = [ordered] @{
                Area        = ''
                Description = ''
                Resolution  = ''
                RiskLevel   = 10
                Resources   = @(
                    'https://www.stigviewer.com/stig/windows_8/2014-01-07/finding/V-3376'
                )
            }
        }
        ForceGuest               = @{
            Enable     = $true
            Name       = 'ForceGuest'
            Parameters = @{
                Property      = 'ForceGuest'
                ExpectedValue = $false
                OperationType = 'eq'
            }
            Details    = [ordered] @{
                Area        = ''
                Description = ''
                Resolution  = ''
                RiskLevel   = 10
                Resources   = @(

                )
            }
        }
    }
}




Get-WinADLMSettings -DomainController AD1