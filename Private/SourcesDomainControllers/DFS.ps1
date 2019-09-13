$DFS = @{
    Enable = $true
    Source = @{
        Name    = "SYSVOL/DFS Verification"
        Data    = {
            Get-WinADDFSHealth -Domains $Domain -DomainControllers $DomainController
        }
        Details = [ordered] @{
            Area        = 'Configuration'
            Category    = 'DFS'
            Severity    = ''
            RiskLevel   = 0
            Description = ""
            Resolution  = ''
            Resources   = @(

            )
        }
    }
    Tests  = [ordered] @{
        Status              = @{
            Enable     = $true
            Name       = 'DFS should be Healthy'
            Parameters = @{
                ExpectedValue = $true
                Property      = 'Status'
                OperationType = 'eq'
            }
        }
        CentralRepository   = @{
            Enable     = $true
            Name       = 'Central Repository for GPO for Domain should be available'
            Parameters = @{
                ExpectedValue = $true
                Property      = 'CentralRepository'
                OperationType = 'eq'
            }
        }
        CentralRepositoryDC = @{
            Enable     = $true
            Name       = 'Central Repository for GPO for DC should be available'
            Parameters = @{
                ExpectedValue = $true
                Property      = 'CentralRepositoryDC'
                OperationType = 'eq'
            }
        }
        IdenticalCount      = @{
            Enable     = $true
            Name       = 'GPO Count should match folder count'
            Parameters = @{
                ExpectedValue = $true
                Property      = 'IdenticalCount'
                OperationType = 'eq'
            }
        }
        MemberReference     = @{
            Enable     = $true
            Name       = 'MemberReference should return TRUE'
            Parameters = @{
                ExpectedValue = $true
                Property      = 'MemberReference'
                OperationType = 'eq'
            }
        }
        DFSErrors           = @{
            Enable     = $true
            Name       = 'DFSErrors should be 0'
            Parameters = @{
                ExpectedValue = 0
                Property      = 'DFSErrors'
                OperationType = 'eq'
            }
        }
        DFSLocalSetting     = @{
            Enable     = $true
            Name       = 'DFSLocalSetting should be TRUE'
            Parameters = @{
                ExpectedValue = $true
                Property      = 'DFSLocalSetting'
                OperationType = 'eq'
            }
        }
        DomainSystemVolume  = @{
            Enable     = $true
            Name       = 'DomainSystemVolume should be TRUE'
            Parameters = @{
                ExpectedValue = $true
                Property      = 'DomainSystemVolume'
                OperationType = 'eq'
            }
        }
        SYSVOLSubscription  = @{
            Enable     = $true
            Name       = 'SYSVOLSubscription should be TRUE'
            Parameters = @{
                ExpectedValue = $true
                Property      = 'SYSVOLSubscription'
                OperationType = 'eq'
            }
        }
        DFSRAutoRecovery    = @{
            Enable     = $true
            Name       = 'DFSR AutoRecovery should be enabled (not stopped)'
            Parameters = @{
                Property      = 'StopReplicationOnAutoRecovery'
                ExpectedValue = $false
                OperationType = 'eq'
            }
            Details    = [ordered] @{
                Area        = ''
                Description = ''
                Resolution  = ''
                RiskLevel   = 10
                Resources   = @(
                    'https://secureinfra.blog/2019/04/30/field-notes-a-quick-tip-on-dfsr-automatic-recovery-while-you-prepare-for-an-ad-domain-upgrade/'
                )
            }
        }
    }
}

<#
DomainController Domain        Status IsPDC GroupPolicyCount SysvolCount CentralRepository CentralRepositoryDC IdenticalCount Availability MemberReference DFSErrors DFSEvents DFSLocalSetting DomainSystemVolume SYSVOLSubscription
---------------- ------        ------ ----- ---------------- ----------- ----------------- ------------------- -------------- ------------ --------------- --------- --------- --------------- ------------------ ------------------
AD2              ad.evotec.xyz  False False               14          12             False               False          False         True            True         0                      True               True               True
AD1              ad.evotec.xyz   True  True               14          14             False               False           True         True            True         0                      True               True               True
AD3              ad.evotec.xyz  False False               14           0             False               False          False         True            True         0                      True               True               True
#>