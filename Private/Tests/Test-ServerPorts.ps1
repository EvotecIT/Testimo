$Script:SBDomainControllersPort53 = {
    Test-NetConnection -ComputerName $DomainController -WarningAction SilentlyContinue -Port 53
}

# UDP-389, TCP-389, UDP-135, TCP-135, UDP-88, TCP-88, UDP-445, and TCP-445

#Test-NetConnection -ComputerName AD1 -Port 135
#Test-NetConnection -ComputerName AD1 -Port 389
#Test-NetConnection -ComputerName AD1 -Port 88
#Test-NetConnection -ComputerName AD1 -Port 445

#'Testing local Active Directory TCP ports respond' {
# AD Ports: https://technet.microsoft.com/en-us/library/dd772723(v=ws.10).aspx
#   $Ports = @(53, 88, 135, 139, 389, 445, 464, 636, 3268, 3269, 9389)
#  Test-NetConnection -ComputerName $env:COMPUTERNAME -Port $_).TcpTestSucceeded
$Script:TestServerPorts = {
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

}
$Script:TestServerPortsRDP = {
    $TcpPorts = @(3389)
    Test-ComputerPort -ComputerName $DomainController -PortTCP $TcpPorts -WarningAction SilentlyContinue
}

#$DomainController = 'AD1'
<# Potential ports to test
'WinRm'                        = @{ 'TCP' = 5985 }
'Smb'                          = @{ 'TCP' = 445; 'UDP' = 445 }
'Dns'                          = @{ 'TCP' = 53; 'UDP' = 53 }
'ActiveDirectoryGeneral'       = @{ 'TCP' = 25, 88, 389, 464, 636, 5722, 9389; 'UDP' = 88, 123, 389, 464 }
'ActiveDirectoryGlobalCatalog' = @{ 'TCP' = 3268, 3269 }
'NetBios'                      = @{ 'TCP' = 135, 137, 138, 139; 'UDP' = 137, 138, 139 }
#>
<#
$Script:TestRMPorts = {
    Test-ComputerPort -ComputerName $DomainController -PortTCP 5985
}
$Script:TestSMBPort = {
    Test-ComputerPort -ComputerName $DomainController -PortTCP 445 -PortUDP 445
}
$Script:TestDNSPort = {
    Test-ComputerPort -ComputerName $DomainController -PortTCP 53 -PortUDP 53
}
$Script:TestADPorts = {
    Test-ComputerPort -ComputerName $DomainController -PortTCP 25, 88, 389, 464, 636, 5722, 9389 -PortUDP 88, 123, 389, 464
}
$Script:TestADPortsLDAPGC = {
    # Test-LDAP - 3268/3269 for LDAP/LDAPSSL (GC)
    Test-ComputerPort -ComputerName $DomainController -PortTCP 3268, 3269
}
$Script:TestADPortsLDAP = {
    # $PortLDAP = 389, $PortLDAPS = 636
    Test-ComputerPort -ComputerName $DomainController -PortTCP 389, 636
}
$Script:TestADNetbios = {
    # $PortLDAP = 389, $PortLDAPS = 636
    Test-ComputerPort -ComputerName $DomainController -PortTCP 135, 137, 138, 139 -PortUDP  137, 138, 139
}
#>