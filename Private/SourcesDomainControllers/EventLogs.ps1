$EventLogs = @{
    Enable = $true
    Scope  = 'DC'
    Source = @{
        Name    = "Event Logs"
        Data    = {
            Get-EventsInformation -LogName 'Application', 'System', 'Security', 'Microsoft-Windows-PowerShell/Operational' -Machine $DomainController -WarningAction SilentlyContinue
        }
        Details = [ordered] @{
            Area        = ''
            Description = ''
            Resolution  = ''
            Importance   = 10
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
            Enable     = $true
            Name       = 'Security Log has NT AUTHORITY\NETWORK SERVICE with AccessAllowed'
            Parameters = @{
                WhereObject   = { $_.LogName -eq 'Security' -and $_.SecurityDescriptorDiscretionaryAcl -contains 'NT AUTHORITY\NETWORK SERVICE: AccessAllowed (ListDirectory)' }
                ExpectedCount = 1
                OperationType = 'eq'
            }
        }
        SecurityPermissionsDefaultSYSTEM                 = @{
            Enable     = $true
            Name       = 'Security Log has NT AUTHORITY\SYSTEM with AccessAllowed'
            Parameters = @{
                WhereObject   = { $_.LogName -eq 'Security' -and $_.SecurityDescriptorDiscretionaryAcl -contains 'NT AUTHORITY\SYSTEM: AccessAllowed (ChangePermissions, CreateDirectories, Delete, GenericExecute, ListDirectory, ReadPermissions, TakeOwnership)' }
                ExpectedCount = 1
                OperationType = 'eq'
            }
        }
        SecurityPermissionsNDefaultBuiltinAdministrators = @{
            Enable     = $true
            Name       = 'Security Log has BUILTIN\Administrators with AccessAllowed'
            Parameters = @{
                WhereObject   = { $_.LogName -eq 'Security' -and $_.SecurityDescriptorDiscretionaryAcl -contains 'BUILTIN\Administrators: AccessAllowed (CreateDirectories, ListDirectory)' }
                ExpectedCount = 1
                OperationType = 'eq'
            }
        }
        SecurityPermissionsDefaultBuiltinEventLogReaders = @{
            Enable     = $true
            Name       = 'Security Log has BUILTIN\Event Log Readers with AccessAllowed'
            Parameters = @{
                WhereObject   = { $_.LogName -eq 'Security' -and $_.SecurityDescriptorDiscretionaryAcl -contains 'BUILTIN\Event Log Readers: AccessAllowed (ListDirectory)' }
                ExpectedCount = 1
                OperationType = 'eq'
            }
        }
    }
}

#$Test = Get-EventsInformation -LogName 'Security' -Machine AD1
#$Test = Get-EventsInformation -LogName 'Microsoft-Windows-PowerShell/Operational' -Machine AD1
#$Test
#$Test.SecurityDescriptorDiscretionaryAcl

# PowerShellCore/Operational
# Microsoft-Windows-PowerShell/Operational

#$D = ConvertFrom-SddlString 'O:BAG:SYD:(A;;0x2;;;S-1-15-2-1)(A;;0x2;;;S-1-15-3-1024-3153509613-960666767-3724611135-2725662640-12138253-543910227-1950414635-4190290187)(A;;0xf0007;;;SY)(A;;0x7;;;BA)(A;;0x7;;;SO)(A;;0x3;;;IU)(A;;0x3;;;SU)(A;;0x3;;;S-1-5-3)(A;;0x3;;;S-1-5-33)(A;;0x1;;;S-1-5-32-573)'
#$D.DiscretionaryAcl

#Get-PSRegistry -RegistryPath 'HKLM\Software\Policies\Microsoft\Windows\PowerShell' | ft -a
#Get-PSRegistry -RegistryPath 'HKLM\SOFTWARE\Wow6432Node\Policies\Microsoft\Windows\PowerShell\ScriptBlockLogging' -ComputerName AD1 | ft -a
#Get-PSRegistry -RegistryPath 'HKLM\SOFTWARE\Wow6432Node\Policies\Microsoft\Windows\PowerShell\Transcription' -ComputerName AD1 | ft -a
#Get-PSRegistry -RegistryPath 'HKLM\SOFTWARE\Wow6432Node\Policies\Microsoft\Windows\PowerShell\ModuleLogging'   -ComputerName AD1 | ft -a
#Get-PSRegistry -registrypath 'HKEY_LOCAL_MACHINE\SOFTWARE\Policies\Microsoft\Windows\PowerShell' -ComputerName AD1
#Get-PSRegistry -registrypath 'HKEY_LOCAL_MACHINE\SOFTWARE\Policies'
#Get-PSRegistry -RegistryPath 'HKLM\SOFTWARE\Policies\Microsoft\Windows\PowerShell' -Verbose