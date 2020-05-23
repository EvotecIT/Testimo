$DFS = @{
    Enable = $true
    Source = @{
        Name           = "SYSVOL/DFS Verification"
        Data           = {
            Get-WinADDFSHealth -Domains $Domain -DomainControllers $DomainController
        }
        Parameters     = @{
            EventDays = 3
        }
        Details        = [ordered] @{
            Area        = 'Health'
            Category    = 'DFS'
            Severity    = 'High'
            RiskLevel   = 0
            Description = "Provides health verification of SYSVOL/DFS on Domain Controller."
            Resolution  = ''
            Resources   = @(
                'https://support.microsoft.com/en-us/help/2218556/how-to-force-an-authoritative-and-non-authoritative-synchronization-fo'
                'https://www.itprotoday.com/windows-78/fixing-broken-sysvol-replication'
                'https://www.brisk-it.net/when-dfs-replication-goes-wrong-and-how-to-fix-it/'
                'https://gallery.technet.microsoft.com/scriptcenter/AD-DFS-Replication-Auto-812a88bc'
                'https://www.reddit.com/r/sysadmin/comments/7gey4k/resuming_dfs_replication_after_4_years_of_no/'
                'https://kimconnect.com/fix-dfs-replication-problems/'
                'https://community.spiceworks.com/topic/2205945-repairing-broken-dfs-replication'

                'https://support.microsoft.com/en-us/help/2958414/dfs-replication-how-to-troubleshoot-missing-sysvol-and-netlogon-shares'
                'https://noobient.com/2013/11/11/fixing-sysvol-replication-on-windows-server-2012/'

                # personal favourite to fix DFSR issues
                'https://jackstromberg.com/2014/07/sysvol-and-group-policy-out-of-sync-on-server-2012-r2-dcs-using-dfsr/'
            )
        }
        ExpectedOutput = $true
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
        ReplicationState    = @{
            Enable     = $true
            Name       = 'Replication State should be NORMAL'
            Parameters = @{
                ExpectedValue = 'Normal'
                Property      = 'ReplicationState'
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
                    'https://richardjgreen.net/active-directory-dfs-r-auto-recovery/'
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