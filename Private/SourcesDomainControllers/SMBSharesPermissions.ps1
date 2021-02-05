$SMBSharesPermissions = @{
    Enable = $true
    Scope  = 'DC'
    Source = @{
        Name         = 'Default SMB Shares Permissions'
        Data         = {
            Get-ComputerSMBSharePermissions -ComputerName $DomainController -ShareName 'Netlogon', 'Sysvol'
        }
        Details      = [ordered] @{
            Area        = 'Security'
            Description = "SMB Shares for Sysvol and Netlogon should be at their defaults. That means 2 permissions for Netlogon and 3 for SysVol."
            Resolution  = 'Add/Remove unnecessary permissions.'
            Importance   = 20
            Resources   = @(

            )
        }
        Requirements = @{
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
                Area        = 'Security'
                Description = "SMB Shares for Sysvol and Netlogon should be at their defaults. That means 2 permissions for Netlogon and 3 for SysVol."
                Resolution  = 'Add/Remove unnecessary permissions.'
                Importance   = 5
                Resources   = @(

                )
            }
        }
        NetlogonEveryone              = @{
            Enable      = $true
            Name        = 'Netlogon Share Permissions - Everyone'
            Parameters  = @{
                WhereObject   = { $_.Name -eq 'NETLOGON' -and $_.AccountName -eq 'Everyone' }
                ExpectedCount = 1
            }
            Area        = 'Security'
            Description = "SMB Shares for NETLOGON should contain Everyone with Read access rights."
            Resolution  = 'Add/Remove unnecessary permissions.'
            Importance   = 5
            Resources   = @(

            )
        }
        NetlogonAdministrators        = @{
            Enable      = $true
            Name        = 'Netlogon Share Permissions - BUILTIN\Administrators'
            Parameters  = @{
                WhereObject   = { $_.Name -eq 'NETLOGON' -and $_.AccountName -eq 'BUILTIN\Administrators' }
                ExpectedCount = 1
            }
            Area        = 'Security'
            Description = "SMB Shares for NETLOGON should contain BUILTIN\Administrators with Full access rights."
            Resolution  = 'Add/Remove unnecessary permissions.'
            Importance   = 5
            Resources   = @(

            )
        }
        SysvolEveryone                = @{
            Enable      = $true
            Name        = 'SysVol Share Permissions - Everyone'
            Parameters  = @{
                WhereObject   = { $_.Name -eq 'SYSVOL' -and $_.AccountName -eq 'Everyone' }
                ExpectedCount = 1
            }
            Area        = 'Security'
            Description = "SMB Shares for SYSVOL should contain Everyone with Read access rights."
            Resolution  = 'Add/Remove unnecessary permissions.'
            Importance   = 5
            Resources   = @(

            )
        }
        SysvolAdministrators          = @{
            Enable      = $true
            Name        = 'SysVol Share Permissions - BUILTIN\Administrators'
            Parameters  = @{
                WhereObject   = { $_.Name -eq 'SYSVOL' -and $_.AccountName -eq 'BUILTIN\Administrators' }
                ExpectedCount = 1
            }
            Area        = 'Security'
            Description = "SMB Shares for SYSVOL should contain BUILTIN\Administrators with Full access rights."
            Resolution  = 'Add/Remove unnecessary permissions.'
            Importance   = 5
            Resources   = @(

            )
        }
        SysvolAuthenticatedUsers      = @{
            Enable      = $true
            Name        = 'SysVol Share Permissions - NT AUTHORITY\Authenticated Users'
            Parameters  = @{
                WhereObject   = { $_.Name -eq 'SYSVOL' -and $_.AccountName -eq 'NT AUTHORITY\Authenticated Users' }
                ExpectedCount = 1
            }
            Area        = 'Security'
            Description = "SMB Shares for SYSVOL should contain NT AUTHORITY\Authenticated Users with Full access rights."
            Resolution  = 'Add/Remove unnecessary permissions.'
            Importance   = 5
            Resources   = @(

            )
        }

        NetlogonEveryoneValue         = @{
            Enable      = $true
            Name        = 'Netlogon Share Permissions Value - Everyone'
            Parameters  = @{
                WhereObject   = { $_.Name -eq 'NETLOGON' -and $_.AccountName -eq 'Everyone' }
                Property      = 'AccessRight'
                ExpectedValue = 'Read'
                OperationType = 'eq'
            }
            Area        = 'Security'
            Description = "SMB Shares for NETLOGON should contain Everyone with Read access rights."
            Resolution  = 'Add/Remove unnecessary permissions.'
            Importance   = 5
            Resources   = @(

            )
        }
        NetlogonAdministratorsValue   = @{
            Enable      = $true
            Name        = 'Netlogon Share Permissions Value - BUILTIN\Administrators'
            Parameters  = @{
                WhereObject   = { $_.Name -eq 'NETLOGON' -and $_.AccountName -eq 'BUILTIN\Administrators' }
                Property      = 'AccessRight'
                ExpectedValue = 'Full'
                OperationType = 'eq'
            }
            Area        = 'Security'
            Description = "SMB Shares for NETLOGON should contain BUILTIN\Administrators with Full access rights."
            Resolution  = 'Add/Remove unnecessary permissions.'
            Importance   = 5
            Resources   = @(

            )
        }
        SysvolEveryoneValue           = @{
            Enable      = $true
            Name        = 'SysVol Share Permissions Value - Everyone'
            Parameters  = @{
                WhereObject   = { $_.Name -eq 'SYSVOL' -and $_.AccountName -eq 'Everyone' }
                Property      = 'AccessRight'
                ExpectedValue = 'Read'
                OperationType = 'eq'
            }
            Area        = 'Security'
            Description = "SMB Shares for SYSVOL should contain Everyone with Read access rights."
            Resolution  = 'Add/Remove unnecessary permissions.'
            Importance   = 5
            Resources   = @(

            )
        }
        SysvolAdministratorsValue     = @{
            Enable      = $true
            Name        = 'SysVol Share Permissions Value - BUILTIN\Administrators'
            Parameters  = @{
                WhereObject   = { $_.Name -eq 'SYSVOL' -and $_.AccountName -eq 'BUILTIN\Administrators' }
                Property      = 'AccessRight'
                ExpectedValue = 'Full'
                OperationType = 'eq'
            }
            Area        = 'Security'
            Description = "SMB Shares for SYSVOL should contain BUILTIN\Administrators with Full access rights."
            Resolution  = 'Add/Remove unnecessary permissions.'
            Importance   = 5
            Resources   = @(

            )
        }
        SysvolAuthenticatedUsersValue = @{
            Enable      = $true
            Name        = 'SysVol Share Permissions Value - NT AUTHORITY\Authenticated Users'
            Parameters  = @{
                WhereObject   = { $_.Name -eq 'SYSVOL' -and $_.AccountName -eq 'NT AUTHORITY\Authenticated Users' }
                Property      = 'AccessRight'
                ExpectedValue = 'Full'
                OperationType = 'eq'
            }
            Area        = 'Security'
            Description = "SMB Shares for SYSVOL should contain NT AUTHORITY\Authenticated Users with Full access rights."
            Resolution  = 'Add/Remove unnecessary permissions.'
            Importance   = 5
            Resources   = @(

            )
        }
    }
}
