$GroupPolicySYSVOLDC = @{
    Name   = 'DCGroupPolicySYSVOLDC'
    Enable = $true
    Scope  = 'DC'
    Source = @{
        Name           = "Group Policy SYSVOL Verification"
        Data           = {
            Get-GPOZaurrBroken -IncludeDomains $Domain -IncludeDomainControllers $DomainController -VerifyDomainControllers | Where-Object { $_.Status -ne 'Exists' }
        }
        Details        = [ordered] @{
            Area        = ''
            Description = ''
            Resolution  = ''
            Importance  = 10
            Resources   = @(

            )
        }
        ExpectedOutput = $false
    }
}