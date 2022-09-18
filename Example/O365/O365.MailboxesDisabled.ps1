@{
    Name   = 'Office365Mailboxes'
    Enable = $true
    Scope  = '  '
    Source = @{
        Name           = 'Office365 Mailboxes'
        Data           = {
            Import-Module (Import-PSSession -Session $Session -Verbose:$false -DisableNameChecking -AllowClobber) -Global -DisableNameChecking
            Get-Mailbox -ResultSize Unlimited | Select-Object -Property UserPrincipalName, HiddenFromAddressListsEnabled, PrimarySmtpAddress, WhenChanged, WhenCreated
        }
        Details        = [ordered] @{
            Category    = 'Configuration'
            Description = 'Office365Mailboxes'
            Importance  = 0
            ActionType  = 0
            Resources   = @(

            )
            Tags        = 'O365', 'Configuration'
            StatusTrue  = 0
            StatusFalse = 5
        }
        ExpectedOutput = $true
    }
    Tests  = [ordered] @{
        HiddenFromAddressListsEnabled = @{
            Enable     = $true
            Name       = 'Hidden Mailboxes'
            Parameters = @{
                WhereObject   = { $_.HiddenFromAddressListsEnabled -eq $false }
                OperationType = 'lt'
                ExpectedCount = 5
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
}