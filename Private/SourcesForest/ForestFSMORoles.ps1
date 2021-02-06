$ForestFSMORoles = @{
    Enable = $true
    Scope  = 'Forest'
    Source = @{
        Name           = 'Roles availability'
        Data           = {
            Test-ADRolesAvailability -Forest $ForestName
        }
        Details        = [ordered] @{
            Category    = 'Health'
            Description = ''
            Resolution  = ''
            Importance  = 10
            Severity    = 'High'
            Resources   = @(

            )
        }
        ExpectedOutput = $true
    }
    Tests  = [ordered] @{
        SchemaMasterAvailability       = @{
            Enable     = $true
            Name       = 'Schema Master Availability'
            Parameters = @{
                ExpectedValue         = $true
                Property              = 'SchemaMasterAvailability'
                OperationType         = 'eq'
                PropertyExtendedValue = 'SchemaMaster'
            }
        }
        DomainNamingMasterAvailability = @{
            Enable     = $true
            Name       = 'Domain Master Availability'
            Parameters = @{
                ExpectedValue         = $true
                Property              = 'DomainNamingMasterAvailability'
                OperationType         = 'eq'
                PropertyExtendedValue = 'DomainNamingMaster'
            }
        }
    }
}