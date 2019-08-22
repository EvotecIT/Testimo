$Script:TestimoConfiguration = [ordered] @{
    Exclusions        = @{
        #Domains = 'ad.evotec.pl'
        #DomainControllers = 'AD3.ad.evotec.xyz'
    }
    Forest            = @{
        Sources = [ordered]  @{
            OptionalFeatures     = @{
                Enable = $true
                Source = @{
                    Name       = 'Optional Features'
                    Data       = $Script:SBForestOptionalFeatures
                    Parameters = @{

                    }
                }
                Tests  = [ordered] @{
                    RecycleBinEnabled    = @{
                        Enable     = $true
                        Name       = 'Recycle Bin Enabled'
                        # Data     = $Script:SBForestOptionalFeaturesTest1
                        Parameters = @{
                            Property      = 'Recycle Bin Enabled'
                            ExpectedValue = $true
                            OperationType = 'eq'
                        }
                    }
                    LapsAvailable        = @{
                        Enable     = $true
                        Name       = 'LAPS Schema Extended'
                        # Data     = $Script:SBForestOptionalFeaturesTest2
                        Parameters = @{
                            Property      = 'Laps Enabled'
                            ExpectedValue = $true
                            OperationType = 'eq'
                        }
                    }
                    PrivAccessManagement = @{
                        Enable     = $true
                        Name       = 'Privileged Access Management Enabled'
                        #  Data     = $Script:SBForestOptionalFeaturesTest3
                        Parameters = @{
                            Property      = 'Privileged Access Management Feature Enabled'
                            ExpectedValue = $true
                            OperationType = 'eq'
                        }
                    }
                }
            }
            Replication          = @{
                Enable = $true
                Source = @{
                    Name       = 'Forest Replication'
                    Data       = $Script:SBForestReplication
                    Parameters = @{

                    }
                }
                Tests  = [ordered] @{
                    ReplicationTests = @{
                        Enable     = $true
                        Name       = 'Replication Test'
                        Data       = $Script:SBForestReplicationTest1
                        Parameters = @{
                            #ExpectedValue        = $true
                            OperationType = 'eq'
                            #PropertyExtendedValue = 'StatusMessage'
                        }
                    }
                }
            }
            LastBackup           = @{
                Enable = $false
                Source = @{
                    Name       = 'Forest Backup'
                    Data       = $Script:SBForestLastBackup
                    Parameters = @{

                    }
                }
                Tests  = [ordered] @{
                    LastBackupTests = @{
                        Enable     = $true
                        Name       = 'Forest Last Backup Time - Context'
                        Data       = $Script:SBForestLastBackupTest
                        Parameters = @{
                            #ExpectedValue        = $true
                            #OperationType = 'eq'
                            #PropertyExtendedValue = 'StatusMessage'
                        }
                    }
                }
            }
            Sites                = @{
                Enable = $false
                Source = @{
                    Name       = 'Sites Verification'
                    Area       = 'Sites'
                    Data       = $Script:SBForestSites
                    Parameters = @{

                    }
                }
                Tests  = [ordered] @{
                    SitesWithoutDC      = @{
                        Enable      = $true
                        Name        = 'Sites without Domain Controllers'
                        #Data     = $Script:SBForestSitesTest1
                        Description = 'Verify each `site has at least [one subnet configured]`'
                        Parameters  = @{
                            Property      = 'SitesWithoutDC'
                            ExpectedValue = 0
                            OperationType = 'eq'
                            #PropertyExtendedValue = 'SitesWithoutDCName'
                        }
                    }
                    SitesWithoutSubnets = @{
                        Enable     = $true
                        Name       = 'Sites without Subnets'
                        #Data     = $Script:SBForestSitesTest2
                        Parameters = @{
                            Property      = 'SitesWithoutSubnets'
                            ExpectedValue = 0
                            OperationType = 'eq'
                            #PropertyExtendedValue = 'SitesWithoutSubnetsName'
                        }
                    }
                }
            }
            SiteLinks            = @{
                Enable = $false
                Source = @{
                    Name       = 'Site Links'
                    Data       = $Script:SBForestSiteLinks
                    Area       = 'Sites'
                    Parameters = @{

                    }
                }
                Tests  = [ordered] @{
                    MinimalReplicationFrequency = @{
                        Enable      = $true
                        Name        = 'Replication Frequency should be set to minimal value'
                        Description = ''
                        Parameters  = @{
                            Property      = 'ReplicationFrequencyInMinutes'
                            ExpectedValue = 60
                            OperationType = 'lt'
                        }
                    }
                    UseNotificationsForLinks    = @{
                        Enable      = $true
                        Name        = 'Automatic site links should use notifications'
                        Description = ''
                        Parameters  = @{
                            Property              = 'Options'
                            ExpectedValue         = 'UseNotify'
                            OperationType         = 'contains'
                            PropertyExtendedValue = 'Options'
                        }
                    }
                }
            }
            SiteLinksConnections = @{
                Enable = $false
                Source = @{
                    Name       = 'Site Links Connections'
                    Data       = $Script:SBForestSiteLinksConnections
                    Area       = 'Sites'
                    Parameters = @{

                    }
                }
                Tests  = [ordered] @{
                    AutomaticSiteLinks             = @{
                        Enable      = $true
                        Name        = 'All site links are automatic'
                        Description = 'Verify there are no manually configured sitelinks'
                        Parameters  = @{
                            Property              = 'SiteLinksManualCount'
                            ExpectedValue         = 0
                            OperationType         = 'eq'
                            PropertyExtendedValue = 'SiteLinksManual'
                        }
                    }
                    SiteLinksNotifications         = @{
                        Enable     = $true
                        Name       = 'All site links use notifications'
                        Parameters = @{
                            Property      = 'SiteLinksNotUsingNotifyCount'
                            ExpectedValue = 0
                            OperationType = 'eq'
                        }
                    }
                    SiteLinksDoNotUseNotifications = @{
                        Enable     = $false
                        Name       = 'All site links are not using notifications'
                        Parameters = @{
                            Property      = 'SiteLinksUseNotifyCount'
                            ExpectedValue = 0
                            OperationType = 'eq'

                        }
                    }
                }
            }
            Roles                = @{
                Enable = $false
                Source = @{
                    Name       = 'Roles availability'
                    Data       = $Script:SBForestRoles
                    Area       = ''
                    Parameters = @{

                    }
                }
                Tests  = [ordered] @{
                    SchemaMasterAvailability       = @{
                        Enable     = $true
                        Name       = 'Schema Master Availability'
                        #Data     = $Script:SBForestRolesTest
                        Parameters = @{
                            ExpectedValue         = $true
                            Property              = 'SchemaMasterAvailability'
                            OperationType         = 'eq'
                            PropertyExtendedValue = 'SchemaMaster'
                        }
                    }
                    DomainNamingMasterAvailability = @{
                        Enable     = $true
                        Name       = 'Domain Master Availability'
                        #Data     = $Script:SBForestRolesTest2
                        Parameters = @{
                            ExpectedValue         = $true
                            Property              = 'DomainNamingMasterAvailability'
                            OperationType         = 'eq'
                            PropertyExtendedValue = 'DomainNamingMaster'
                        }
                    }
                }
            }
        }
    }
    Domain            = @{
        Sources = [ordered] @{
            Roles                            = @{
                Enable = $false
                Source = @{
                    Name       = 'Roles availability'
                    Data       = $Script:SBDomainRoles
                    Area       = ''
                    Parameters = @{

                    }
                }
                Tests  = [ordered] @{
                    PDCEmulator          = @{
                        Enable     = $true
                        Name       = 'PDC Emulator Availability'
                        # Data     = $Script:SBForestRolesTest
                        Parameters = @{
                            ExpectedValue         = $true
                            Property              = 'PDCEmulatorAvailability'
                            OperationType         = 'eq'
                            PropertyExtendedValue = 'PDCEmulator'
                        }
                    }
                    RIDMaster            = @{
                        Enable     = $true
                        Name       = 'RID Master Availability'
                        #  Data     = $Script:SBForestRolesTest2
                        Parameters = @{
                            ExpectedValue         = $true
                            Property              = 'RIDMasterAvailability'
                            OperationType         = 'eq'
                            PropertyExtendedValue = 'RIDMaster'
                        }
                    }
                    InfrastructureMaster = @{
                        Enable     = $true
                        Name       = 'Infrastructure Master Availability'
                        #  Data     = $Script:SBForestRolesTest2
                        Parameters = @{
                            ExpectedValue         = $true
                            Property              = 'InfrastructureMasterAvailability'
                            OperationType         = 'eq'
                            PropertyExtendedValue = 'InfrastructureMaster'
                        }
                    }
                }
            }
            PasswordComplexity               = @{
                Enable = $false
                Source = @{
                    Name       = 'Password Complexity Requirements'
                    Data       = $Script:SBDomainPasswordComplexity
                    Area       = ''
                    Parameters = @{

                    }
                }
                Tests  = [ordered] @{
                    ComplexityEnabled               = @{
                        Enable     = $true
                        Name       = 'Complexity Enabled'
                        #Data     = $Script:SBDomainPasswordComplexityTest1
                        Parameters = @{
                            Property      = 'Complexity Enabled'
                            ExpectedValue = $true
                            OperationType = 'eq'
                        }
                    }
                    'Lockout Duration'              = @{
                        Enable     = $true
                        Name       = 'Lockout Duration'
                        #Data     = $Script:SBDomainPasswordComplexityTest2
                        Parameters = @{
                            Property      = 'Lockout Duration'
                            ExpectedValue = 30
                            OperationType = 'ge'
                        }
                    }
                    'Lockout Observation Window'    = @{
                        Enable     = $true
                        Name       = 'Lockout Observation Window'
                        #Data     = $Script:SBDomainPasswordComplexityTest3
                        Parameters = @{
                            Property      = 'Lockout Observation Window'
                            ExpectedValue = 30
                            OperationType = 'ge'
                        }
                    }
                    'Lockout Threshold'             = @{
                        Enable     = $true
                        Name       = 'Lockout Threshold'
                        #Data     = $Script:SBDomainPasswordComplexityTest4
                        Parameters = @{
                            Property      = 'Lockout Threshold'
                            ExpectedValue = 5
                            OperationType = 'gt'
                        }
                    }
                    'Max Password Age'              = @{
                        Enable     = $true
                        Name       = 'Max Password Age'
                        # Data     = $Script:SBDomainPasswordComplexityTest5
                        Parameters = @{
                            Property      = 'Max Password Age'
                            ExpectedValue = 60
                            OperationType = 'le'
                        }
                    }
                    'Min Password Length'           = @{
                        Enable     = $true
                        Name       = 'Min Password Length'
                        #Data     = $Script:SBDomainPasswordComplexityTest6
                        Parameters = @{
                            Property      = 'Min Password Length'
                            ExpectedValue = 8
                            OperationType = 'gt'
                        }
                    }
                    'Min Password Age'              = @{
                        Enable     = $true
                        Name       = 'Min Password Age'
                        # Data     = $Script:SBDomainPasswordComplexityTest7
                        Parameters = @{
                            Property      = 'Min Password Age'
                            ExpectedValue = 1
                            OperationType = 'le'
                        }
                    }
                    'Password History Count'        = @{
                        Enable     = $true
                        Name       = 'Password History Count'
                        # Data     = $Script:SBDomainPasswordComplexityTest8
                        Parameters = @{
                            Property      = 'Password History Count'
                            ExpectedValue = 10
                            OperationType = 'ge'
                        }
                    }
                    'Reversible Encryption Enabled' = @{
                        Enable     = $true
                        Name       = 'Reversible Encryption Enabled'
                        # Data     = $Script:SBDomainPasswordComplexityTest9
                        Parameters = @{
                            Property      = 'Reversible Encryption Enabled'
                            ExpectedValue = $true
                            OperationType = 'eq'
                        }
                    }
                }
            }
            Trusts                           = @{
                Enable = $false
                Source = @{
                    Name       = "Trust Availability"
                    Data       = $Script:SBDomainTrustsData
                    Area       = ''
                    Parameters = @{

                    }
                }
                Tests  = [ordered] @{
                    TrustsConnectivity            = @{
                        Enable = $true
                        Name   = 'Trust status verification'
                        Data   = $Script:SBDomainTrustsConnectivity
                    }
                    TrustsUnconstrainedDelegation = @{
                        Enable = $true
                        Name   = 'Trust Unconstrained TGTDelegation'
                        Data   = $Script:SBDomainTrustsUnconstrainedDelegation
                    }
                }
            }
            DNSScavengingForPrimaryDNSServer = @{
                Enable = $false
                Source = @{
                    Name       = "DNS Scavenging - Primary DNS Server"
                    Data       = $Script:SBDomainDnsScavenging
                    Area       = ''
                    Parameters = @{

                    }
                }
                Tests  = [ordered] @{
                    ScavengingCount      = @{
                        Enable      = $true
                        Name        = 'Scavenging DNS Servers Count'
                        #Data     = $Script:SBDomainDnsScavengingTest0
                        Parameters  = @{
                            ExpectedCount = 1
                            OperationType = 'eq'
                        }
                        Explanation = 'Scavenging Count should be 1. There should be 1 DNS server per domain responsible for scavenging. If this returns false, every other test fails.'
                    }
                    ScavengingInterval   = @{
                        Enable     = $true
                        Name       = 'Scavenging Interval'
                        # Data     = $Script:SBDomainDnsScavengingTest1
                        Parameters = @{
                            Property      = 'ScavengingInterval', 'Days'
                            ExpectedValue = 7
                            OperationType = 'le'
                        }
                    }
                    'Scavenging State'   = @{
                        Enable                 = $true
                        Name                   = 'Scavenging State'
                        #Data             = $Script:SBDomainDnsScavengingTest2
                        Parameters             = @{
                            Property      = 'ScavengingState'
                            ExpectedValue = $true
                            OperationType = 'eq'
                        }
                        Explanation            = 'Scavenging State is responsible for enablement of scavenging for all new zones created.'
                        RecommendedValue       = $true
                        ExplanationRecommended = 'It should be enabled so all new zones are subject to scavanging.'
                        DefaultValue           = $false
                    }
                    'Last Scavenge Time' = @{
                        Enable     = $true
                        Name       = 'Last Scavenge Time'
                        #Data     = $Script:SBDomainDnsScavengingTest3
                        Parameters = @{
                            # this date should be the same as in Scavending Interval
                            Property      = 'LastScavengeTime'
                            ExpectedValue = (Get-Date).AddDays(-7)
                            OperationType = 'lt'
                        }
                    }
                }
            }
            DNSForwaders                     = @{
                Enable = $false
                Source = @{
                    Name       = "DNS Forwarders"
                    Data       = $Script:SBDomainDNSForwaders
                    Area       = ''
                    Parameters = @{

                    }
                }
                Tests  = [ordered] @{
                    SameForwarders = @{
                        Enable      = $true
                        Name        = 'Same DNS Forwarders'
                        # Data     = $Script:SBDomainDNSForwadersTest
                        Parameters  = @{
                            Property              = 'Status'
                            ExpectedValue         = $true
                            OperationType         = 'eq'
                            PropertyExtendedValue = 'Source'
                        }
                        Explanation = 'DNS forwarders within one domain should have identical setup'
                    }
                }
            }
            DnsZonesAging                    = @{
                Enable = $false
                Source = @{
                    Name       = "Aging primary DNS Zone"
                    Data       = $Script:SBDomainDnsZones
                    Area       = ''
                    Parameters = @{

                    }
                }
                Tests  = [ordered] @{
                    EnabledAgingEnabled   = @{
                        Enable      = $true
                        Name        = 'Zone DNS aging should be enabled'
                        # Data     = $Script:SBDomainDnsZonesTestEnabled
                        Parameters  = @{
                            Property      = 'Source'
                            ExpectedValue = $true
                            OperationType = 'eq'
                        }
                        Explanation = 'Primary DNS zone should have aging enabled.'
                    }
                    EnabledAgingIdentical = @{
                        Enable      = $true
                        Name        = 'Zone DNS aging should be identical on all DCs'
                        #Data     = $Script:SBDomainDnsZonesTestIdentical
                        Parameters  = @{
                            Property      = 'Status'
                            ExpectedValue = $true
                            OperationType = 'eq'
                        }
                        Explanation = 'Primary DNS zone should have aging enabled, on all DNS servers.'
                    }
                }
            }
        }
    }
    DomainControllers = @{
        Sources = [ordered] @{
            OperatingSystem             = @{
                Enable = $true
                Source = @{
                    Name       = 'Operating System'
                    Data       = $Script:ComputerOperatingSystem
                    Area       = ''
                    Parameters = @{

                    }
                }
                Tests  = [ordered] @{
                    OperatingSystem = @{
                        Enable     = $true
                        Name       = 'Operating system higher than 2012'
                        Parameters = @{
                            Property              = 'OperatingSystem'
                            ExpectedValue         = 'Microsoft Windows Server 2019*', 'Microsoft Windows Server 2016*', 'Microsoft Windows Server 2012*'
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

            RespondsToPowerShellQueries = @{
                Enable = $false
                Source = @{
                    Name       = "Responds to PowerShell Queries"
                    Data       = $Script:SBDomainControllersRespondsPS
                    Area       = ''
                    Parameters = @{

                    }
                }
                # When there are no tests only one test is done - whether data is returned or not.
            }
            Services                    = @{
                Enable = $false
                Source = @{
                    Name       = 'Service Status'
                    Data       = $Script:SBDomainControllersServices
                    Area       = ''
                    Parameters = @{

                    }
                }
                Tests  = [ordered] @{
                    ServiceStatus    = @{
                        Enable     = $true
                        Name       = 'Service is RUNNING'
                        Data       = $Script:SBDomainControllersServicesTestStatus
                        Parameters = @{
                            ExpectedValue = 'Running'
                            OperationType = 'eq'
                        }

                    }
                    ServiceStartType = @{
                        Enable     = $true
                        Name       = 'Service START TYPE is Automatic'
                        Data       = $Script:SBDomainControllersServicesTestStartType
                        Parameters = @{
                            ExpectedValue = 'Automatic'
                            OperationType = 'eq'
                        }
                    }
                }
            }

            LDAP                        = @{
                Enable = $false
                Source = @{
                    Name       = 'LDAP Connectivity'
                    Data       = $Script:SBDomainControllersLDAP
                    Area       = ''
                    Parameters = @{

                    }
                }
                Tests  = [ordered] @{
                    PortLDAP     = @{
                        Enable     = $true
                        Name       = 'LDAP Port is Available'
                        #Data     = $Script:SBDomainControllersLDAP_Port
                        Parameters = @{
                            Property      = 'LDAP'
                            ExpectedValue = $true
                            OperationType = 'eq'
                        }
                    }
                    PortLDAPS    = @{
                        Enable     = $true
                        Name       = 'LDAP SSL Port is Available'
                        # Data     = $Script:SBDomainControllersLDAP_PortSSL
                        Parameters = @{
                            Property      = 'LDAPS'
                            ExpectedValue = $true
                            OperationType = 'eq'
                        }
                    }
                    PortLDAP_GC  = @{
                        Enable     = $true
                        Name       = 'LDAP GC Port is Available'
                        #Data     = $Script:SBDomainControllersLDAP_PortGC
                        Parameters = @{
                            Property      = 'GlobalCatalogLDAP'
                            ExpectedValue = $true
                            OperationType = 'eq'
                        }
                    }
                    PortLDAPS_GC = @{
                        Enable     = $true
                        Name       = 'LDAP SSL GC Port is Available'
                        #Data     = $Script:SBDomainControllersLDAP_PortGC_SSL
                        Parameters = @{
                            Property      = 'GlobalCatalogLDAPS'
                            ExpectedValue = $true
                            OperationType = 'eq'
                        }
                    }
                }

            }
            Pingable                    = @{
                Enable = $false
                Source = @{
                    Name       = 'Ping Connectivity'
                    Data       = $Script:SBDomainControllersPing
                    Area       = ''
                    Parameters = @{

                    }
                }
                Tests  = @{
                    Ping = @{
                        Enable     = $true
                        Name       = 'Responding to PING'
                        #Data     = $Script:SBDomainControllersPingTest
                        Parameters = @{
                            Property              = 'PingSucceeded'
                            PropertyExtendedValue = 'PingReplyDetails', 'RoundtripTime'
                            ExpectedValue         = $true
                            OperationType         = 'eq'
                        }
                    }
                }
            }
            Port53                      = @{
                Enable = $false
                Source = @{
                    Name       = 'PORT 53 (DNS)'
                    Data       = $Script:SBDomainControllersPort53
                    Area       = ''
                    Parameters = @{

                    }
                }
                Tests  = @{
                    Ping = @{
                        Enable     = $true
                        Name       = 'Port is OPEN'
                        #Data     = $Script:SBDomainControllersPort53Test
                        Parameters = @{
                            Property      = 'TcpTestSucceeded'
                            ExpectedValue = $true
                            OperationType = 'eq'
                        }
                    }
                }
            }
            DiskSpace                   = @{
                Enable = $false
                Source = @{
                    Name       = 'Disk Free'
                    Data       = $Script:SBDomainControllersDiskSpace
                    Area       = ''
                    Parameters = @{

                    }
                }
                Tests  = @{
                    FreeSpace   = @{
                        Enable     = $true
                        Name       = 'Free Space in GB'
                        # Data     = $Script:SBDomainControllersDiskSpaceGB
                        Parameters = @{
                            Property              = 'FreeSpace'
                            PropertyExtendedValue = 'FreeSpace'
                            ExpectedValue         = 10
                            OperationType         = 'gt'
                        }
                    }
                    FreePercent = @{
                        Enable     = $true
                        Name       = 'Free Space Percent'
                        # Data     = $Script:SBDomainControllersDiskSpacePercent
                        Parameters = @{
                            Property              = 'FreePercent'
                            PropertyExtendedValue = 'FreePercent'
                            ExpectedValue         = 10
                            OperationType         = 'gt'
                        }
                    }
                }
            }
            TimeSynchronizationInternal = @{
                Enable             = $false
                Source             = @{
                    Name       = "Time Synchronization Internal"
                    Data       = $Script:SBDomainTimeSynchronizationInternal
                    Area       = ''
                    Parameters = @{

                    }
                }
                Tests              = [ordered] @{
                    TimeSynchronizationTest = @{
                        Enable     = $true
                        Name       = 'Time Difference'
                        # Data     = $Script:SBDomainTimeSynchronizationTest1
                        Parameters = @{
                            Property              = 'TimeDifferenceSeconds'
                            ExpectedValue         = 1
                            OperationType         = 'le'
                            PropertyExtendedValue = 'TimeDifferenceSeconds'
                        }
                    }
                }
                MicrosoftMaterials = 'https://docs.microsoft.com/en-us/previous-versions/windows/it-pro/windows-server-2003/cc773263(v=ws.10)#w2k3tr_times_tools_uhlp'
            }
            TimeSynchronizationExternal = @{
                Enable             = $false
                Source             = @{
                    Name       = "Time Synchronization External"
                    Data       = $Script:SBDomainTimeSynchronizationExternal
                    Area       = ''
                    Parameters = @{

                    }
                }
                Tests              = [ordered] @{
                    TimeSynchronizationTest = @{
                        Enable     = $true
                        Name       = 'Time Difference'
                        #  Data     = $Script:SBDomainTimeSynchronizationTest1
                        Parameters = @{
                            Property              = 'TimeDifferenceSeconds'
                            ExpectedValue         = 1
                            OperationType         = 'le'
                            PropertyExtendedValue = 'TimeDifferenceSeconds'
                        }
                    }
                }
                MicrosoftMaterials = 'https://docs.microsoft.com/en-us/previous-versions/windows/it-pro/windows-server-2003/cc773263(v=ws.10)#w2k3tr_times_tools_uhlp'
            }
            WindowsFirewall             = @{
                Enable = $false
                Source = @{
                    Name        = "Windows Firewall"
                    Data        = $Script:SBDomainControllersFirewall
                    Area        = 'Connectivity'
                    Description = 'Verify windows firewall is enabled for all network cards'
                    Parameters  = @{

                    }
                }
                Tests  = [ordered] @{
                    TimeSynchronizationTest = @{
                        Enable     = $true
                        Name       = 'Windows Firewall is enabled on network card'
                        #  Data     = $Script:SBDomainTimeSynchronizationTest1
                        Parameters = @{
                            Property              = 'FirewallStatus'
                            ExpectedValue         = $true
                            OperationType         = 'eq'
                            PropertyExtendedValue = 'FirewallProfile'
                        }
                    }
                }
            }
        }
    }
    AnyServers        = @{
        Sources = [ordered] @{
            Services = @{
                Enable = $false
                Source = @{
                    Name       = 'Service Status'
                    Data       = $Script:SBDomainControllersServices
                    Parameters = @{

                    }
                }
                Tests  = [ordered] @{
                    ServiceStatus    = @{
                        Enable     = $true
                        Name       = 'Service is RUNNING'
                        Data       = $Script:SBDomainControllersServicesTestStatus
                        Parameters = @{
                            ExpectedValue = 'Running'
                            OperationType = 'eq'
                        }

                    }
                    ServiceStartType = @{
                        Enable     = $true
                        Name       = 'Service START TYPE is Automatic'
                        Data       = $Script:SBDomainControllersServicesTestStartType
                        Parameters = @{
                            ExpectedValue = 'Automatic'
                            OperationType = 'eq'
                        }
                    }
                }
            }
        }
    }
    Debug             = @{
        ShowErrors = $false
    }
}