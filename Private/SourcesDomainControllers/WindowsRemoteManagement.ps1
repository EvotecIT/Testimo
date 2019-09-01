$WindowsRemoteManagement = @{
    Enable = $true
    Source = @{
        Name       = 'Windows Remote Management'
        Data       = {
            Test-WinRM -ComputerName $DomainController
        }
    }
    Tests  = [ordered] @{
        OperatingSystem = @{
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