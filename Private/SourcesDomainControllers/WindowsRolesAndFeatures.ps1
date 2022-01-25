$WindowsRolesAndFeatures = @{
    Name   = 'DCWindowsRolesAndFeatures'
    Enable = $true
    Scope  = 'DC'
    Source = @{
        Name           = "Windows Roles and Features"
        Data           = {
            Get-WindowsFeature -ComputerName $DomainController #| Where-Object { $_.'InstallState' -eq 'Installed' }
        }
        ExpectedOutput = $true
    }
    Tests  = [ordered] @{
        ActiveDirectoryDomainServices = @{
            Enable     = $true
            Name       = 'Active Directory Domain Services is installed'
            Parameters = @{
                WhereObject   = { $_.Name -eq 'AD-Domain-Services' }
                Property      = 'Installed'
                ExpectedValue = $true
                OperationType = 'eq'
            }
        }
        DNSServer                     = @{
            Enable     = $true
            Name       = 'DNS Server is installed'
            Parameters = @{
                WhereObject   = { $_.Name -eq 'DNS' }
                Property      = 'Installed'
                ExpectedValue = $true
                OperationType = 'eq'
            }
        }
        FileandStorageServices        = @{
            Enable     = $true
            Name       = 'File and Storage Services is installed'
            Parameters = @{
                WhereObject   = { $_.Name -eq 'FileAndStorage-Services' }
                Property      = 'Installed'
                ExpectedValue = $true
                OperationType = 'eq'
            }
        }
        FileandiSCSIServices          = @{
            Enable     = $true
            Name       = 'File and iSCSI Services is installed'
            Parameters = @{
                WhereObject   = { $_.Name -eq 'File-Services' }
                Property      = 'Installed'
                ExpectedValue = $true
                OperationType = 'eq'
            }
        }
        FileServer                    = @{
            Enable     = $true
            Name       = 'File Server is installed'
            Parameters = @{
                WhereObject   = { $_.Name -eq 'FS-FileServer' }
                Property      = 'Installed'
                ExpectedValue = $true
                OperationType = 'eq'
            }
        }
        StorageServices               = @{
            Enable     = $true
            Name       = 'Storage Services is installed'
            Parameters = @{
                WhereObject   = { $_.Name -eq 'Storage-Services' }
                Property      = 'Installed'
                ExpectedValue = $true
                OperationType = 'eq'
            }
        }
        WindowsPowerShell51           = @{
            Enable     = $true
            Name       = 'Windows PowerShell 5.1 is installed'
            Parameters = @{
                WhereObject   = { $_.Name -eq 'PowerShell' }
                Property      = 'Installed'
                ExpectedValue = $true
                OperationType = 'eq'
            }
        }
    }
}