$Information = @{
    Name   = 'DCInformation'
    Enable = $true
    Scope  = 'DC'
    Source = @{
        Name           = "Domain Controller Information"
        Data           = {
            Get-ADDomainController -Server $DomainController
        }
        Details        = [ordered] @{
            Area        = ''
            Description = ''
            Resolution  = ''
            Importance  = 10
            Resources   = @(

            )
        }
        ExpectedOutput = $true
    }
    Tests  = [ordered] @{
        IsEnabled       = @{
            Enable     = $true
            Name       = 'Is Enabled'
            Parameters = @{
                Property      = 'Enabled'
                ExpectedValue = $True
                OperationType = 'eq'
            }
        }
        IsGlobalCatalog = @{
            Enable     = $true
            Name       = 'Is Global Catalog'
            Parameters = @{
                Property      = 'IsGlobalCatalog'
                ExpectedValue = $True
                OperationType = 'eq'
            }
        }
    }
}