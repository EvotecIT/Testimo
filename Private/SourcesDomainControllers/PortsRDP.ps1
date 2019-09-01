$PortsRDP = [ordered] @{
    Enable = $true
    Source = [ordered] @{
        Name       = 'RDP Ports is open'
        Data       = {
            Test-ComputerPort -ComputerName $DomainController -PortTCP 3389 -WarningAction SilentlyContinue
        }
    }
    Tests  = [ordered] @{
        Ping = [ordered] @{
            Enable     = $true
            Name       = 'Port is OPEN'
            Parameters = @{
                Property              = 'Status'
                ExpectedValue         = $true
                OperationType         = 'eq'
                PropertyExtendedValue = 'Summary'
            }
        }
    }
}