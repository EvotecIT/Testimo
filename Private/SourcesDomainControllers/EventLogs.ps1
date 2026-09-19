$EventLogs = @{
    Name   = 'DCEventLogs'
    Enable = $true
    Scope  = 'DC'
    Source = @{
        Name           = "Event Logs"
        Data           = {
            Get-TestimoEventLogDetails -MachineName $DomainController
        }
        Details        = [ordered] @{
            Area        = 'EventLogs'
            Category    = 'Health'
            Description = ''
            Resolution  = ''
            Importance  = 10
            Resources   = @(

            )
        }
        ExpectedOutput = $true
    }
    Tests  = [ordered] @{
        ApplicationLogMode                               = @{
            Enable     = $true
            Name       = 'Application Log mode is set to AutoBackup'
            Parameters = @{
                WhereObject   = { $_.LogName -eq 'Application' }
                Property      = 'LogMode'
                ExpectedValue = 'AutoBackup'
                OperationType = 'eq'
            }
        }
        ApplicationLogFull                               = @{
            Enable     = $true
            Name       = 'Application log is not full'
            Parameters = @{
                WhereObject   = { $_.LogName -eq 'Application' }
                Property      = 'IsLogFull'
                ExpectedValue = $false
                OperationType = 'eq'
            }
        }
        PowershellLogMode                                = @{
            Enable     = $true
            Name       = 'PowerShell Log mode is set to AutoBackup'
            Parameters = @{
                WhereObject   = { $_.LogName -eq 'Microsoft-Windows-PowerShell/Operational' }
                Property      = 'LogMode'
                ExpectedValue = 'AutoBackup'
                OperationType = 'eq'
            }
        }
        PowerShellLogFull                                = @{
            Enable     = $true
            Name       = 'PowerShell log is not full'
            Parameters = @{
                WhereObject   = { $_.LogName -eq 'Microsoft-Windows-PowerShell/Operational' }
                Property      = 'IsLogFull'
                ExpectedValue = $false
                OperationType = 'eq'
            }
        }
        SystemLogMode                                    = @{
            Enable     = $true
            Name       = 'System Log mode is set to AutoBackup'
            Parameters = @{
                WhereObject   = { $_.LogName -eq 'System' }
                Property      = 'LogMode'
                ExpectedValue = 'AutoBackup'
                OperationType = 'eq'
            }
        }
        SystemLogFull                                    = @{
            Enable     = $true
            Name       = 'System log is not full'
            Parameters = @{
                WhereObject   = { $_.LogName -eq 'System' }
                Property      = 'IsLogFull'
                ExpectedValue = $false
                OperationType = 'eq'
            }
        }

        SecurityLogMode                                  = @{
            Enable     = $true
            Name       = 'Security Log mode is set to AutoBackup'
            Parameters = @{
                WhereObject   = { $_.LogName -eq 'Security' }
                Property      = 'LogMode'
                ExpectedValue = 'AutoBackup'
                OperationType = 'eq'
            }
        }
        SecurityLogFull                                  = @{
            Enable     = $true
            Name       = 'Security log is not full'
            Parameters = @{
                WhereObject   = { $_.LogName -eq 'Security' }
                Property      = 'IsLogFull'
                ExpectedValue = $false
                OperationType = 'eq'
            }
        }
        SecurityMaximumLogSize                           = @{
            Enable     = $true
            Name       = 'Security Log Maximum Size smaller then 4GB'
            Parameters = @{
                WhereObject   = { $_.LogName -eq 'Security' }
                Property      = 'FileSizeMaximumMB'
                ExpectedValue = 4000
                OperationType = 'le'
            }
        }
        SecurityCurrentLogSize                           = @{
            Enable     = $true
            Name       = 'Security Log Current Size smaller then 4GB'
            Parameters = @{
                WhereObject   = { $_.LogName -eq 'Security' }
                Property      = 'FileSizeCurrentMB'
                ExpectedValue = 4000
                OperationType = 'le'
            }
        }
        SecurityPermissionsDefaultNetworkService         = @{
            Enable     = $false
            Name       = 'Security log DACL includes NETWORK SERVICE read allow rights (legacy opt-in)'
            Parameters = @{
                WhereObject   = { $_.LogName -eq 'Security' -and (Test-TestimoEventLogAllowRights -AccessRules $_.SecurityAccessRules -TrusteeSid 'S-1-5-20' -RequiredRights 1) }
                ExpectedCount = 1
                OperationType = 'eq'
            }
        }
        SecurityPermissionsDefaultSYSTEM                 = @{
            Enable     = $true
            Name       = 'Security log DACL includes SYSTEM read and clear allow rights'
            Parameters = @{
                WhereObject   = { $_.LogName -eq 'Security' -and (Test-TestimoEventLogAllowRights -AccessRules $_.SecurityAccessRules -TrusteeSid 'S-1-5-18' -RequiredRights 5) }
                ExpectedCount = 1
                OperationType = 'eq'
            }
        }
        SecurityPermissionsNDefaultBuiltinAdministrators = @{
            Enable     = $true
            Name       = 'Security log DACL includes Administrators read allow rights'
            Parameters = @{
                WhereObject   = { $_.LogName -eq 'Security' -and (Test-TestimoEventLogAllowRights -AccessRules $_.SecurityAccessRules -TrusteeSid 'S-1-5-32-544' -RequiredRights 1) }
                ExpectedCount = 1
                OperationType = 'eq'
            }
        }
        SecurityPermissionsDefaultBuiltinEventLogReaders = @{
            Enable     = $true
            Name       = 'Security log DACL includes Event Log Readers read allow rights'
            Parameters = @{
                WhereObject   = { $_.LogName -eq 'Security' -and (Test-TestimoEventLogAllowRights -AccessRules $_.SecurityAccessRules -TrusteeSid 'S-1-5-32-573' -RequiredRights 1) }
                ExpectedCount = 1
                OperationType = 'eq'
            }
        }
    }
}
