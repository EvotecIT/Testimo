$GroupPolicySYSVOLDC = @{
    Enable = $true
    Source = @{
        Name           = "Group Policy SYSVOL Verification"
        Data           = {
            Get-GPOZaurrSysvol -IncludeDomains $Domain -IncludeDomainControllers $DomainController -VerifyDomainControllers | Where-Object { $_.SysvolStatus -ne 'Exists' -or $_.Status -ne 'Exists' }
        }
        Details        = [ordered] @{
            Area        = ''
            Description = ''
            Resolution  = ''
            RiskLevel   = 10
            Resources   = @(

            )
        }
        ExpectedOutput = $false
    }
}