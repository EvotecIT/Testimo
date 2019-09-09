$WindowsUpdates = @{
    Enable = $true
    Source = @{
        Name       = "Windows Updates"
        Data       = {
            Get-HotFix -ComputerName $DomainController | Sort-Object -Property InstalledOn -Descending | Select-Object -First 1
        }
        Details = [ordered] @{
            Area             = ''
            Explanation      = ''
            Recommendation   = ''
            RiskLevel        = 10
            RecommendedLinks = @(

            )
        }
    }
    Tests  = [ordered] @{
        WindowsUpdates = @{
            Enable      = $true
            Name        = 'Last Windows Updates should be less than X days ago'
            Parameters  = @{
                Property      = 'InstalledOn'
                ExpectedValue = '(Get-Date).AddDays(-60)'
                OperationType = 'gt'
            }
        }
    }
}