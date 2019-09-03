$Script:TestimoConfiguration = [ordered] @{
    Exclusions        = [ordered] @{
        Domains           = @()
        DomainControllers = @()
    }
    Forest            = [ordered]@{
        OptionalFeatures     = $OptionalFeatures
        Backup               = $ForestBackup
        Sites                = $Sites
        SiteLinks            = $SiteLinks
        SiteLinksConnections = $SiteLinksConnections
        FSMORoles            = $ForestFSMORoles
        TombstoneLifetime    = $TombstoneLifetime
        OrphanedAdmins       = $OrphanedAdmins
        Replication          = $Replication
    }
    Domain            = [ordered] @{
        FSMORoles                          = $DomainFSMORoles
        WellKnownFolders                   = $WellKnownFolders
        PasswordComplexity                 = $PasswordComplexity
        GroupPolicyMissingPermissions      = $GroupPolicyMissingPermissions
        Trusts                             = $Trusts
        OrphanedForeignSecurityPrincipals  = $OrphanedForeignSecurityPrincipals
        EmptyOrganizationalUnits           = $EmptyOrganizationalUnits
        DNSScavengingForPrimaryDNSServer   = $DNSScavengingForPrimaryDNSServer
        DNSForwaders                       = $DNSForwaders
        DnsZonesAging                      = $DnsZonesAging
        KerberosAccountAge                 = $KerberosAccountAge
        SecurityGroupsAccountOperators     = $SecurityGroupsAccountOperators
        SecurityGroupsSchemaAdmins         = $SecurityGroupsSchemaAdmins
        SecurityUsersAcccountAdministrator = $SecurityUsersAcccountAdministrator
        SysVolDFSR                         = $SysVolDFSR
    }
    DomainControllers = [ordered] @{
        WindowsRemoteManagement     = $WindowsRemoteManagement
        OperatingSystem             = $OperatingSystem
        Services                    = $Services
        LDAP                        = $LDAP
        Pingable                    = $Pingable
        Ports                       = $Ports
        RDPPorts                    = $RDPPorts
        RDPSecurity                 = $RDPSecurity
        DiskSpace                   = $DiskSpace
        TimeSettings                = $TimeSettings
        TimeSynchronizationInternal = $TimeSynchronizationInternal
        TimeSynchronizationExternal = $TimeSynchronizationExternal
        WindowsFirewall             = $WindowsFirewall
        WindowsUpdates              = $WindowsUpdates
        WindowsRolesAndFeatures     = $WindowsRolesAndFeatures
        DnsResolveInternal          = $DNSResolveInternal
        DnsResolveExternal          = $DNSResolveExternal
        DnsNameServes               = $DNSNameServers
        SMBProtocols                = $SMBProtocols
        SMBShares                   = $SMBShares
        DFSRAutoRecovery            = $DFSAutoRecovery
    }
    Debug             = [ordered] @{
        ShowErrors = $false
    }
}