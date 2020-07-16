$GroupPolicyEmptyUnlinked = @{
    Enable = $true
    Source = @{
        Name           = "Group Policy Empty & Unlinked"
        Data           = {
            Get-GPOZaurr -IncludeDomains $Domain | Where-Object { ($_.ComputerSettingsAvailable -eq $false -and $_.UserSettingsAvailable -eq $false) -or $_.Linked -eq $false }
        }
        Implementation = {

        }
        Details        = [ordered] @{
            Area        = 'Cleanup'
            Category    = 'Group Policy'
            Severity    = ''
            RiskLevel   = 0
            Description = ""
            Resolution  = ''
            Resources   = @(

            )
        }
        ExpectedOutput = $false
    }
    Tests  = [ordered] @{
        EnabledAgingEnabled = @{
            Enable     = $true
            Name       = 'Group Policy Empty'
            Parameters = @{
                WhereObject   = { $_.ComputerSettingsAvailable -eq $false -and $_.UserSettingsAvailable -eq $false }
                ExpectedCount = 0
            }
        }
        NotLinked           = @{
            Enable     = $true
            Name       = 'Group Policy Unlinked'
            Parameters = @{
                WhereObject   = { $_.Linked -eq $false }
                ExpectedCount = 0
            }
        }
    }
}