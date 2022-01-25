$NetLogonOwner = @{
    Name   = 'DomainNetLogonOwner'
    Enable = $true
    Scope  = 'Domain'
    Source = @{
        Name           = "NetLogon Owner"
        Data           = {
            Get-GPOZaurrNetLogon -Forest $ForestName -OwnerOnly -IncludeDomains $Domain
        }
        Implementation = {

        }
        Details        = [ordered] @{
            Area        = 'Cleanup'
            Category    = 'SYSVOL'
            Severity    = ''
            Importance  = 6
            Description = ""
            Resolution  = ''
            Resources   = @(

            )
            Tags        = 'netlogon', 'grouppolicy', 'gpo', 'sysvol'
        }
        ExpectedOutput = $null
    }
    Tests  = [ordered] @{
        Empty = @{
            Enable     = $true
            Name       = 'Owner should be BUILTIN\Administrators'
            Parameters = @{
                #Bundle        = $true
                WhereObject    = { $_.OwnerSid -ne 'S-1-5-32-544' }
                ExpectedCount  = 0
                ExpectedOutput = $true
            }
        }
    }
}