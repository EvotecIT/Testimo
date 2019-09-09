$WindowsRemoteManagement = @{
    Enable = $true
    Source = @{
        Name       = 'Windows Remote Management'
        Data       = {
            Test-WinRM -ComputerName $DomainController
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
        WindowsRemoteManagement = @{
            Enable1     = $true
            Name       = 'Test submits an identification request that determines whether the WinRM service is running.'
            Parameters = @{
                Property      = 'Status'
                ExpectedValue = $true
                OperationType = 'eq'
            }
        }
    }
}