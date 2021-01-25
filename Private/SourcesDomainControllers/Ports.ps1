$Ports = [ordered] @{
    Enable = $true
    Scope  = 'DC'
    Source = [ordered] @{
        Name           = 'TCP Ports are open/closed as required' # UDP Testing is unreliable for now
        Data           = {
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
        Requirements   = @{
            CommandAvailable = 'Test-NetConnection'
        }
        Details        = [ordered] @{
            Area        = ''
            Category    = ''
            Severity    = ''
            RiskLevel   = 0
            Description = ''
            Resolution  = ''
            Resources   = @(

            )
        }
        ExpectedOutput = $true
    }
    Tests  = [ordered] @{
        Port53   = [ordered] @{
            Enable     = $true
            Name       = 'Port is OPEN'
            Parameters = @{
                WhereObject           = { $_.Port -eq '53' }
                Property              = 'Status'
                ExpectedValue         = $true
                OperationType         = 'eq'
                PropertyExtendedValue = 'Summary'
            }
        }
        Port88   = [ordered] @{
            Enable     = $true
            Name       = 'Port is OPEN'
            Parameters = @{
                WhereObject           = { $_.Port -eq '88' }
                Property              = 'Status'
                ExpectedValue         = $true
                OperationType         = 'eq'
                PropertyExtendedValue = 'Summary'
            }
        }
        Port135  = [ordered] @{
            Enable     = $true
            Name       = 'Port is OPEN'
            Parameters = @{
                WhereObject           = { $_.Port -eq '135' }
                Property              = 'Status'
                ExpectedValue         = $true
                OperationType         = 'eq'
                PropertyExtendedValue = 'Summary'
            }
        }
        Port139  = [ordered] @{
            Enable     = $true
            Name       = 'Port is CLOSED'
            Parameters = @{
                WhereObject           = { $_.Port -eq '139' }
                Property              = 'Status'
                ExpectedValue         = $false
                OperationType         = 'eq'
                PropertyExtendedValue = 'Summary'
            }
            Details    = [ordered] @{
                Area        = ''
                Category    = ''
                Severity    = ''
                RiskLevel   = 0
                Description = @'
                NetBIOS over TCP/IP is a networking protocol that allows legacy computer applications relying on the NetBIOS to be used on modern TCP/IP networks.
                Enabling NetBios might help an attackers access shared directories, files and also gain sensitive information such as computer name, domain, or workgroup.
'@
                Resolution  = 'Disable NETBIOS over TCPIP'
                Resources   = @(
                    'http://woshub.com/how-to-disable-netbios-over-tcpip-and-llmnr-using-gpo/'
                )
            }
        }
        Port445  = [ordered] @{
            Enable     = $true
            Name       = 'Port is OPEN'
            Parameters = @{
                WhereObject           = { $_.Port -eq '445' }
                Property              = 'Status'
                ExpectedValue         = $true
                OperationType         = 'eq'
                PropertyExtendedValue = 'Summary'
            }
        }
        Port464  = [ordered] @{
            Enable     = $true
            Name       = 'Port is OPEN'
            Parameters = @{
                WhereObject           = { $_.Port -eq '464' }
                Property              = 'Status'
                ExpectedValue         = $true
                OperationType         = 'eq'
                PropertyExtendedValue = 'Summary'
            }
        }
        Port636  = [ordered] @{
            Enable     = $true
            Name       = 'Port is OPEN'
            Parameters = @{
                WhereObject           = { $_.Port -eq '636' }
                Property              = 'Status'
                ExpectedValue         = $true
                OperationType         = 'eq'
                PropertyExtendedValue = 'Summary'
            }
        }

        Port3268 = [ordered] @{
            Enable     = $true
            Name       = 'Port is OPEN'
            Parameters = @{
                WhereObject           = { $_.Port -eq '3268' }
                Property              = 'Status'
                ExpectedValue         = $true
                OperationType         = 'eq'
                PropertyExtendedValue = 'Summary'
            }
        }
        Port3269 = [ordered] @{
            Enable     = $true
            Name       = 'Port is OPEN'
            Parameters = @{
                WhereObject           = { $_.Port -eq '3269' }
                Property              = 'Status'
                ExpectedValue         = $true
                OperationType         = 'eq'
                PropertyExtendedValue = 'Summary'
            }
        }
        Port9389 = [ordered] @{
            Enable     = $true
            Name       = 'Port is OPEN'
            Parameters = @{
                WhereObject           = { $_.Port -eq '9389' }
                Property              = 'Status'
                ExpectedValue         = $true
                OperationType         = 'eq'
                PropertyExtendedValue = 'Summary'
            }
        }
    }
}