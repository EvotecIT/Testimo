$GroupPolicyAssessment = @{
    Name           = 'DomainGroupPolicyAssessment'
    Enable         = $true
    Scope          = 'Domain'
    Source         = @{
        Name           = "Group Policy Assessment"
        Data           = {
            Get-GPOZaurr -Forest $ForestName -IncludeDomains $Domain
        }
        Implementation = {

        }
        Details        = [ordered] @{
            Area        = 'GroupPolicy'
            Category    = 'Cleanup'
            Severity    = ''
            Importance  = 0
            Description = ""
            Resolution  = ''
            Resources   = @(

            )
        }
        ExpectedOutput = $true
    }
    Tests          = [ordered] @{
        Empty           = @{
            Enable     = $true
            Name       = 'Group Policy Empty'
            Parameters = @{
                #Bundle        = $true
                WhereObject   = { $_.Empty -eq $true }
                ExpectedCount = 0
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
                WhereObject   = { $_.Enabled -eq $false }
                ExpectedCount = 0
            }
        }
        Problem         = @{
            Enable     = $true
            Name       = 'Group Policy with Problem'
            Parameters = @{
                #Bundle        = $true
                WhereObject   = { $_.Problem -eq $true }
                ExpectedCount = 0
            }
        }
        Optimized       = @{
            Enable     = $true
            Name       = 'Group Policy Not Optimized'
            Parameters = @{
                #Bundle        = $true
                WhereObject   = { $_.Optimized -eq $false }
                ExpectedCount = 0
            }
        }
        ApplyPermission = @{
            Enable     = $true
            Name       = 'Group Policy No Apply Permission'
            Parameters = @{
                # Bundle        = $true
                WhereObject   = { $_.ApplyPermissioon -eq $false }
                ExpectedCount = 0
            }
        }
    }
    DataHighlights = {
        New-HTMLTableCondition -Name 'Empty' -ComparisonType string -BackgroundColor PaleGreen -Value $false -Operator eq -FailBackgroundColor Salmon
        New-HTMLTableCondition -Name 'Linked' -ComparisonType string -BackgroundColor PaleGreen -Value $true -Operator eq -FailBackgroundColor Salmon
        New-HTMLTableCondition -Name 'Enabled' -ComparisonType string -BackgroundColor PaleGreen -Value $true -Operator eq -FailBackgroundColor Salmon
        New-HTMLTableCondition -Name 'Optimized' -ComparisonType string -BackgroundColor PaleGreen -Value $true -Operator eq -FailBackgroundColor Salmon
        New-HTMLTableCondition -Name 'Problem' -ComparisonType string -BackgroundColor PaleGreen -Value $false -Operator eq -FailBackgroundColor Salmon
        New-HTMLTableCondition -Name 'ApplyPermission' -ComparisonType string -BackgroundColor PaleGreen -Value $true -Operator eq -FailBackgroundColor Salmon
    }
}