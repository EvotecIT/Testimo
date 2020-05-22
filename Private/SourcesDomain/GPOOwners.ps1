$GPOOwner = @{
    Enable = $false
    Source = @{
        Name           = "GPO: Owner"
        Data           = {
            Get-GPOZaurrOwner -IncludeSysvol -IncludeDomains $Domain
        }
        Details        = [ordered] @{
            Area        = 'Security'
            Category    = ''
            Severity    = ''
            RiskLevel   = 0
            Description = ""
            Resolution  = ''
            Resources   = @(

            )
        }
        ExpectedOutput = $true
    }
    Tests  = [ordered] @{
        OwnerConsistent     = @{
            Enable     = $true
            Name       = 'GPO: Owner Consistent'
            Parameters = @{
                WhereObject = { $_.IsOwnerConsistent -ne $true }
                #Property      = 'IsOwnerConsistent'
                #ExpectedValue = $true
                #OperationType = 'eq'
            }
            ExpectedOutput = $false
        }
        OwnerAdministrative = @{
            Enable     = $true
            Name       = 'GPO: Owner Administrative'
            Parameters = @{
                WhereObject = { $_.OwnerType -ne 'Administrative' -or $_.SysVolOwner -ne 'Administrative' }
                #Property      = 'OwnerType'
                #ExpectedValue = 'Administrative'
                #OperationType = 'in'
            }
            ExpectedOutput = $false
        }
    }
}