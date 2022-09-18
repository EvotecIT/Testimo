@{
    Name            = 'O365Forms'
    Enable          = $true
    Scope           = 'Office365'
    Source          = @{
        Name           = 'Office365 Basic Forms Settings'
        Data           = {
            Get-O365OrgForms -Authorization $Authorization
        }
        Details        = [ordered] @{
            Category    = 'Configuration'
            Description = 'Office 365 Forms'
            Importance  = 0
            ActionType  = 0
            Resources   = @()
            Tags        = 'O365', 'Configuration', 'Forms'
            StatusTrue  = 0
            StatusFalse = 5
        }
        ExpectedOutput = $true
    }
    Tests           = [ordered] @{
        'ExternalShareCollaborationEnabled' = $true

        Test                                = @{
            Parameters = @{
                ExpectedValue = $false
                OperationType = 'eq'
                Property      = 'ExternalCollaborationEnabled'
            }
        }

        ExternalCollaborationEnabled        = @{
            Enable     = $true
            Name       = 'ExternalCollaborationEnabled Status'
            Parameters = @{
                ExpectedValue = $false
                OperationType = 'eq'
                Property      = 'ExternalCollaborationEnabled'
            }
            Details    = [ordered] @{
                Category    = 'Configuration'
                Importance  = 5
                ActionType  = 2
                StatusTrue  = 1
                StatusFalse = 5
            }
        }
        ExternalSendFormEnabled             = @{
            Enable     = $true
            Name       = 'ExternalSendFormEnabled Status'
            Parameters = @{
                ExpectedValue = $false
                OperationType = 'eq'
                Property      = 'ExternalSendFormEnabled'
            }
            Details    = [ordered] @{
                Category    = 'Configuration'
                Importance  = 5
                ActionType  = 2
                StatusTrue  = 1
                StatusFalse = 5
            }
        }
    }
    DataDescription = { }
    DataHighlights  = { }
}