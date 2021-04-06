$LanManServer = @{
    Enable = $true
    Scope  = 'DC'
    Source = @{
        Name           = "Lan Man Server"
        Data           = {
            #Get-WinADLMSettings -DomainController $DomainController
            Get-PSRegistry -RegistryPath 'HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Services\LanManServer\Parameters' -ComputerName $DomainController
        }
        Details        = [ordered] @{
            Area        = 'Security'
            Description = 'Lan Man Server'
            Resolution  = ''
            Importance   = 10
            Resources   = @(

            )
        }
        Requirements   = @{
            CommandAvailable = 'Get-PSRegistry'
        }
        ExpectedOutput = $true
    }
    Tests  = [ordered] @{
        DisableCompression        = @{
            Enable     = $false
            Name       = 'Disable Compression SMBv3'
            Parameters = @{
                Property      = 'DisableCompression'
                ExpectedValue = 1
                OperationType = 'eq'
            }
            Details    = [ordered] @{
                Area        = 'Security'
                Description = 'Microsoft is aware of a remote code execution vulnerability in the way that the Microsoft Server Message Block 3.1.1 (SMBv3) protocol handles certain requests. An attacker who successfully exploited the vulnerability could gain the ability to execute code on the target SMB Server or SMB Client. To exploit the vulnerability against an SMB Server, an unauthenticated attacker could send a specially crafted packet to a targeted SMBv3 Server. To exploit the vulnerability against an SMB Client, an unauthenticated attacker would need to configure a malicious SMBv3 Server and convince a user to connect to it.'
                Resolution  = 'Disable SMBv3 compression or apply patch. Since patch is available disabling is not nessecary.'
                Importance   = 10
                Resources   = @(
                    'https://portal.msrc.microsoft.com/en-US/security-guidance/advisory/adv200005'
                )
            }
        }
        EnableForcedLogoff       = @{
            Enable     = $true
            Name       = 'Enable Forced Logoff'
            Parameters = @{
                Property      = 'EnableForcedLogoff'
                ExpectedValue = 1
                OperationType = 'eq'
            }
            Details    = [ordered] @{
                Area        = ''
                Description = 'Users are not forcibly disconnected when logon hours expire.'
                Resolution  = ''
                Importance   = 10
                Resources   = @(
                    'https://www.stigviewer.com/stig/windows_7/2012-07-02/finding/V-1136'
                )
            }
        }
        EnableSecuritySignature  = @{
            Enable     = $true
            Name       = 'Enable Security Signature'
            Parameters = @{
                Property      = 'EnableSecuritySignature'
                ExpectedValue = 1
                OperationType = 'eq'
            }
            Details    = [ordered] @{
                Area        = ''
                Description = 'Microsoft network server: Digitally sign communications (if client agrees)'
                Resolution  = ''
                Importance   = 10
                Resources   = @(
                    'https://support.microsoft.com/en-us/help/887429/overview-of-server-message-block-signing' # XP
                    'https://community.spiceworks.com/topic/2131862-how-to-set-microsoft-network-server-digitally-sign-communications-always'
                    'https://www.stigviewer.com/stig/windows_server_2016/2017-11-20/finding/V-73663'
                )
            }
        }
        RequireSecuritySignature = @{
            Enable     = $true
            Name       = 'Require Security Signature'
            Parameters = @{
                Property      = 'RequireSecuritySignature'
                ExpectedValue = 1
                OperationType = 'eq'
            }
            Details    = [ordered] @{
                Type            = 'Security'
                Area            = ''
                Description     = 'Microsoft network server: Digitally sign communications (always)'
                Vulnerability   = 'Session hijacking uses tools that allow attackers who have access to the same network as the client
                computer or server to interrupt, end, or steal a session in progress. Attackers can potentially intercept and modify
                unsigned Server Message Block (SMB) packets and then modify the traffic and forward it so that the server might
                perform objectionable actions. Alternatively, the attacker could pose as the server or client after legitimate
                authentication and gain unauthorized access to data.
                SMB is the resource-sharing protocol that is supported by many Windows operating systems. It is the basis of NetBIOS
                and many other protocols. SMB signatures authenticate both users and the servers that host the data. If either side
                fails the authentication process, data transmission does not take place.'
                PotentialImpact = 'The Windows implementation of the SMB file and print-sharing protocol support mutual authentication,
                which prevents session hijacking attacks and supports message authentication to prevent man-in-the-middle attacks.
                SMB signing provides this authentication by placing a digital signature into each SMB, which is then verified by both the client computer and the server.
                Implementing SMB signing may negatively affect performance because each packet must be signed and verified. If these policy settings are enabled on a server that is performing multiple roles, such as a small business server that is serving as a domain controller, file server, print server, and application server, performance may be substantially slowed. Additionally, if you configure computers to ignore all unsigned SMB communications, older applications and operating systems cannot connect. However, if you completely disable all SMB signing, computers are vulnerable to session-hijacking attacks.'
                Resolution      = ''
                Importance       = 10
                Resources       = @(
                    'https://docs.microsoft.com/en-us/previous-versions/windows/it-pro/windows-server-2008-R2-and-2008/hh125918(v=ws.10)?redirectedfrom=MSDN#vulnerability'
                    'https://support.microsoft.com/en-us/help/887429/overview-of-server-message-block-signing' # XP
                    'https://community.spiceworks.com/topic/2131862-how-to-set-microsoft-network-server-digitally-sign-communications-always'
                )
            }
        }
    }
}


#Get-PSRegistry -RegistryPath 'HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Services\Tcpip6\Parameters' -ComputerName AD1

#Get-PSRegistry -RegistryPath 'HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Services\Tcpip\Parameters' -ComputerName AD1
