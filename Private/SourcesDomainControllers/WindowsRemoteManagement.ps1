$WindowsRemoteManagement = @{
    Enable = $true
    Scope  = 'DC'
    Source = @{
        Name       = 'Windows Remote Management'
        Data       = {
            Test-WinRM -ComputerName $DomainController
        }
        Details = [ordered] @{
            Area             = ''
            Description      = ''
            Resolution   = ''
            Importance        = 10
            Resources = @(

            )
        }
        ExpectedOutput = $true
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