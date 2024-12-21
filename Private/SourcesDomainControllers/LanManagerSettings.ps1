$LanManagerSettings = @{
    Name   = 'DCLanManagerSettings'
    Enable = $true
    Scope  = 'DC'
    Source = @{
        Name           = "Lan Manager Settings"
        Data           = {
            Get-WinADLMSettings -DomainController $DomainController
        }
        Details        = [ordered] @{
            Category    = 'Security'
            Area        = 'System'
            Description = 'Lan Manager Settings are a set of settings that can be configured to enhance the security of the system. '
            Resolution  = ''
            Importance  = 10
            Resources   = @(
                'https://adsecurity.org/?p=3377'
            )
        }
        Requirements   = @{
            CommandAvailable = 'Get-WinADLMSettings'
        }
        ExpectedOutput = $true
    }
    Tests  = [ordered] @{
        Level                     = @{
            Enable     = $true
            Name       = 'LM Level'
            Parameters = @{
                Property      = 'Level'
                ExpectedValue = 5
                OperationType = 'eq'
            }
            Details    = [ordered] @{
                Category    = 'Security'
                Area        = ''
                Description = ''
                Resolution  = ''
                Importance  = 10
                Resources   = @(

                )
            }
        }
        AuditBaseObjects          = @{
            Enable     = $true
            Name       = 'Audit Base Objects'
            Parameters = @{
                Property      = 'AuditBaseObjects'
                ExpectedValue = $false
                OperationType = 'eq'
            }
            Details    = [ordered] @{
                Category    = 'Security'
                Area        = ''
                Description = ''
                Resolution  = ''
                Importance  = 10
                Resources   = @(
                    'https://docs.microsoft.com/en-us/openspecs/windows_protocols/ms-gpac/262a2bed-93d4-4c04-abec-cf06e9ec72fd'
                )
            }
        }
        CrashOnAuditFail          = @{
            Enable     = $true
            Name       = 'Crash On Audit Fail'
            Parameters = @{
                Property      = 'CrashOnAuditFail'
                ExpectedValue = 0
                OperationType = 'eq'
            }
            Details    = [ordered] @{
                Category    = 'Security'
                Area        = ''
                Description = ''
                Resolution  = ''
                Importance  = 10
                Resources   = @(
                    'http://systemmanager.ru/win2k_regestry.en/46686.htm'
                )
            }
        }
        EveryoneIncludesAnonymous = @{
            Enable     = $true
            Name       = 'Everyone Includes Anonymous'
            Parameters = @{
                Property      = 'EveryoneIncludesAnonymous'
                ExpectedValue = $false
                OperationType = 'eq'
            }
            Details    = [ordered] @{
                Category    = 'Security'
                Title       = 'Disable and Enforce the Setting "Network access: Let Everyone permissions apply to anonymous users"'
                Area        = ''
                Description = 'This setting helps to prevent an unauthorized user could from anonymously listing account names and shared resources and use using the information to attempt to guess passwords, perform social engineering attacks, or launch DoS attacks.'
                Resolution  = ''
                Importance  = 10
                Resources   = @(
                    'https://www.stigviewer.com/stig/windows_7/2014-04-02/finding/V-3377'
                )
            }
        }
        SecureBoot                = @{
            Enable     = $true
            Name       = 'Secure Boot'
            Parameters = @{
                Property      = 'SecureBoot'
                ExpectedValue = $true
                OperationType = 'eq'
            }
            Details    = [ordered] @{
                Category    = 'Security'
                Area        = ''
                Description = ''
                Resolution  = ''
                Importance  = 10
                Resources   = @(

                )
            }
        }
        LSAProtectionCredentials  = @{
            Enable     = $true
            Name       = 'LSAProtectionCredentials'
            Parameters = @{
                Property      = 'LSAProtectionCredentials'
                ExpectedValue = $true
                OperationType = 'eq'
            }
            Details    = [ordered] @{
                Category    = 'Security'
                Area        = ''
                Description = ''
                Resolution  = ''
                Importance  = 10
                Resources   = @(

                )
            }
        }
        LimitBlankPasswordUse     = @{
            Enable     = $true
            Name       = 'LimitBlankPasswordUse'
            Parameters = @{
                Property      = 'LimitBlankPasswordUse'
                ExpectedValue = $true
                OperationType = 'eq'
            }
            Details    = [ordered] @{
                Category    = 'Security'
                Area        = ''
                Description = ''
                Resolution  = ''
                Importance  = 10
                Resources   = @(

                )
            }
        }
        NoLmHash                  = @{
            Enable     = $true
            Name       = 'NoLmHash'
            Parameters = @{
                Property      = 'NoLmHash'
                ExpectedValue = $true
                OperationType = 'eq'
            }
            Details    = [ordered] @{
                Category    = 'Security'
                Area        = ''
                Description = ''
                Resolution  = ''
                Importance  = 10
                Resources   = @(

                )
            }
        }
        DisableDomainCreds        = @{
            Enable     = $true
            Name       = 'DisableDomainCreds'
            Parameters = @{
                Property      = 'DisableDomainCreds'
                ExpectedValue = $false
                OperationType = 'eq'
            }
            Details    = [ordered] @{
                Category    = 'Security'
                Area        = ''
                Description = ''
                Resolution  = ''
                Importance  = 10
                Resources   = @(
                    'https://www.stigviewer.com/stig/windows_8/2014-01-07/finding/V-3376'
                )
            }
        }
        ForceGuest                = @{
            Enable     = $true
            Name       = 'ForceGuest'
            Parameters = @{
                Property      = 'ForceGuest'
                ExpectedValue = $false
                OperationType = 'eq'
            }
            Details    = [ordered] @{
                Category    = 'Security'
                Area        = ''
                Description = ''
                Resolution  = ''
                Importance  = 10
                Resources   = @(

                )
            }
        }
        DsrmAdminLogonBehavior    = @{
            Enable     = $true
            Name       = 'DsrmAdminLogonBehavior'
            Parameters = @{
                Property        = 'DsrmAdminLogonBehavior'
                ExpectedValue   = @($null, 0)
                OperationType   = 'in'
                OperationResult = 'OR'
                ExpectedOutput  = $false
            }
            Details    = [ordered] @{
                Category    = 'Security'
                Area        = 'Recovery'
                Description = "Windows Server 2008 has introduced the possibility to change the DSRM logon behavior, which means now you could be able to logon using the local administrator DSRM account into a DC, without the need to reboot into DSRM. This is a security risk, as the DSRM account is a privileged account and should be used only when the DC is in DSRM mode. This setting should be set to 0 or not configured, to prevent this behavior."
                Resolution  = 'Remove this setting from registry or set it to 0.'
                Importance  = 10
                StatusTrue  = 1
                StatusFalse = 5
                Resources   = @(
                    'https://www.sentinelone.com/blog/detecting-dsrm-account-misconfigurations/'
                    'https://renanrodrigues.com/the-ultimate-guide-what-is-dsrm-in-active-directory/'
                    'https://adsecurity.org/?p=1785'
                )
            }
        }
    }
}