$GroupPolicyPermissionConsistency = @{
    Name   = 'DomainGroupPolicyPermissionConsistency'
    Enable = $true
    Scope  = 'Domain'
    Source = @{
        Name           = "GPO: Permission Consistency"
        Data           = {
            Get-GPOZaurrPermissionConsistency -Forest $ForestName -VerifyInheritance -Type Inconsistent -IncludeDomains $Domain
        }
        Details        = [ordered] @{
            Area        = 'GroupPolicy'
            Category    = 'Security'
            Severity    = ''
            Importance  = 0
            Description = "GPO Permissions are stored in Active Directory and SYSVOL at the same time. Setting up permissions for GPO should replicate itself to SYSVOL and those permissions should be consistent. However, sometimes this doesn't happen or is done on purpose."
            Resolution  = ''
            Resources   = @(

            )
        }
        ExpectedOutput = $false
    }
}