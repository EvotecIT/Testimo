$Script:TestimoConfiguration = [ordered] @{
    Exclusions        = [ordered] @{
        #Domains = 'ad.evotec.pl'
        #DomainControllers = 'AD3.ad.evotec.xyz'
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
        DomainFSMORoles                    = $DomainFSMORoles
        WellKnownFolders                   = @{
            Enable = $false
            Source = @{
                Name       = 'Well known folders'
                Data       = $Script:SBDomainWellKnownFolders
                Area       = ''
                Parameters = @{

                }
            }
            Tests  = [ordered] @{
                UsersContainer                     = @{
                    Enable     = $true
                    Name       = "Users Container shouldn't be at default"
                    Parameters = @{
                        WhereObject           = { $_.Name -eq 'UsersContainer' }
                        ExpectedValue         = $false
                        Property              = 'Status'
                        OperationType         = 'eq'
                        PropertyExtendedValue = '1'
                    }
                }
                ComputersContainer                 = @{
                    Enable     = $true
                    Name       = "Computers Container shouldn't be at default"
                    Parameters = @{
                        WhereObject           = { $_.Name -eq 'ComputersContainer' }
                        ExpectedValue         = $false
                        Property              = 'Status'
                        OperationType         = 'eq'
                        PropertyExtendedValue = '1'
                    }
                }
                DomainControllersContainer         = @{
                    Enable     = $true
                    Name       = "Domain Controllers Container should be at default location"
                    Parameters = @{
                        WhereObject           = { $_.Name -eq 'DomainControllersContainer' }
                        ExpectedValue         = $true
                        Property              = 'Status'
                        OperationType         = 'eq'
                        PropertyExtendedValue = '1'
                    }
                }
                DeletedObjectsContainer            = @{
                    Enable     = $true
                    Name       = "Deleted Objects Container should be at default location"
                    Parameters = @{
                        WhereObject           = { $_.Name -eq 'DeletedObjectsContainer' }
                        ExpectedValue         = $true
                        Property              = 'Status'
                        OperationType         = 'eq'
                        PropertyExtendedValue = '1'
                    }
                }
                SystemsContainer                   = @{
                    Enable     = $true
                    Name       = "Systems Container should be at default location"
                    Parameters = @{
                        WhereObject           = { $_.Name -eq 'SystemsContainer' }
                        ExpectedValue         = $true
                        Property              = 'Status'
                        OperationType         = 'eq'
                        PropertyExtendedValue = '1'
                    }
                }
                LostAndFoundContainer              = @{
                    Enable     = $true
                    Name       = "Lost And Found Container should be at default location"
                    Parameters = @{
                        WhereObject           = { $_.Name -eq 'LostAndFoundContainer' }
                        ExpectedValue         = $true
                        Property              = 'Status'
                        OperationType         = 'eq'
                        PropertyExtendedValue = '1'
                    }
                }
                QuotasContainer                    = @{
                    Enable     = $true
                    Name       = "Quotas Container shouldn be at default location"
                    Parameters = @{
                        WhereObject           = { $_.Name -eq 'QuotasContainer' }
                        ExpectedValue         = $true
                        Property              = 'Status'
                        OperationType         = 'eq'
                        PropertyExtendedValue = '1'
                    }
                }
                ForeignSecurityPrincipalsContainer = @{
                    Enable     = $true
                    Name       = "Foreign Security Principals Container should be at default location"
                    Parameters = @{
                        WhereObject           = { $_.Name -eq 'ForeignSecurityPrincipalsContainer' }
                        ExpectedValue         = $true
                        Property              = 'Status'
                        OperationType         = 'eq'
                        PropertyExtendedValue = '1'
                    }
                }
            }
        }
        PasswordComplexity                 = $PasswordComplexity
        Trusts                             = $Trusts
        OrphanedForeignSecurityPrincipals  = $OrphanedForeignSecurityPrincipals
        EmptyOrganizationalUnits           = @{
            Enable = $false
            Source = @{
                Name           = "Orphaned/Empty Organizational Units"
                Data           = $Script:SBDomainEmptyOrganizationalUnits
                Area           = 'Cleanup'
                ExpectedOutput = $false
            }
        }
        DNSScavengingForPrimaryDNSServer   = @{
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
                    Parameters  = @{
                        ExpectedCount = 1
                        OperationType = 'eq'
                    }
                    Explanation = 'Scavenging Count should be 1. There should be 1 DNS server per domain responsible for scavenging. If this returns false, every other test fails.'
                }
                ScavengingInterval   = @{
                    Enable     = $true
                    Name       = 'Scavenging Interval'
                    Parameters = @{
                        Property      = 'ScavengingInterval', 'Days'
                        ExpectedValue = 7
                        OperationType = 'le'
                    }
                }
                'Scavenging State'   = @{
                    Enable                 = $true
                    Name                   = 'Scavenging State'
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
                    Parameters = @{
                        # this date should be the same as in Scavending Interval
                        Property      = 'LastScavengeTime'
                        ExpectedValue = (Get-Date).AddDays(-7)
                        OperationType = 'lt'
                    }
                }
            }
        }
        DNSForwaders                       = @{
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
        DnsZonesAging                      = @{
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
        KerberosAccountAge                 = @{
            Enable = $false
            Source = @{
                Name       = "Kerberos Account Age"
                Data       = $Script:SBKeberosAccountTimeChange
                Area       = ''
                Parameters = @{

                }
            }
            Tests  = [ordered] @{
                EnabledAgingEnabled = @{
                    Enable      = $true
                    Name        = 'Kerberos Last Password Change Should be less than 180 days'
                    Parameters  = @{
                        Property      = 'PasswordLastSet'
                        ExpectedValue = (Get-Date).AddDays(-180)
                        OperationType = 'gt'
                    }
                    Explanation = ''
                }
            }
        }
        SecurityGroupsAccountOperators     = @{
            Enable = $false
            Source = @{
                Name           = "Groups: Account operators should be empty"
                Data           = $Script:SBGroupsAccountOperators
                Area           = ''
                Parameters     = @{

                }
                ExpectedOutput = $false
                Explanation    = "The Account Operators group should not be used. Custom delegate instead. This group is a great 'backdoor' priv group for attackers. Microsoft even says don't use this group!"
            }
        }
        SecurityGroupsSchemaAdmins         = @{
            Enable = $false
            Source = @{
                Name           = "Groups: Schema Admins should be empty"
                Data           = $Script:SBGroupSchemaAdmins
                Area           = ''
                Parameters     = @{

                }
                Requirements   = @{
                    IsDomainRoot = $true
                }
                ExpectedOutput = $false
                Explanation    = "Schema Admins should be empty."
            }
        }
        SecurityUsersAcccountAdministrator = @{
            Enable = $false
            Source = @{
                Name       = "Users: Administrator"
                Data       = $Script:SBUsersAccountAdministrator
                Area       = ''
                Parameters = @{

                }
            }
            Tests  = [ordered] @{
                PasswordLastSet = @{
                    Enable      = $true
                    Name        = 'Administrator Last Password Change Should be less than 360 days ago'
                    Parameters  = @{
                        Property      = 'PasswordLastSet'
                        ExpectedValue = (Get-Date).AddDays(-360)
                        OperationType = 'gt'
                    }
                    Explanation = 'Administrator account should be disabled or LastPasswordChange should be less than 1 year ago.'
                }
            }
        }

    }
    DomainControllers = [ordered] @{

        WindowsRemoteManagement     = @{
            Enable = $false
            Source = @{
                Name       = 'Windows Remote Management'
                Data       = $Script:SBWindowsRemoteManagement
                Area       = ''
                Parameters = @{

                }
            }
            Tests  = [ordered] @{
                OperatingSystem = @{
                    Enable     = $true
                    Name       = 'Test submits an identification request that determines whether the WinRM service is running.'
                    Parameters = @{
                        Property      = 'Status'
                        ExpectedValue = $true
                        OperationType = 'eq'
                    }
                }
            }
        }

        OperatingSystem             = @{
            Enable = $false
            Source = @{
                Name       = 'Operating System'
                Data       = $Script:SBComputerOperatingSystem
                Area       = ''
                Parameters = @{

                }
            }
            Tests  = [ordered] @{
                OperatingSystem = @{
                    Enable     = $true
                    Name       = 'Operating system Windows Server 2012 and up'
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
                ADWSServiceStatus                 = @{
                    Enable     = $true
                    Name       = 'ADWS Service is RUNNING'
                    #Data       = $Script:SBDomainControllersServicesTestStatus
                    Parameters = @{
                        WhereObject   = { $_.Name -eq 'ADWS' }
                        Property      = 'Status'
                        ExpectedValue = 'Running'
                        OperationType = 'eq'
                    }

                }
                ADWSServiceStartType              = @{
                    Enable     = $true
                    Name       = 'ADWS Service START TYPE is Automatic'
                    #Data       = $Script:SBDomainControllersServicesTestStartType
                    Parameters = @{
                        WhereObject   = { $_.Name -eq 'ADWS' }
                        Property      = 'StartType'
                        ExpectedValue = 'Automatic'
                        OperationType = 'eq'
                    }
                }
                DNSServiceStatus                  = @{
                    Enable     = $true
                    Name       = 'DNS Service is RUNNING'
                    #Data       = $Script:SBDomainControllersServicesTestStatus
                    Parameters = @{
                        WhereObject   = { $_.Name -eq 'DNS' }
                        Property      = 'Status'
                        ExpectedValue = 'Running'
                        OperationType = 'eq'
                    }

                }
                DNSServiceStartType               = @{
                    Enable     = $true
                    Name       = 'DNS Service START TYPE is Automatic'
                    #Data       = $Script:SBDomainControllersServicesTestStartType
                    Parameters = @{
                        WhereObject   = { $_.Name -eq 'DNS' }
                        Property      = 'StartType'
                        ExpectedValue = 'Automatic'
                        OperationType = 'eq'
                    }
                }
                DFSServiceStatus                  = @{
                    Enable     = $true
                    Name       = 'DFS Service is RUNNING'
                    #Data       = $Script:SBDomainControllersServicesTestStatus
                    Parameters = @{
                        WhereObject   = { $_.Name -eq 'DFS' }
                        Property      = 'Status'
                        ExpectedValue = 'Running'
                        OperationType = 'eq'
                    }

                }
                DFSServiceStartType               = @{
                    Enable     = $true
                    Name       = 'DFS Service START TYPE is Automatic'
                    #Data       = $Script:SBDomainControllersServicesTestStartType
                    Parameters = @{
                        WhereObject   = { $_.Name -eq 'DFS' }
                        Property      = 'StartType'
                        ExpectedValue = 'Automatic'
                        OperationType = 'eq'
                    }
                }
                DFSRServiceStatus                 = @{
                    Enable     = $true
                    Name       = 'DFSR Service is RUNNING'
                    #Data       = $Script:SBDomainControllersServicesTestStatus
                    Parameters = @{
                        WhereObject   = { $_.Name -eq 'DFSR' }
                        Property      = 'Status'
                        ExpectedValue = 'Running'
                        OperationType = 'eq'
                    }

                }
                DFSRServiceStartType              = @{
                    Enable     = $true
                    Name       = 'DFSR Service START TYPE is Automatic'
                    #Data       = $Script:SBDomainControllersServicesTestStartType
                    Parameters = @{
                        WhereObject   = { $_.Name -eq 'DFSR' }
                        Property      = 'StartType'
                        ExpectedValue = 'Automatic'
                        OperationType = 'eq'
                    }
                }
                EventlogServiceStatus             = @{
                    Enable     = $true
                    Name       = 'Eventlog Service is RUNNING'
                    #Data       = $Script:SBDomainControllersServicesTestStatus
                    Parameters = @{
                        WhereObject   = { $_.Name -eq 'Eventlog' }
                        Property      = 'Status'
                        ExpectedValue = 'Running'
                        OperationType = 'eq'
                    }

                }
                EventlogServiceStartType          = @{
                    Enable     = $true
                    Name       = 'Eventlog Service START TYPE is Automatic'
                    #Data       = $Script:SBDomainControllersServicesTestStartType
                    Parameters = @{
                        WhereObject   = { $_.Name -eq 'Eventlog' }
                        Property      = 'StartType'
                        ExpectedValue = 'Automatic'
                        OperationType = 'eq'
                    }
                }
                EventSystemServiceStatus          = @{
                    Enable     = $true
                    Name       = 'EventSystem Service is RUNNING'
                    #Data       = $Script:SBDomainControllersServicesTestStatus
                    Parameters = @{
                        WhereObject   = { $_.Name -eq 'EventSystem' }
                        Property      = 'Status'
                        ExpectedValue = 'Running'
                        OperationType = 'eq'
                    }

                }
                EventSystemServiceStartType       = @{
                    Enable     = $true
                    Name       = 'EventSystem Service START TYPE is Automatic'
                    #Data       = $Script:SBDomainControllersServicesTestStartType
                    Parameters = @{
                        WhereObject   = { $_.Name -eq 'EventSystem' }
                        Property      = 'StartType'
                        ExpectedValue = 'Automatic'
                        OperationType = 'eq'
                    }
                }
                KDCServiceStatus                  = @{
                    Enable     = $true
                    Name       = 'KDC Service is RUNNING'
                    #Data       = $Script:SBDomainControllersServicesTestStatus
                    Parameters = @{
                        WhereObject   = { $_.Name -eq 'KDC' }
                        Property      = 'Status'
                        ExpectedValue = 'Running'
                        OperationType = 'eq'
                    }

                }
                KDCServiceStartType               = @{
                    Enable     = $true
                    Name       = 'KDC Service START TYPE is Automatic'
                    #Data       = $Script:SBDomainControllersServicesTestStartType
                    Parameters = @{
                        WhereObject   = { $_.Name -eq 'KDC' }
                        Property      = 'StartType'
                        ExpectedValue = 'Automatic'
                        OperationType = 'eq'
                    }
                }
                LanManWorkstationServiceStatus    = @{
                    Enable     = $true
                    Name       = 'LanManWorkstation Service is RUNNING'
                    #Data       = $Script:SBDomainControllersServicesTestStatus
                    Parameters = @{
                        WhereObject   = { $_.Name -eq 'LanManWorkstation' }
                        Property      = 'Status'
                        ExpectedValue = 'Running'
                        OperationType = 'eq'
                    }

                }
                LanManWorkstationServiceStartType = @{
                    Enable     = $true
                    Name       = 'LanManWorkstation Service START TYPE is Automatic'
                    #Data       = $Script:SBDomainControllersServicesTestStartType
                    Parameters = @{
                        WhereObject   = { $_.Name -eq 'LanManWorkstation' }
                        Property      = 'StartType'
                        ExpectedValue = 'Automatic'
                        OperationType = 'eq'
                    }
                }
                LanManServerServiceStatus         = @{
                    Enable     = $true
                    Name       = 'LanManServer Service is RUNNING'
                    #Data       = $Script:SBDomainControllersServicesTestStatus
                    Parameters = @{
                        WhereObject   = { $_.Name -eq 'LanManServer' }
                        Property      = 'Status'
                        ExpectedValue = 'Running'
                        OperationType = 'eq'
                    }

                }
                LanManServerServiceStartType      = @{
                    Enable     = $true
                    Name       = 'LanManServer Service START TYPE is Automatic'
                    #Data       = $Script:SBDomainControllersServicesTestStartType
                    Parameters = @{
                        WhereObject   = { $_.Name -eq 'LanManServer' }
                        Property      = 'StartType'
                        ExpectedValue = 'Automatic'
                        OperationType = 'eq'
                    }
                }
                NetLogonServiceStatus             = @{
                    Enable     = $true
                    Name       = 'NetLogon Service is RUNNING'
                    #Data       = $Script:SBDomainControllersServicesTestStatus
                    Parameters = @{
                        WhereObject   = { $_.Name -eq 'NetLogon' }
                        Property      = 'Status'
                        ExpectedValue = 'Running'
                        OperationType = 'eq'
                    }

                }
                NetLogonServiceStartType          = @{
                    Enable     = $true
                    Name       = 'NetLogon Service START TYPE is Automatic'
                    #Data       = $Script:SBDomainControllersServicesTestStartType
                    Parameters = @{
                        WhereObject   = { $_.Name -eq 'NetLogon' }
                        Property      = 'StartType'
                        ExpectedValue = 'Automatic'
                        OperationType = 'eq'
                    }
                }
                NTDSServiceStatus                 = @{
                    Enable     = $true
                    Name       = 'NTDS Service is RUNNING'
                    #Data       = $Script:SBDomainControllersServicesTestStatus
                    Parameters = @{
                        WhereObject   = { $_.Name -eq 'NTDS' }
                        Property      = 'Status'
                        ExpectedValue = 'Running'
                        OperationType = 'eq'
                    }

                }
                NTDSServiceStartType              = @{
                    Enable     = $true
                    Name       = 'NTDS Service START TYPE is Automatic'
                    #Data       = $Script:SBDomainControllersServicesTestStartType
                    Parameters = @{
                        WhereObject   = { $_.Name -eq 'NTDS' }
                        Property      = 'StartType'
                        ExpectedValue = 'Automatic'
                        OperationType = 'eq'
                    }
                }
                RPCSSServiceStatus                = @{
                    Enable     = $true
                    Name       = 'RPCSS Service is RUNNING'
                    #Data       = $Script:SBDomainControllersServicesTestStatus
                    Parameters = @{
                        WhereObject   = { $_.Name -eq 'RPCSS' }
                        Property      = 'Status'
                        ExpectedValue = 'Running'
                        OperationType = 'eq'
                    }

                }
                RPCSSServiceStartType             = @{
                    Enable     = $true
                    Name       = 'RPCSS Service START TYPE is Automatic'
                    #Data       = $Script:SBDomainControllersServicesTestStartType
                    Parameters = @{
                        WhereObject   = { $_.Name -eq 'RPCSS' }
                        Property      = 'StartType'
                        ExpectedValue = 'Automatic'
                        OperationType = 'eq'
                    }
                }
                SAMSSServiceStatus                = @{
                    Enable     = $true
                    Name       = 'SAMSS Service is RUNNING'
                    #Data       = $Script:SBDomainControllersServicesTestStatus
                    Parameters = @{
                        WhereObject   = { $_.Name -eq 'SAMSS' }
                        Property      = 'Status'
                        ExpectedValue = 'Running'
                        OperationType = 'eq'
                    }

                }
                SAMSSServiceStartType             = @{
                    Enable     = $true
                    Name       = 'SAMSS Service START TYPE is Automatic'
                    #Data       = $Script:SBDomainControllersServicesTestStartType
                    Parameters = @{
                        WhereObject   = { $_.Name -eq 'SAMSS' }
                        Property      = 'StartType'
                        ExpectedValue = 'Automatic'
                        OperationType = 'eq'
                    }
                }
                SpoolerServiceStatus              = @{
                    Enable     = $true
                    Name       = 'Spooler Service is STOPPED'
                    #Data       = $Script:SBDomainControllersServicesTestStatus
                    Parameters = @{
                        WhereObject   = { $_.Name -eq 'Spooler' }
                        Property      = 'Status'
                        ExpectedValue = 'Stopped'
                        OperationType = 'eq'
                    }

                }
                SpoolerServiceStartType           = @{
                    Enable     = $true
                    Name       = 'Spooler Service START TYPE is DISABLED'
                    #Data       = $Script:SBDomainControllersServicesTestStartType
                    Parameters = @{
                        WhereObject   = { $_.Name -eq 'Spooler' }
                        Property      = 'StartType'
                        ExpectedValue = 'Disabled'
                        OperationType = 'eq'
                    }
                }
                W32TimeServiceStatus              = @{
                    Enable     = $true
                    Name       = 'W32Time Service is RUNNING'
                    #Data       = $Script:SBDomainControllersServicesTestStatus
                    Parameters = @{
                        WhereObject   = { $_.Name -eq 'W32Time' }
                        Property      = 'Status'
                        ExpectedValue = 'Running'
                        OperationType = 'eq'
                    }

                }
                W32TimeServiceStartType           = @{
                    Enable     = $true
                    Name       = 'W32Time Service START TYPE is Automatic'
                    #Data       = $Script:SBDomainControllersServicesTestStartType
                    Parameters = @{
                        WhereObject   = { $_.Name -eq 'W32Time' }
                        Property      = 'StartType'
                        ExpectedValue = 'Automatic'
                        OperationType = 'eq'
                    }
                }
            }

            <#
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
                #>
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
        Ports                       = @{
            Enable = $false
            Source = @{
                Name       = 'AD TCP Ports are open' # UDP Testing is unreliable for now
                Data       = $Script:SBTestServerPorts
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
                        Property              = 'Status'
                        ExpectedValue         = $true
                        OperationType         = 'eq'
                        PropertyExtendedValue = 'Summary'
                    }
                }
            }
        }
        PortsRDP                    = @{
            Enable = $false
            Source = @{
                Name       = 'RDP Ports is open'
                Data       = $Script:SBTestServerPortsRDP
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
                        Property              = 'Status'
                        ExpectedValue         = $true
                        OperationType         = 'eq'
                        PropertyExtendedValue = 'Summary'
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
        TimeSettings                = [ordered] @{
            Enable = $false
            Source = @{
                Name       = "Time Settings"
                Data       = $Script:SBDomainControllersTimeSettings
                Area       = ''
                Parameters = @{

                }
            }
            Tests  = [ordered] @{
                NTPServerEnabled = @{
                    Enable     = $true
                    Name       = 'NtpServer must be enabled.'
                    Parameters = @{
                        WhereObject   = { $_.ComputerName -eq $DomainController }
                        Property      = 'NtpServerEnabled'
                        ExpectedValue = $true
                        OperationType = 'eq'
                    }
                }
                VMTimeProvider   = @{
                    Enable     = $true
                    Name       = 'Virtual Machine Time Provider should be disabled.'
                    Parameters = @{
                        WhereObject   = { $_.ComputerName -eq $DomainController }
                        Property      = 'VMTimeProvider'
                        ExpectedValue = $false
                        OperationType = 'eq'
                    }
                }
                NtpTypeNonPDC    = [ordered]  @{
                    Enable       = $true
                    Name         = 'NTP Server should be set to Domain Hierarchy'
                    Requirements = @{
                        IsPDC = $false
                    }
                    Parameters   = @{
                        WhereObject   = { $_.ComputerName -eq $DomainController }
                        Property      = 'NtpType'
                        ExpectedValue = 'NT5DS'
                        OperationType = 'eq'

                    }
                }
                NtpTypePDC       = [ordered] @{
                    Enable       = $true
                    Name         = 'NTP Server should be set to AllSync'
                    Requirements = @{
                        IsPDC = $true
                    }
                    Parameters   = @{
                        WhereObject   = { $_.ComputerName -eq $DomainController }
                        Property      = 'NtpType'
                        ExpectedValue = 'AllSync'
                        OperationType = 'eq'

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
                Description = 'Verify windows firewall should be enabled for all network cards'
                Parameters  = @{

                }
            }
            Tests  = [ordered] @{
                TimeSynchronizationTest = @{
                    Enable     = $true
                    Name       = 'Windows Firewall should be enabled on network card'
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
        WindowsUpdates              = @{
            Enable = $false
            Source = @{
                Name       = "Windows Updates"
                Data       = $Script:SBTestWindowsUpdates
                Area       = ''
                Parameters = @{

                }
            }
            Tests  = [ordered] @{
                PasswordLastSet = @{
                    Enable      = $true
                    Name        = 'Last Windows Updates should be less than 60 days ago'
                    Parameters  = @{
                        Property      = 'InstalledOn'
                        ExpectedValue = (Get-Date).AddDays(-60)
                        OperationType = 'gt'
                    }
                    Explanation = 'Last installed update should be less than 60 days ago.'
                }
            }
        }
        DnsResolveInternal          = @{
            Enable = $false
            Source = @{
                Name       = "Resolves internal DNS queries"
                Data       = $Script:SBResolveDNSInternal
                Area       = ''
                Parameters = @{

                }
            }
            Tests  = [ordered] @{
                ResolveDNSInternal = @{
                    Enable      = $true
                    Name        = 'Should resolve Internal DNS'
                    Parameters  = @{
                        Property              = 'Status'
                        ExpectedValue         = $true
                        OperationType         = 'eq'
                        PropertyExtendedValue = 'IPAddresses'
                    }
                    Explanation = 'DNS should resolve internal domains correctly.'
                }
            }
        }
        DnsResolveExternal          = @{
            Enable = $false
            Source = @{
                Name       = "Resolves external DNS queries"
                Data       = $Script:SBResolveDNSExternal
                Area       = ''
                Parameters = @{

                }
            }
            Tests  = [ordered] @{
                ResolveDNSExternal = @{
                    Enable      = $true
                    Name        = 'Should resolve External DNS'
                    Parameters  = @{
                        Property      = 'IPAddress'
                        ExpectedValue = '37.59.176.139'
                        OperationType = 'eq'
                    }
                    Explanation = 'DNS should resolve external queries properly.'
                }
            }
        }
        DnsNameServes               = @{
            Enable = $false
            Source = @{
                Name       = "Name servers for primary domain zone"
                Data       = $Script:SBServerDnsNameServers # (Get-Help <Command> -Parameter *).Name
                Area       = ''
                Parameters = @{

                }
            }
            Tests  = [ordered] @{
                DnsNameServersIdentical = @{
                    Enable      = $true
                    Name        = 'DNS Name servers for primary zone are identical'
                    Parameters  = @{
                        Property              = 'Status'
                        ExpectedValue         = $True
                        OperationType         = 'eq'
                        PropertyExtendedValue = 'Comment'
                    }
                    Explanation = 'DNS Name servers for primary zone should be equal to Domain Controllers for a Domain.'
                }
            }
        }
        SMBProtocols                = @{
            Enable = $false
            Source = @{
                Name       = 'SMB Protocols'
                Data       = $Script:SBDomainControllersSMB
                Area       = ''
                Parameters = @{

                }
            }
            Tests  = [ordered] @{
                EnableSMB1Protocol = @{
                    Enable     = $true
                    Name       = 'SMB v1 Protocol should be disabled'
                    Parameters = @{
                        Property      = 'EnableSMB1Protocol'
                        ExpectedValue = $false
                        OperationType = 'eq'
                    }
                }
                EnableSMB2Protocol = @{
                    Enable     = $true
                    Name       = 'SMB v2 Protocol should be enabled'
                    Parameters = @{
                        Property      = 'EnableSMB2Protocol'
                        ExpectedValue = $true
                        OperationType = 'eq'
                    }
                }
            }
        }
        DFSRAutoRecovery            = @{
            Enable = $false
            Source = @{
                Name             = 'DFSR AutoRecovery'
                Data             = $Script:SBDomainControllersDFSR
                Area             = ''
                Parameters       = @{

                }
                RecommendedLinks = @(
                    'https://secureinfra.blog/2019/04/30/field-notes-a-quick-tip-on-dfsr-automatic-recovery-while-you-prepare-for-an-ad-domain-upgrade/'
                )
            }
            Tests  = [ordered] @{
                EnableSMB1Protocol = @{
                    Enable     = $true
                    Name       = 'DFSR AutoRecovery should be enabled'
                    Parameters = @{
                        Property      = 'StopReplicationOnAutoRecovery'
                        ExpectedValue = 0
                        OperationType = 'eq'
                    }
                }
            }
        }

    }
    Debug             = @{
        ShowErrors = $false
    }
}