$ForestFSMORoles                = @{
    Enable = $true
    Source = @{
        Name       = 'Roles availability'
        Data       = {
            Test-ADRolesAvailability
        }
        Details = [ordered] @{
            Area             = 'Features'
            Explanation      = ''
            Recommendation   = ''
            RiskLevel        = 10
            RecommendedLinks = @(

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