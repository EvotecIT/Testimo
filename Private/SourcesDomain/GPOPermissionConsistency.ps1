$GPOPermissionConsistency = @{
    Enable = $false
    Source = @{
        Name           = "GPO: Permission Consistency"
        Data           = {
            Get-GPOZaurrPermissionConsistency -VerifyInheritance -Type Inconsistent
        }
        Details        = [ordered] @{
            Area        = 'Security'
            Category    = ''
            Severity    = ''
            RiskLevel   = 0
            Description = "GPO Permissions are stored in Active Directory and SYSVOL at the same time. Setting up permissions for GPO should replicate itself to SYSVOL and those permissions should be consistent. However, sometimes this doesn't happen or is done on purpose."
            Resolution  = ''
            Resources   = @(

            )
        }
        ExpectedOutput = $false
    }
}