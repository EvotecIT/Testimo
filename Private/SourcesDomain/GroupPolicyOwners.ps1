$GroupPolicyOwner = @{
    Name   = 'DomainGroupPolicyOwner'
    Enable = $true
    Scope  = 'Domain'
    Source = @{
        Name           = "GPO: Owner"
        Data           = {
            Get-GPOZaurrOwner -Forest $ForestName -IncludeSysvol -IncludeDomains $Domain
        }
        Details        = [ordered] @{
            Area        = 'GroupPolicy'
            Category    = 'Security'
            Severity    = ''
            Importance  = 0
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
                WhereObject    = { $_.IsOwnerConsistent -ne $true }
                ExpectedResult = $false # this tests things in bundle rather then per object of array
            }

        }
        OwnerAdministrative = @{
            Enable     = $true
            Name       = 'GPO: Owner Administrative'
            Parameters = @{
                WhereObject    = { $_.OwnerType -ne 'Administrative' -or $_.SysvolType -ne 'Administrative' }
                ExpectedResult = $false # this tests things in bundle rather then per object of array
            }
        }
    }
}
<#
ExpectedCount = 0,1,2,3 and so on
ExpectedValue = [object]
ExpectedResult = $true # just checks if there is result or there is not
#>