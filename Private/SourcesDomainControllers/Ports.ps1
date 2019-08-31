$Ports = [ordered] @{
    Enable = $true
    Source = [ordered] @{
        Name       = 'AD TCP Ports are open' # UDP Testing is unreliable for now
        Data       = {
            # Port 389, 636, 3268, 3269 are tested as LDAP Ports with proper LDAP
            $TcpPorts = @(53, 88, 135, 139, 389, 445, 464, 636, 3268, 3269, 9389)
            # $TcpPorts = @(25, 53, 88, 464, 5722, 9389)
            Test-ComputerPort -ComputerName $DomainController -PortTCP $TcpPorts -WarningAction SilentlyContinue
            <#
                ComputerName Port Protocol Status Summary             Response
                ------------ ---- -------- ------ -------             --------
                AD1            53 TCP        True TCP 53 Successful
                AD1          3389 TCP        True TCP 3389 Successful
                AD7            53 TCP       False TCP 53 Failed
                AD7          3389 TCP       False TCP 3389 Failed
            #>

            # UDP Testing is unreliable
            <# Potential ports to test
                'WinRm'                        = @{ 'TCP' = 5985 }
                'Smb'                          = @{ 'TCP' = 445; 'UDP' = 445 }
                'Dns'                          = @{ 'TCP' = 53; 'UDP' = 53 }
                'ActiveDirectoryGeneral'       = @{ 'TCP' = 25, 88, 389, 464, 636, 5722, 9389; 'UDP' = 88, 123, 389, 464 }
                'ActiveDirectoryGlobalCatalog' = @{ 'TCP' = 3268, 3269 }
                'NetBios'                      = @{ 'TCP' = 135, 137, 138, 139; 'UDP' = 137, 138, 139 }

                Test-ComputerPort -ComputerName $DomainController -PortTCP 25, 88, 389, 464, 636, 5722, 9389 -PortUDP 88, 123, 389, 464
            #>
        }
    }
    Tests  = [ordered] @{
        Ping = [ordered] @{
            Enable     = $true
            Name       = 'Port is OPEN'
            #Data     = $Script:SBDomainControllersPort53Test
            Parameters = @{
                Property              = 'Status'
                ExpectedValue         = $true
                OperationType         = 'eq'
                PropertyExtendedValue = 'Summary'
            }
        }
    }
}