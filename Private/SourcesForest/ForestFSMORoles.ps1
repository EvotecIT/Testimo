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
            Importance  = 0
            ActionType  = 0
            Severity    = 'High'
            Resources   = @(

            )
            StatusTrue  = 0
            StatusFalse = 2
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
            Details    = [ordered] @{
                Category    = 'Health'
                Importance  = 10
                ActionType  = 2
                StatusTrue  = 1
                StatusFalse = 10
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
            Details    = [ordered] @{
                Category    = 'Health'
                Importance  = 10
                ActionType  = 2
                StatusTrue  = 1
                StatusFalse = 10
            }
        }
    }
}