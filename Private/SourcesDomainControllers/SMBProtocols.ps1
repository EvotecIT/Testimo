$SMBProtocols = @{
    Enable = $true
    Source = @{
        Name         = 'SMB Protocols'
        Data         = {
            Get-ComputerSMB -ComputerName $DomainController
        }
        Details      = [ordered] @{
            Area        = ''
            Description = ''
            Resolution  = ''
            RiskLevel   = 10
            Resources   = @(
                'https://community.spiceworks.com/topic/2153374-bpa-on-windows-server-2016-warns-about-smb-not-in-a-default-configuration'
            )
        }
        Requirements = @{
            CommandAvailable = 'Get-ComputerSMB'
        }
        ExpectedOutput = $true
    }
    # BPA Recommendations
    Tests  = [ordered] @{
        AsynchronousCredits             = @{
            Enable     = $true
            Name       = 'AsynchronousCredits'
            Parameters = @{
                Property      = 'AsynchronousCredits'
                ExpectedValue = 64
                OperationType = 'eq'
            }
            Details    = [ordered] @{
                Area        = ''
                Description = 'AsynchronousCredits should have the recommended value'
                Resolution  = ''
                RiskLevel   = 10
                Resources   = @(

                )
            }
        }
        AutoDisconnectTimeout           = @{
            Enable     = $true
            Name       = 'AutoDisconnectTimeout'
            Parameters = @{
                Property      = 'AutoDisconnectTimeout'
                ExpectedValue = 0
                OperationType = 'eq'
            }
            Details    = [ordered] @{
                Area        = ''
                Description = 'AutoDisconnectTimeout should have the recommended value'
                Resolution  = ''
                RiskLevel   = 10
                Resources   = @(

                )
            }
        }
        CachedOpenLimit                 = @{
            Enable     = $true
            Name       = 'CachedOpenLimit'
            Parameters = @{
                Property      = 'CachedOpenLimit'
                ExpectedValue = 5
                OperationType = 'eq'
            }
            Details    = [ordered] @{
                Area        = ''
                Description = 'CachedOpenLimit should have the recommended value'
                Resolution  = ''
                RiskLevel   = 10
                Resources   = @(

                )
            }
        }
        DurableHandleV2TimeoutInSeconds = @{
            Enable     = $true
            Name       = 'DurableHandleV2TimeoutInSeconds'
            Parameters = @{
                Property      = 'DurableHandleV2TimeoutInSeconds'
                ExpectedValue = 30
                OperationType = 'eq'
            }
            Details    = [ordered] @{
                Area        = ''
                Description = 'DurableHandleV2TimeoutInSeconds should have the recommended value'
                Resolution  = ''
                RiskLevel   = 10
                Resources   = @(

                )
            }
        }
        EnableSMB1Protocol              = @{
            Enable     = $true
            Name       = 'SMB v1 Protocol should be disabled'
            Parameters = @{
                Property      = 'EnableSMB1Protocol'
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
        EnableSMB2Protocol              = @{
            Enable     = $true
            Name       = 'SMB v2 Protocol should be enabled'
            Parameters = @{
                Property      = 'EnableSMB2Protocol'
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
        MaxThreadsPerQueue              = @{
            Enable     = $true
            Name       = 'MaxThreadsPerQueue'
            Parameters = @{
                Property      = 'MaxThreadsPerQueue'
                ExpectedValue = 20
                OperationType = 'eq'
            }
            Details    = [ordered] @{
                Area        = ''
                Description = 'MaxThreadsPerQueue should have the recommended value'
                Resolution  = ''
                RiskLevel   = 10
                Resources   = @(

                )
            }
        }
        Smb2CreditsMin                  = @{
            Enable     = $true
            Name       = 'Smb2CreditsMin'
            Parameters = @{
                Property      = 'Smb2CreditsMin'
                ExpectedValue = 128
                OperationType = 'eq'
            }
            Details    = [ordered] @{
                Area        = ''
                Description = 'Smb2CreditsMin should have the recommended value'
                Resolution  = ''
                RiskLevel   = 10
                Resources   = @(

                )
            }
        }
        Smb2CreditsMax                  = @{
            Enable     = $true
            Name       = 'Smb2CreditsMax'
            Parameters = @{
                Property      = 'Smb2CreditsMax'
                ExpectedValue = 2048
                OperationType = 'eq'
            }
            Details    = [ordered] @{
                Area        = ''
                Description = 'Smb2CreditsMax should have the recommended value'
                Resolution  = ''
                RiskLevel   = 10
                Resources   = @(
                    'https://github.com/EvotecIT/Testimo/issues/50'
                )
            }
        }
        RequireSecuritySignature        = @{
            Enable     = $true
            Name       = 'SMB v2 Require Security Signature'
            Parameters = @{
                Property      = 'RequireSecuritySignature'
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
    }
}

<#
AnnounceComment                 :
AnnounceServer                  : False
AsynchronousCredits             : 64
AuditSmb1Access                 : False
AutoDisconnectTimeout           : 15
AutoShareServer                 : True
AutoShareWorkstation            : True
CachedOpenLimit                 : 10
DurableHandleV2TimeoutInSeconds : 180
EnableAuthenticateUserSharing   : False
EnableDownlevelTimewarp         : False
EnableForcedLogoff              : True
EnableLeasing                   : True
EnableMultiChannel              : True
EnableOplocks                   : True
EnableSecuritySignature         : False
EnableSMB1Protocol              : False
EnableSMB2Protocol              : True
EnableStrictNameChecking        : True
EncryptData                     : False
IrpStackSize                    : 15
KeepAliveTime                   : 2
MaxChannelPerSession            : 32
MaxMpxCount                     : 50
MaxSessionPerConnection         : 16384
MaxThreadsPerQueue              : 20
MaxWorkItems                    : 1
NullSessionPipes                :
NullSessionShares               :
OplockBreakWait                 : 35
PendingClientTimeoutInSeconds   : 120
RejectUnencryptedAccess         : True
RequireSecuritySignature        : False
ServerHidden                    : True
Smb2CreditsMax                  : 2048
Smb2CreditsMin                  : 128
SmbServerNameHardeningLevel     : 0
TreatHostAsStableStorage        : False
ValidateAliasNotCircular        : True
ValidateShareScope              : True
ValidateShareScopeNotAliased    : True
ValidateTargetName              : True

#>