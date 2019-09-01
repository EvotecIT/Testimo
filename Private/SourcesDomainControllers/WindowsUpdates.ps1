$WindowsUpdates = @{
    Enable = $true
    Source = @{
        Name       = "Windows Updates"
        Data       = {
            Get-HotFix -ComputerName $DomainController | Sort-Object -Property InstalledOn -Descending | Select-Object -First 1
        }
        Area       = ''
        Parameters = @{

        }
    }
    Tests  = [ordered] @{
        PasswordLastSet = @{
            Enable      = $true
            Name        = 'Last Windows Updates should be less than 60 days ago'
            Parameters  = @{
                Property      = 'InstalledOn'
                ExpectedValue = '(Get-Date).AddDays(-60)'
                OperationType = 'gt'
            }
            Explanation = 'Last installed update should be less than 60 days ago.'
        }
    }
}