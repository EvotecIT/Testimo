$Script:TestimoConfiguration = [ordered] @{
    Forest            = @{
        Sources = [ordered]  @{
            OptionalFeatures = @{
                Enable     = $true
                SourceName = 'Optional Features'
                SourceData = $Script:SBForestOptionalFeatures
                Tests      = [ordered] @{
                    RecycleBinEnabled = @{
                        Enable         = $true
                        TestName       = 'RecycleBin Enabled'
                        TestSource     = $Script:SBForestOptionalFeaturesTest1
                        TestParameters = @{
                            ExpectedValue = $true
                            OperationType = 'eq'
                        }
                    }
                    LapsAvailable     = @{
                        Enable         = $true
                        TestName       = 'Laps Available'
                        TestSource     = $Script:SBForestOptionalFeaturesTest2
                        TestParameters = @{
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
                Enable     = $true
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
        }
    }
    Domain            = @{
        Sources = [ordered] @{
            PasswordComplexity = @{
                Enable     = $false
                SourceName = 'Password Complexity Requirements'
                SourceData = $Script:SBDomainPasswordComplexity
                Tests      = [ordered] @{
                    ComplexityEnabled               = @{
                        Enable         = $true
                        TestName       = 'Complexity Enabled'
                        TestSource     = $Script:SBDomainPasswordComplexityTest1
                        TestParameters = @{
                            ExpectedValue = $true
                            OperationType = 'eq'
                        }
                    }
                    'Lockout Duration'              = @{
                        Enable         = $true
                        TestName       = 'Lockout Duration'
                        TestSource     = $Script:SBDomainPasswordComplexityTest2
                        TestParameters = @{
                            ExpectedValue = 30
                            OperationType = 'ge'
                        }
                    }
                    'Lockout Observation Window'    = @{
                        Enable         = $true
                        TestName       = 'Lockout Observation Window'
                        TestSource     = $Script:SBDomainPasswordComplexityTest3
                        TestParameters = @{
                            ExpectedValue = 30
                            OperationType = 'ge'
                        }
                    }
                    'Lockout Threshold'             = @{
                        Enable         = $true
                        TestName       = 'Lockout Threshold'
                        TestSource     = $Script:SBDomainPasswordComplexityTest4
                        TestParameters = @{
                            ExpectedValue = 5
                            OperationType = 'gt'
                        }
                    }
                    'Max Password Age'              = @{
                        Enable         = $true
                        TestName       = 'Max Password Age'
                        TestSource     = $Script:SBDomainPasswordComplexityTest5
                        TestParameters = @{
                            ExpectedValue = 60
                            OperationType = 'le'
                        }
                    }
                    'Min Password Length'           = @{
                        Enable         = $true
                        TestName       = 'Min Password Length'
                        TestSource     = $Script:SBDomainPasswordComplexityTest6
                        TestParameters = @{
                            ExpectedValue = 8
                            OperationType = 'gt'
                        }
                    }
                    'Min Password Age'              = @{
                        Enable         = $true
                        TestName       = 'Min Password Age'
                        TestSource     = $Script:SBDomainPasswordComplexityTest7
                        TestParameters = @{
                            ExpectedValue = 1
                            OperationType = 'le'
                        }
                    }
                    'Password History Count'        = @{
                        Enable         = $true
                        TestName       = 'Password History Count'
                        TestSource     = $Script:SBDomainPasswordComplexityTest8
                        TestParameters = @{
                            ExpectedValue = 10
                            OperationType = 'ge'
                        }
                    }
                    'Reversible Encryption Enabled' = @{
                        Enable         = $true
                        TestName       = 'Reversible Encryption Enabled'
                        TestSource     = $Script:SBDomainPasswordComplexityTest9
                        TestParameters = @{
                            ExpectedValue = $true
                            OperationType = 'eq'
                        }
                    }
                }
            }
            Trusts             = @{
                Enable     = $false
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
                Enable     = $false
                SourceName = 'LDAP Connectivity'
                SourceData = $Script:SBDomainControllersLDAP
                Tests      = [ordered] @{
                    PortLDAP     = @{
                        Enable         = $true
                        TestName       = 'LDAP Port is Available'
                        TestSource     = $Script:SBDomainControllersLDAP_Port
                        TestParameters = @{
                            ExpectedValue = $true
                            OperationType = 'eq'
                        }
                    }
                    PortLDAPS    = @{
                        Enable         = $true
                        TestName       = 'LDAP SSL Port is Available'
                        TestSource     = $Script:SBDomainControllersLDAP_PortSSL
                        TestParameters = @{
                            ExpectedValue = $true
                            OperationType = 'eq'
                        }
                    }
                    PortLDAP_GC  = @{
                        Enable         = $true
                        TestName       = 'LDAP GC Port is Available'
                        TestSource     = $Script:SBDomainControllersLDAP_PortGC
                        TestParameters = @{
                            ExpectedValue = $true
                            OperationType = 'eq'
                        }
                    }
                    PortLDAPS_GC = @{
                        Enable         = $true
                        TestName       = 'LDAP SSL GC Port is Available'
                        TestSource     = $Script:SBDomainControllersLDAP_PortGC_SSL
                        TestParameters = @{
                            ExpectedValue = $true
                            OperationType = 'eq'
                        }
                    }
                }

            }
            Pingable                    = @{
                Enable     = $false
                SourceName = 'PING'
                SourceData = $Script:SBDomainControllersPing
                Tests      = @{
                    Ping = @{
                        Enable         = $true
                        TestName       = 'Responding to PING'
                        TestSource     = $Script:SBDomainControllersPingTest
                        TestParameters = @{
                            ExpectedValue = $true
                            OperationType = 'eq'
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
                        TestName       = 'Port 53 is OPEN'
                        TestSource     = $Script:SBDomainControllersPort53Test
                        TestParameters = @{
                            ExpectedValue = $true
                            OperationType = 'eq'
                        }
                    }
                }
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