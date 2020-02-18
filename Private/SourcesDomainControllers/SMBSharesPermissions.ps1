$SMBSharesPermissions = @{
    Enable = $true
    Source = @{
        Name         = 'Default SMB Shares Permissions'
        Data         = {
            Get-ComputerSMBSharePermissions -ComputerName $DomainController -ShareName 'Netlogon', 'Sysvol'
        }
        Details      = [ordered] @{
            Area        = ''
            Description = ''
            Resolution  = ''
            RiskLevel   = 10
            Resources   = @(

            )
        }
        Requirements = @{
            CommandAvailable = 'Get-ComputerSMBSharePermissions'
        }
    }
    Tests  = [ordered] @{
        OverallCount                  = @{
            Enable     = $true
            Name       = 'Should only have default number of permissions'
            Parameters = @{
                ExpectedCount = 5
            }
        }
        NetlogonEveryone              = @{
            Enable     = $true
            Name       = 'Netlogon Share Permissions - Everyone'
            Parameters = @{
                WhereObject   = { $_.Name -eq 'NETLOGON' -and $_.AccountName -eq 'Everyone' }
                ExpectedCount = 1
            }
        }
        NetlogonAdministrators        = @{
            Enable     = $true
            Name       = 'Netlogon Share Permissions - BUILTIN\Administrators'
            Parameters = @{
                WhereObject   = { $_.Name -eq 'NETLOGON' -and $_.AccountName -eq 'BUILTIN\Administrators' }
                ExpectedCount = 1
            }
        }
        SysvolEveryone                = @{
            Enable     = $true
            Name       = 'SysVol Share Permissions - Everyone'
            Parameters = @{
                WhereObject   = { $_.Name -eq 'SYSVOL' -and $_.AccountName -eq 'Everyone' }
                ExpectedCount = 1
            }
        }
        SysvolAdministrators          = @{
            Enable     = $true
            Name       = 'SysVol Share Permissions - BUILTIN\Administrators'
            Parameters = @{
                WhereObject   = { $_.Name -eq 'SYSVOL' -and $_.AccountName -eq 'BUILTIN\Administrators' }
                ExpectedCount = 1
            }
        }
        SysvolAuthenticatedUsers      = @{
            Enable     = $true
            Name       = 'SysVol Share Permissions - NT AUTHORITY\Authenticated Users'
            Parameters = @{
                WhereObject   = { $_.Name -eq 'SYSVOL' -and $_.AccountName -eq 'NT AUTHORITY\Authenticated Users' }
                ExpectedCount = 1
            }
        }

        NetlogonEveryoneValue         = @{
            Enable     = $true
            Name       = 'Netlogon Share Permissions Value - Everyone'
            Parameters = @{
                WhereObject   = { $_.Name -eq 'NETLOGON' -and $_.AccountName -eq 'Everyone' }
                Property      = 'AccessRight'
                ExpectedValue = 'Read'
                OperationType = 'eq'
            }
        }
        NetlogonAdministratorsValue   = @{
            Enable     = $true
            Name       = 'Netlogon Share Permissions Value - BUILTIN\Administrators'
            Parameters = @{
                WhereObject   = { $_.Name -eq 'NETLOGON' -and $_.AccountName -eq 'BUILTIN\Administrators' }
                Property      = 'AccessRight'
                ExpectedValue = 'Full'
                OperationType = 'eq'
            }
        }
        SysvolEveryoneValue           = @{
            Enable     = $true
            Name       = 'SysVol Share Permissions Value - Everyone'
            Parameters = @{
                WhereObject   = { $_.Name -eq 'SYSVOL' -and $_.AccountName -eq 'Everyone' }
                Property      = 'AccessRight'
                ExpectedValue = 'Read'
                OperationType = 'eq'
            }
        }
        SysvolAdministratorsValue     = @{
            Enable     = $true
            Name       = 'SysVol Share Permissions Value - BUILTIN\Administrators'
            Parameters = @{
                WhereObject   = { $_.Name -eq 'SYSVOL' -and $_.AccountName -eq 'BUILTIN\Administrators' }
                Property      = 'AccessRight'
                ExpectedValue = 'Full'
                OperationType = 'eq'
            }
        }
        SysvolAuthenticatedUsersValue = @{
            Enable     = $true
            Name       = 'SysVol Share Permissions Value - NT AUTHORITY\Authenticated Users'
            Parameters = @{
                WhereObject   = { $_.Name -eq 'SYSVOL' -and $_.AccountName -eq 'NT AUTHORITY\Authenticated Users' }
                Property      = 'AccessRight'
                ExpectedValue = 'Full'
                OperationType = 'eq'
            }
        }
    }
}