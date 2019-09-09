$NetworkCardSettings = @{
    Enable = $true
    Source = @{
        Name    = "Get all network interfaces and firewall status"
        Data    = {
            Get-ComputerNetwork -ComputerName $DomainController
        }
        Details = [ordered] @{
            Area        = 'Connectivity'
            Category    = ''
            Severity    = ''
            RiskLevel   = 0
            Description = ''
            Resolution  = ''
            Resources   = @(

            )
        }
    }
    Tests  = [ordered] @{
        NETBIOSOverTCIP = @{
            Enable     = $true
            Name       = 'NetBIOS over TCIP should be disabled.'
            Parameters = @{
                Property      = 'NetBIOSOverTCPIP'
                ExpectedValue = 'Disabled'
                OperationType = 'eq'
            }
            Details    = @{
                Area        = 'Connectivity'
                Category    = 'Legacy Protocols'
                Severity    = 'Critical'
                RiskLevel   = 90 # 100 is top
                Description = @'
                NetBIOS over TCP/IP is a networking protocol that allows legacy computer applications relying on the NetBIOS to be used on modern TCP/IP networks.
                Enabling NetBios might help an attackers access shared directories, files and also gain sensitive information such as computer name, domain, or workgroup.
'@
                Resolution  = 'Disable NetBIOS over TCPIP'
                Resources   = @(
                    'http://woshub.com/how-to-disable-netbios-over-tcpip-and-llmnr-using-gpo/'
                )
            }
        }
        WindowsFirewall = @{
            Enable     = $true
            Name       = 'Windows Firewall should be enabled on network card'
            Parameters = @{
                Property              = 'FirewallStatus'
                ExpectedValue         = $true
                OperationType         = 'eq'
                PropertyExtendedValue = 'FirewallProfile'
            }
        }
    }
}