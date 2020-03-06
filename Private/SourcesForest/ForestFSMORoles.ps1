$ForestFSMORoles                = @{
    Enable = $true
    Source = @{
        Name       = 'Roles availability'
        Data       = {
            Test-ADRolesAvailability -Forest $ForestName
        }
        Details = [ordered] @{
            Area             = 'Features'
            Description      = ''
            Resolution   = ''
            RiskLevel        = 10
            Resources = @(

            )
        }
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