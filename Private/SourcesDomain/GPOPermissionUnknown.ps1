$GPOPermissionUnknown = @{
    Enable = $true
    Source = @{
        Name           = "GPO: Permission Unknown"
        Data           = {
            Get-GPOZaurrPermission -Type Unknown -IncludeDomains $Domain
        }
        Details        = [ordered] @{
            Area        = 'Cleanup'
            Category    = ''
            Severity    = ''
            RiskLevel   = 0
            Description = "There should be no unknown permissions (deleted users/groups/computers)."
            Resolution  = ''
            Resources   = @(

            )
        }
        ExpectedOutput = $false
    }
}