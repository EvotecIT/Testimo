$SMBSharesPermissions = @{
    Name   = 'DCSMBSharesPermissions'
    Enable = $true
    Scope  = 'DC'
    Source = @{
        Name           = 'Default SMB Shares Permissions'
        Data           = {
            Get-ComputerSMBSharePermissions -ComputerName $DomainController -ShareName 'Netlogon', 'Sysvol' -Translated
        }
        Details        = [ordered] @{
            Category    = 'Security'
            Description = "SMB Shares for Sysvol and Netlogon should be at their defaults. That means 2 permissions for Netlogon and 3 for SysVol."
            Resolution  = 'Add/Remove unnecessary permissions.'
            Importance  = 3
            Resources   = @(

            )
        }
        Requirements   = @{
            CommandAvailable = 'Get-ComputerSMBSharePermissions'
        }
        ExpectedOutput = $true
    }
    Tests  = [ordered] @{
        OverallCount                  = @{
            Enable     = $true
            Name       = 'Should only have default number of permissions'
            Parameters = @{
                ExpectedCount = 5
            }
            Details    = [ordered] @{
                Category    = 'Security'
                Description = "SMB Shares for Sysvol and Netlogon should be at their defaults. That means 2 permissions for Netlogon and 3 for SysVol."
                Resolution  = 'Add/Remove unnecessary permissions.'
                Importance  = 5
                Resources   = @(

                )
            }
        }
        NetlogonEveryone              = @{
            Enable      = $true
            Name        = 'Netlogon Share Permissions - Everyone'
            Parameters  = @{
                # NETLOGON share should have Everyone with Read access rights
                WhereObject   = { $_.Name -eq 'NETLOGON' -and $_.AccountSID -eq 'S-1-1-0' }
                ExpectedCount = 1
            }
            Category    = 'Security'
            Description = "SMB Shares for NETLOGON should contain Everyone with Read access rights."
            Resolution  = 'Add/Remove unnecessary permissions.'
            Importance  = 5
            Resources   = @(

            )
        }
        NetlogonAdministrators        = @{
            Enable      = $true
            Name        = 'Netlogon Share Permissions - BUILTIN\Administrators'
            Parameters  = @{
                WhereObject   = { $_.Name -eq 'NETLOGON' -and $_.AccountSID -eq 'S-1-5-32-544' }
                ExpectedCount = 1
            }
            Category    = 'Security'
            Description = "SMB Shares for NETLOGON should contain BUILTIN\Administrators with Full access rights."
            Resolution  = 'Add/Remove unnecessary permissions.'
            Importance  = 5
            Resources   = @(

            )
        }
        SysvolEveryone                = @{
            Enable      = $true
            Name        = 'SysVol Share Permissions - Everyone'
            Parameters  = @{
                WhereObject   = { $_.Name -eq 'SYSVOL' -and $_.AccountSID -eq 'S-1-1-0' }
                ExpectedCount = 1
            }
            Category    = 'Security'
            Description = "SMB Shares for SYSVOL should contain Everyone with Read access rights."
            Resolution  = 'Add/Remove unnecessary permissions.'
            Importance  = 5
            Resources   = @(

            )
        }
        SysvolAdministrators          = @{
            Enable      = $true
            Name        = 'SysVol Share Permissions - BUILTIN\Administrators'
            Parameters  = @{
                WhereObject   = { $_.Name -eq 'SYSVOL' -and $_.AccountSID -eq 'S-1-5-32-544' }
                ExpectedCount = 1
            }
            Category    = 'Security'
            Description = "SMB Shares for SYSVOL should contain BUILTIN\Administrators with Full access rights."
            Resolution  = 'Add/Remove unnecessary permissions.'
            Importance  = 5
            Resources   = @(

            )
        }
        SysvolAuthenticatedUsers      = @{
            Enable      = $true
            Name        = 'SysVol Share Permissions - NT AUTHORITY\Authenticated Users'
            Parameters  = @{
                WhereObject   = { $_.Name -eq 'SYSVOL' -and $_.AccountSID -eq 'S-1-5-11' }
                ExpectedCount = 1
            }
            Category    = 'Security'
            Description = "SMB Shares for SYSVOL should contain NT AUTHORITY\Authenticated Users with Full access rights."
            Resolution  = 'Add/Remove unnecessary permissions.'
            Importance  = 5
            Resources   = @(

            )
        }

        NetlogonEveryoneValue         = @{
            Enable      = $true
            Name        = 'Netlogon Share Permissions Value - Everyone'
            Parameters  = @{
                WhereObject   = { $_.Name -eq 'NETLOGON' -and $_.AccountSID -eq 'S-1-1-0' }
                Property      = 'AccessRight'
                ExpectedValue = 'Read'
                OperationType = 'eq'
            }
            Category    = 'Security'
            Description = "SMB Shares for NETLOGON should contain Everyone with Read access rights."
            Resolution  = 'Add/Remove unnecessary permissions.'
            Importance  = 5
            Resources   = @(

            )
        }
        NetlogonAdministratorsValue   = @{
            Enable      = $true
            Name        = 'Netlogon Share Permissions Value - BUILTIN\Administrators'
            Parameters  = @{
                WhereObject   = { $_.Name -eq 'NETLOGON' -and $_.AccountSID -eq 'S-1-5-32-544' }
                Property      = 'AccessRight'
                ExpectedValue = 'Full'
                OperationType = 'eq'
            }
            Category    = 'Security'
            Description = "SMB Shares for NETLOGON should contain BUILTIN\Administrators with Full access rights."
            Resolution  = 'Add/Remove unnecessary permissions.'
            Importance  = 5
            Resources   = @(

            )
        }
        SysvolEveryoneValue           = @{
            Enable      = $true
            Name        = 'SysVol Share Permissions Value - Everyone'
            Parameters  = @{
                WhereObject   = { $_.Name -eq 'SYSVOL' -and $_.AccountSID -eq 'S-1-1-0' }
                Property      = 'AccessRight'
                ExpectedValue = 'Read'
                OperationType = 'eq'
            }
            Category    = 'Security'
            Description = "SMB Shares for SYSVOL should contain Everyone with Read access rights."
            Resolution  = 'Add/Remove unnecessary permissions.'
            Importance  = 5
            Resources   = @(

            )
        }
        SysvolAdministratorsValue     = @{
            Enable      = $true
            Name        = 'SysVol Share Permissions Value - BUILTIN\Administrators'
            Parameters  = @{
                WhereObject   = { $_.Name -eq 'SYSVOL' -and $_.AccountSID -eq 'S-1-5-32-544' }
                Property      = 'AccessRight'
                ExpectedValue = 'Full'
                OperationType = 'eq'
            }
            Category    = 'Security'
            Description = "SMB Shares for SYSVOL should contain BUILTIN\Administrators with Full access rights."
            Resolution  = 'Add/Remove unnecessary permissions.'
            Importance  = 5
            Resources   = @(

            )
        }
        SysvolAuthenticatedUsersValue = @{
            Enable      = $true
            Name        = 'SysVol Share Permissions Value - NT AUTHORITY\Authenticated Users'
            Parameters  = @{
                WhereObject   = { $_.Name -eq 'SYSVOL' -and $_.AccountSID -eq 'S-1-5-11' }
                Property      = 'AccessRight'
                ExpectedValue = 'Full'
                OperationType = 'eq'
            }
            Category    = 'Security'
            Description = "SMB Shares for SYSVOL should contain NT AUTHORITY\Authenticated Users with Full access rights."
            Resolution  = 'Add/Remove unnecessary permissions.'
            Importance  = 5
            Resources   = @(

            )
        }
    }
}
