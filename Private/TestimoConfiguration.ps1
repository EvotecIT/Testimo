$Script:TestimoConfiguration = [ordered] @{
    Exclusions        = @{
        # Domains           = 'ad.evotec.pl'
        # DomainControllers = 'AD3.ad.evotec.xyz'
    }
    Forest            = @{
        Sources = [ordered]  @{
            OptionalFeatures = @{
                Enable     = $true
                SourceName = 'Optional Features'
                SourceData = $Script:SBForestOptionalFeatures
                Tests      = [ordered] @{
                    RecycleBinEnabled    = @{
                        Enable         = $true
                        TestName       = 'Recycle Bin Enabled'
                        # TestSource     = $Script:SBForestOptionalFeaturesTest1
                        TestParameters = @{
                            Property      = 'Recycle Bin Enabled'
                            ExpectedValue = $true
                            OperationType = 'eq'
                        }
                    }
                    LapsAvailable        = @{
                        Enable         = $true
                        TestName       = 'LAPS Schema Extended'
                        # TestSource     = $Script:SBForestOptionalFeaturesTest2
                        TestParameters = @{
                            Property      = 'Laps Enabled'
                            ExpectedValue = $true
                            OperationType = 'eq'
                        }
                    }
                    PrivAccessManagement = @{
                        Enable         = $true
                        TestName       = 'Privileged Access Management Enabled'
                        #  TestSource     = $Script:SBForestOptionalFeaturesTest3
                        TestParameters = @{
                            Property      = 'Privileged Access Management Feature Enabled'
                            ExpectedValue = $true
                            OperationType = 'eq'
                        }
                    }
                }
            }
            Replication      = @{
                Enable     = $false
                SourceName = 'Forest Replication'
                SourceData = $Script:SBForestReplication
                Tests      = [ordered] @{
                    ReplicationTests = @{
                        Enable         = $true
                        TestName       = 'Replication Test'
                        TestSource     = $Script:SBForestReplicationTest1
                        TestParameters = @{
                            #ExpectedValue        = $true
                            OperationType = 'eq'
                            #PropertyExtendedValue = 'StatusMessage'
                        }
                    }
                }
            }
            LastBackup       = @{
                Enable     = $false
                SourceName = 'Forest Backup'
                SourceData = $Script:SBForestLastBackup
                Tests      = [ordered] @{
                    LastBackupTests = @{
                        Enable         = $true
                        TestName       = 'Forest Last Backup Time - Context'
                        TestSource     = $Script:SBForestLastBackupTest
                        TestParameters = @{
                            #ExpectedValue        = $true
                            #OperationType = 'eq'
                            #PropertyExtendedValue = 'StatusMessage'
                        }
                    }
                }
            }
            Sites            = @{
                Enable     = $false
                SourceName = 'Sites Verification'
                SourceData = $Script:SBForestSites
                Area       = 'Sites'
                Tests      = [ordered] @{
                    SitesWithoutDC      = @{
                        Enable         = $true
                        TestName       = 'Sites without Domain Controllers'
                        #TestSource     = $Script:SBForestSitesTest1
                        Description    = 'Verify each `site has at least [one subnet configured]`'
                        TestParameters = @{
                            Property      = 'SitesWithoutDC'
                            ExpectedValue = 0
                            OperationType = 'eq'
                            #PropertyExtendedValue = 'SitesWithoutDCName'
                        }
                    }
                    SitesWithoutSubnets = @{
                        Enable         = $true
                        TestName       = 'Sites without Subnets'
                        #TestSource     = $Script:SBForestSitesTest2
                        TestParameters = @{
                            Property      = 'SitesWithoutSubnets'
                            ExpectedValue = 0
                            OperationType = 'eq'
                            #PropertyExtendedValue = 'SitesWithoutSubnetsName'
                        }
                    }
                }
            }
            Roles            = @{
                Enable     = $false
                SourceName = 'Roles availability'
                SourceData = $Script:SBForestRoles
                Tests      = [ordered] @{
                    SchemaMasterAvailability       = @{
                        Enable         = $true
                        TestName       = 'Schema Master Availability'
                        #TestSource     = $Script:SBForestRolesTest
                        TestParameters = @{
                            ExpectedValue         = $true
                            Property              = 'SchemaMasterAvailability'
                            OperationType         = 'eq'
                            PropertyExtendedValue = 'SchemaMaster'
                        }
                    }
                    DomainNamingMasterAvailability = @{
                        Enable         = $true
                        TestName       = 'Domain Master Availability'
                        #TestSource     = $Script:SBForestRolesTest2
                        TestParameters = @{
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
                Enable     = $false
                SourceName = 'Roles availability'
                SourceData = $Script:SBDomainRoles
                Tests      = [ordered] @{
                    PDCEmulator          = @{
                        Enable         = $true
                        TestName       = 'PDC Emulator Availability'
                        # TestSource     = $Script:SBForestRolesTest
                        TestParameters = @{
                            ExpectedValue         = $true
                            Property              = 'PDCEmulatorAvailability'
                            OperationType         = 'eq'
                            PropertyExtendedValue = 'PDCEmulator'
                        }
                    }
                    RIDMaster            = @{
                        Enable         = $true
                        TestName       = 'RID Master Availability'
                        #  TestSource     = $Script:SBForestRolesTest2
                        TestParameters = @{
                            ExpectedValue         = $true
                            Property              = 'RIDMasterAvailability'
                            OperationType         = 'eq'
                            PropertyExtendedValue = 'RIDMaster'
                        }
                    }
                    InfrastructureMaster = @{
                        Enable         = $true
                        TestName       = 'Infrastructure Master Availability'
                        #  TestSource     = $Script:SBForestRolesTest2
                        TestParameters = @{
                            ExpectedValue         = $true
                            Property              = 'InfrastructureMasterAvailability'
                            OperationType         = 'eq'
                            PropertyExtendedValue = 'InfrastructureMaster'
                        }
                    }
                }
            }
            PasswordComplexity               = @{
                Enable     = $false
                SourceName = 'Password Complexity Requirements'
                SourceData = $Script:SBDomainPasswordComplexity
                Tests      = [ordered] @{
                    ComplexityEnabled               = @{
                        Enable         = $true
                        TestName       = 'Complexity Enabled'
                        #TestSource     = $Script:SBDomainPasswordComplexityTest1
                        TestParameters = @{
                            Property      = 'Complexity Enabled'
                            ExpectedValue = $true
                            OperationType = 'eq'
                        }
                    }
                    'Lockout Duration'              = @{
                        Enable         = $true
                        TestName       = 'Lockout Duration'
                        #TestSource     = $Script:SBDomainPasswordComplexityTest2
                        TestParameters = @{
                            Property      = 'Lockout Duration'
                            ExpectedValue = 30
                            OperationType = 'ge'
                        }
                    }
                    'Lockout Observation Window'    = @{
                        Enable         = $true
                        TestName       = 'Lockout Observation Window'
                        #TestSource     = $Script:SBDomainPasswordComplexityTest3
                        TestParameters = @{
                            Property      = 'Lockout Observation Window'
                            ExpectedValue = 30
                            OperationType = 'ge'
                        }
                    }
                    'Lockout Threshold'             = @{
                        Enable         = $true
                        TestName       = 'Lockout Threshold'
                        #TestSource     = $Script:SBDomainPasswordComplexityTest4
                        TestParameters = @{
                            Property      = 'Lockout Threshold'
                            ExpectedValue = 5
                            OperationType = 'gt'
                        }
                    }
                    'Max Password Age'              = @{
                        Enable         = $true
                        TestName       = 'Max Password Age'
                        # TestSource     = $Script:SBDomainPasswordComplexityTest5
                        TestParameters = @{
                            Property      = 'Max Password Age'
                            ExpectedValue = 60
                            OperationType = 'le'
                        }
                    }
                    'Min Password Length'           = @{
                        Enable         = $true
                        TestName       = 'Min Password Length'
                        #TestSource     = $Script:SBDomainPasswordComplexityTest6
                        TestParameters = @{
                            Property      = 'Min Password Length'
                            ExpectedValue = 8
                            OperationType = 'gt'
                        }
                    }
                    'Min Password Age'              = @{
                        Enable         = $true
                        TestName       = 'Min Password Age'
                        # TestSource     = $Script:SBDomainPasswordComplexityTest7
                        TestParameters = @{
                            Property      = 'Min Password Age'
                            ExpectedValue = 1
                            OperationType = 'le'
                        }
                    }
                    'Password History Count'        = @{
                        Enable         = $true
                        TestName       = 'Password History Count'
                        # TestSource     = $Script:SBDomainPasswordComplexityTest8
                        TestParameters = @{
                            Property      = 'Password History Count'
                            ExpectedValue = 10
                            OperationType = 'ge'
                        }
                    }
                    'Reversible Encryption Enabled' = @{
                        Enable         = $true
                        TestName       = 'Reversible Encryption Enabled'
                        # TestSource     = $Script:SBDomainPasswordComplexityTest9
                        TestParameters = @{
                            Property      = 'Reversible Encryption Enabled'
                            ExpectedValue = $true
                            OperationType = 'eq'
                        }
                    }
                }
            }
            Trusts                           = @{
                Enable     = $true
                SourceName = "Trust Availability"
                SourceData = $Script:SBDomainTrustsData
                Tests      = [ordered] @{
                    TrustsConnectivity            = @{
                        Enable     = $true
                        TestName   = 'Trust status verification'
                        TestSource = $Script:SBDomainTrustsConnectivity
                    }
                    TrustsUnconstrainedDelegation = @{
                        Enable     = $true
                        TestName   = 'Trust Unconstrained TGTDelegation'
                        TestSource = $Script:SBDomainTrustsUnconstrainedDelegation
                    }
                }
            }
            DNSScavengingForPrimaryDNSServer = @{
                Enable     = $false
                SourceName = "DNS Scavenging - Primary DNS Server"
                SourceData = $Script:SBDomainDnsScavenging
                Tests      = [ordered] @{
                    ScavengingCount      = @{
                        Enable         = $true
                        TestName       = 'Scavenging DNS Servers Count'
                        #TestSource     = $Script:SBDomainDnsScavengingTest0
                        TestParameters = @{
                            ExpectedCount = 1
                            OperationType = 'eq'
                        }
                        Explanation    = 'Scavenging Count should be 1. There should be 1 DNS server per domain responsible for scavenging. If this returns false, every other test fails.'
                    }
                    ScavengingInterval   = @{
                        Enable         = $true
                        TestName       = 'Scavenging Interval'
                        # TestSource     = $Script:SBDomainDnsScavengingTest1
                        TestParameters = @{
                            Property      = 'ScavengingInterval', 'Days'
                            ExpectedValue = 7
                            OperationType = 'le'
                        }
                    }
                    'Scavenging State'   = @{
                        Enable                 = $true
                        TestName               = 'Scavenging State'
                        #TestSource             = $Script:SBDomainDnsScavengingTest2
                        TestParameters         = @{
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
                        Enable         = $true
                        TestName       = 'Last Scavenge Time'
                        #TestSource     = $Script:SBDomainDnsScavengingTest3
                        TestParameters = @{
                            # this date should be the same as in Scavending Interval
                            Property      = 'LastScavengeTime'
                            ExpectedValue = (Get-Date).AddDays(-7)
                            OperationType = 'lt'
                        }
                    }
                }
            }
            DNSForwaders                     = @{
                Enable     = $true
                SourceName = "DNS Forwarders"
                SourceData = $Script:SBDomainDNSForwaders
                Tests      = [ordered] @{
                    SameForwarders = @{
                        Enable         = $true
                        TestName       = 'Same DNS Forwarders'
                        # TestSource     = $Script:SBDomainDNSForwadersTest
                        TestParameters = @{
                            Property              = 'Status'
                            ExpectedValue         = $true
                            OperationType         = 'eq'
                            PropertyExtendedValue = 'Source'
                        }
                        Explanation    = 'DNS forwarders within one domain should have identical setup'
                    }
                }
            }
            DnsZonesAging                    = @{
                Enable     = $false
                SourceName = "Aging primary DNS Zone"
                SourceData = $Script:SBDomainDnsZones
                Tests      = [ordered] @{
                    EnabledAgingEnabled   = @{
                        Enable         = $true
                        TestName       = 'Zone DNS aging should be enabled'
                        # TestSource     = $Script:SBDomainDnsZonesTestEnabled
                        TestParameters = @{
                            Property      = 'Source'
                            ExpectedValue = $true
                            OperationType = 'eq'
                        }
                        Explanation    = 'Primary DNS zone should have aging enabled.'
                    }
                    EnabledAgingIdentical = @{
                        Enable         = $true
                        TestName       = 'Zone DNS aging should be identical on all DCs'
                        #TestSource     = $Script:SBDomainDnsZonesTestIdentical
                        TestParameters = @{
                            Property      = 'Status'
                            ExpectedValue = $true
                            OperationType = 'eq'
                        }
                        Explanation    = 'Primary DNS zone should have aging enabled, on all DNS servers.'
                    }
                }
            }
        }
    }
    DomainControllers = @{
        Sources = [ordered] @{
            RespondsToPowerShellQueries = @{
                Enable     = $false
                SourceName = "Responds to PowerShell Queries"
                SourceData = $Script:SBDomainControllersRespondsPS
                # When there are no tests only one test is done - whether data is returned or not.
            }
            Services                    = @{
                Enable     = $false
                SourceName = 'Service Status'
                SourceData = $Script:SBDomainControllersServices
                Tests      = [ordered] @{
                    ServiceStatus    = @{
                        Enable         = $true
                        TestName       = 'Service is RUNNING'
                        TestSource     = $Script:SBDomainControllersServicesTestStatus
                        TestParameters = @{
                            ExpectedValue = 'Running'
                            OperationType = 'eq'
                        }

                    }
                    ServiceStartType = @{
                        Enable         = $true
                        TestName       = 'Service START TYPE is Automatic'
                        TestSource     = $Script:SBDomainControllersServicesTestStartType
                        TestParameters = @{
                            ExpectedValue = 'Automatic'
                            OperationType = 'eq'
                        }
                    }
                }
            }

            LDAP                        = @{
                Enable     = $true
                SourceName = 'LDAP Connectivity'
                SourceData = $Script:SBDomainControllersLDAP
                Tests      = [ordered] @{
                    PortLDAP     = @{
                        Enable         = $true
                        TestName       = 'LDAP Port is Available'
                        #TestSource     = $Script:SBDomainControllersLDAP_Port
                        TestParameters = @{
                            Property      = 'LDAP'
                            ExpectedValue = $true
                            OperationType = 'eq'
                        }
                    }
                    PortLDAPS    = @{
                        Enable         = $true
                        TestName       = 'LDAP SSL Port is Available'
                        # TestSource     = $Script:SBDomainControllersLDAP_PortSSL
                        TestParameters = @{
                            Property      = 'LDAPS'
                            ExpectedValue = $true
                            OperationType = 'eq'
                        }
                    }
                    PortLDAP_GC  = @{
                        Enable         = $true
                        TestName       = 'LDAP GC Port is Available'
                        #TestSource     = $Script:SBDomainControllersLDAP_PortGC
                        TestParameters = @{
                            Property      = 'GlobalCatalogLDAP'
                            ExpectedValue = $true
                            OperationType = 'eq'
                        }
                    }
                    PortLDAPS_GC = @{
                        Enable         = $true
                        TestName       = 'LDAP SSL GC Port is Available'
                        #TestSource     = $Script:SBDomainControllersLDAP_PortGC_SSL
                        TestParameters = @{
                            Property      = 'GlobalCatalogLDAPS'
                            ExpectedValue = $true
                            OperationType = 'eq'
                        }
                    }
                }

            }
            Pingable                    = @{
                Enable     = $false
                SourceName = 'Ping Connectivity'
                SourceData = $Script:SBDomainControllersPing
                Tests      = @{
                    Ping = @{
                        Enable         = $true
                        TestName       = 'Responding to PING'
                        #TestSource     = $Script:SBDomainControllersPingTest
                        TestParameters = @{
                            Property              = 'PingSucceeded'
                            PropertyExtendedValue = 'PingReplyDetails', 'RoundtripTime'
                            ExpectedValue         = $true
                            OperationType         = 'eq'
                        }
                    }
                }
            }
            Port53                      = @{
                Enable     = $false
                SourceName = 'PORT 53 (DNS)'
                SourceData = $Script:SBDomainControllersPort53
                Tests      = @{
                    Ping = @{
                        Enable         = $true
                        TestName       = 'Port is OPEN'
                        #TestSource     = $Script:SBDomainControllersPort53Test
                        TestParameters = @{
                            Property      = 'TcpTestSucceeded'
                            ExpectedValue = $true
                            OperationType = 'eq'
                        }
                    }
                }
            }
            DiskSpace                   = @{
                Enable     = $false
                SourceName = 'Disk Free'
                SourceData = $Script:SBDomainControllersDiskSpace
                Tests      = @{
                    FreeSpace   = @{
                        Enable         = $true
                        TestName       = 'Free Space in GB'
                        # TestSource     = $Script:SBDomainControllersDiskSpaceGB
                        TestParameters = @{
                            Property              = 'FreeSpace'
                            PropertyExtendedValue = 'FreeSpace'
                            ExpectedValue         = 10
                            OperationType         = 'gt'
                        }
                    }
                    FreePercent = @{
                        Enable         = $true
                        TestName       = 'Free Space Percent'
                        # TestSource     = $Script:SBDomainControllersDiskSpacePercent
                        TestParameters = @{
                            Property              = 'FreePercent'
                            PropertyExtendedValue = 'FreePercent'
                            ExpectedValue         = 10
                            OperationType         = 'gt'
                        }
                    }
                }
            }
            TimeSynchronizationInternal = @{
                Enable             = $true
                SourceName         = "Time Synchronization Internal"
                SourceData         = $Script:SBDomainTimeSynchronizationInternal
                Tests              = [ordered] @{
                    TimeSynchronizationTest = @{
                        Enable         = $true
                        TestName       = 'Time Difference'
                        # TestSource     = $Script:SBDomainTimeSynchronizationTest1
                        TestParameters = @{
                            Property      = 'TimeDifferenceSeconds'
                            ExpectedValue = 1
                            OperationType = 'le'
                            PropertyExtendedValue = 'TimeDifferenceSeconds'
                        }
                    }
                }
                MicrosoftMaterials = 'https://docs.microsoft.com/en-us/previous-versions/windows/it-pro/windows-server-2003/cc773263(v=ws.10)#w2k3tr_times_tools_uhlp'
            }
            TimeSynchronizationExternal = @{
                Enable             = $true
                SourceName         = "Time Synchronization External"
                SourceData         = $Script:SBDomainTimeSynchronizationExternal
                Tests              = [ordered] @{
                    TimeSynchronizationTest = @{
                        Enable         = $true
                        TestName       = 'Time Difference'
                        #  TestSource     = $Script:SBDomainTimeSynchronizationTest1
                        TestParameters = @{
                            Property              = 'TimeDifferenceSeconds'
                            ExpectedValue         = 1
                            OperationType         = 'le'
                            PropertyExtendedValue = 'TimeDifferenceSeconds'
                        }
                    }
                }
                MicrosoftMaterials = 'https://docs.microsoft.com/en-us/previous-versions/windows/it-pro/windows-server-2003/cc773263(v=ws.10)#w2k3tr_times_tools_uhlp'
            }
        }
    }
    AnyServers        = @{
        Sources = [ordered] @{
            Services = @{
                Enable     = $false
                SourceName = 'Service Status'
                SourceData = $Script:SBDomainControllersServices
                Tests      = [ordered] @{
                    ServiceStatus    = @{
                        Enable         = $true
                        TestName       = 'Service is RUNNING'
                        TestSource     = $Script:SBDomainControllersServicesTestStatus
                        TestParameters = @{
                            ExpectedValue = 'Running'
                            OperationType = 'eq'
                        }

                    }
                    ServiceStartType = @{
                        Enable         = $true
                        TestName       = 'Service START TYPE is Automatic'
                        TestSource     = $Script:SBDomainControllersServicesTestStartType
                        TestParameters = @{
                            ExpectedValue = 'Automatic'
                            OperationType = 'eq'
                        }
                    }
                }
            }
        }
    }
    Debug             = @{
        DisableTryCatch = $false
    }
}