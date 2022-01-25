$DomainFSMORoles = @{
    Name   = 'DomainRoles'
    Enable = $true
    Scope  = 'Domain'
    Source = @{
        Name           = 'Domain Roles Availability'
        Data           = {
            Test-ADRolesAvailability -Domain $Domain
        }
        Details        = [ordered] @{
            Area        = ''
            Category    = ''
            Severity    = ''
            Importance  = 0
            Description = ''
            Resolution  = ''
            Resources   = @(

            )
        }
        ExpectedOutput = $true
    }
    Tests  = [ordered] @{
        PDCEmulator          = @{
            Enable     = $true
            Name       = 'PDC Emulator Availability'
            Parameters = @{
                ExpectedValue         = $true
                Property              = 'PDCEmulatorAvailability'
                OperationType         = 'eq'
                PropertyExtendedValue = 'PDCEmulator'
            }
        }
        RIDMaster            = @{
            Enable     = $true
            Name       = 'RID Master Availability'
            Parameters = @{
                ExpectedValue         = $true
                Property              = 'RIDMasterAvailability'
                OperationType         = 'eq'
                PropertyExtendedValue = 'RIDMaster'
            }
        }
        InfrastructureMaster = @{
            Enable     = $true
            Name       = 'Infrastructure Master Availability'
            Parameters = @{
                ExpectedValue         = $true
                Property              = 'InfrastructureMasterAvailability'
                OperationType         = 'eq'
                PropertyExtendedValue = 'InfrastructureMaster'
            }
        }
    }
}