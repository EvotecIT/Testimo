$OperatingSystem = @{
    Enable = $true
    Source = @{
        Name       = 'Operating System'
        Data       = {
            Get-ComputerOperatingSystem -ComputerName $DomainController -WarningAction SilentlyContinue
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
        OperatingSystem = @{
            Enable     = $true
            Name       = 'Operating system Windows Server 2012 and up'
            Parameters = @{
                Property              = 'OperatingSystem'
                ExpectedValue         = @('Microsoft Windows Server 2019*', 'Microsoft Windows Server 2016*', 'Microsoft Windows Server 2012*')
                OperationType         = 'like'
                # this means Expected Value will require at least one $true comparison
                # anything else will require all values to match $true
                OperationResult       = 'OR'
                # This overwrites value, normally it shows results of comparison
                PropertyExtendedValue = 'OperatingSystem'
            }

        }
    }
}