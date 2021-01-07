$GroupPolicyAssesment = @{
    Enable = $true
    Source = @{
        Name           = "Group Policy Assesment"
        Data           = {
            Get-GPOZaurr -IncludeDomains $Domain #| Where-Object { ($_.ComputerSettingsAvailable -eq $false -and $_.UserSettingsAvailable -eq $false) -or $_.Linked -eq $false }
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
        ExpectedOutput = $true
    }
    Tests  = [ordered] @{
        Empty           = @{
            Enable     = $true
            Name       = 'Group Policy Empty'
            Parameters = @{
                #Bundle        = $true
                WhereObject    = { $_.Empty -eq $false }
                ExpectedCount  = 0
                ExpectedOutput = $true
            }
        }
        Linked          = @{
            Enable     = $true
            Name       = 'Group Policy Unlinked'
            Parameters = @{
                #Bundle        = $true
                WhereObject   = { $_.Linked -eq $false }
                ExpectedCount = 0
            }
        }
        Enabled         = @{
            Enable     = $true
            Name       = 'Group Policy Disabled'
            Parameters = @{
                #Bundle        = $true
                WhereObject    = { $_.Enabled -eq $false }
                ExpectedCount  = 0
                ExpectedOutput = $true
            }
        }
        Problem         = @{
            Enable     = $true
            Name       = 'Group Policy with Problem'
            Parameters = @{
                #Bundle        = $true
                WhereObject   = { $_.Problem -eq $false }
                ExpectedCount = 0
            }
        }
        Optimized       = @{
            Enable     = $true
            Name       = 'Group Policy Optimized'
            Parameters = @{
                #Bundle        = $true
                WhereObject   = { $_.Optimized -eq $false }
                ExpectedCount = 0
            }
        }
        ApplyPermission = @{
            Enable     = $true
            Name       = 'Group Policy Unlinked'
            Parameters = @{
                # Bundle        = $true
                WhereObject   = { $_.ApplyPermissioon -eq $false }
                ExpectedCount = 0
            }
        }
    }
}