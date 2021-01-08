$GroupPolicyPermissions = @{
    Enable = $true
    Scope  = 'Domain'
    Source = @{
        Name           = "Group Policy Required Permissions"
        Data           = {
            Get-GPOZaurrPermissionAnalysis -Domain $Domain
        }
        Details        = [ordered] @{
            Area        = 'Security'
            Category    = ''
            Severity    = ''
            RiskLevel   = 0
            Description = "Group Policy permissions should always have Authenticated Users and Domain Computers gropup"
            Resolution  = 'Do not remove Authenticated Users, Domain Computers from Group Policies.'
            Resources   = @(
                'https://secureinfra.blog/2018/12/31/most-common-mistakes-in-active-directory-and-domain-services-part-1/'
                'https://support.microsoft.com/en-us/help/3163622/ms16-072-security-update-for-group-policy-june-14-2016'
            )
        }
        ExpectedOutput = $true
    }
    Tests  = [ordered] @{
        Administrative     = @{
            Enable     = $true
            Name       = 'GPO: Administrative Permissions'
            Parameters = @{
                ExpectedCount = 0
                OperationType = 'eq'
                WhereObject   = { $_.Administrative -eq $false }
            }

        }
        AuthenticatedUsers = @{
            Enable     = $true
            Name       = 'GPO: Authenticated Permissions'
            Parameters = @{
                ExpectedCount = 0
                OperationType = 'eq'
                WhereObject   = { $_.AuthenticatedUsers -eq $false }
            }
        }
        System             = @{
            Enable     = $true
            Name       = 'GPO: System Permissions'
            Parameters = @{
                ExpectedCount = 0
                OperationType = 'eq'
                WhereObject   = { $_.System -eq $false }
            }
        }
        Unknown            = @{
            Enable     = $true
            Name       = 'GPO: Unknown Permissions'
            Parameters = @{
                ExpectedCount = 0
                OperationType = 'eq'
                WhereObject   = { $_.Unknown -eq $false }
            }
        }
    }
    <# Another way to do the same thing as above
    Tests  = [ordered] @{
        Administrative     = @{
            Enable     = $true
            Name       = 'GPO: Administrative Permissions'
            Parameters = @{
                Bundle        = $true
                Property      = 'Administrative'
                ExpectedValue = $false
                OperationType = 'notcontains'
                DisplayResult = $false
            }

        }
        AuthenticatedUsers = @{
            Enable     = $true
            Name       = 'GPO: Authenticated Permissions'
            Parameters = @{
                Bundle        = $true
                Property      = 'AuthenticatedUsers'
                ExpectedValue = $false
                OperationType = 'notcontains'
                DisplayResult = $false
            }
        }
        System             = @{
            Enable     = $true
            Name       = 'GPO: System Permissions'
            Parameters = @{
                Bundle        = $true
                Property      = 'System'
                ExpectedValue = $false
                OperationType = 'notcontains'
                DisplayResult = $false
            }
        }
        Unknown            = @{
            Enable     = $true
            Name       = 'GPO: Unknown Permissions'
            Parameters = @{
                Bundle        = $true
                Property      = 'Unknown'
                ExpectedValue = $false
                OperationType = 'notcontains'
                DisplayResult = $false
            }
        }
    }
    #>
}