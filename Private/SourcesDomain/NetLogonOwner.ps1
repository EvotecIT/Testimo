$NetLogonOwner = @{
    Enable = $true
    Scope  = 'Domain'
    Source = @{
        Name           = "NetLogon Owner"
        Data           = {
            Get-GPOZaurrNetLogon -OwnerOnly -IncludeDomains $Domain
        }
        Implementation = {

        }
        Details        = [ordered] @{
            Area        = 'Cleanup'
            Category    = 'SYSVOL'
            Severity    = ''
            RiskLevel   = 10
            Description = ""
            Resolution  = ''
            Resources   = @(

            )
            Tags        = 'netlogon', 'grouppolicy', 'gpo', 'sysvol'
        }
        ExpectedOutput = $true
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