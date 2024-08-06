$Diagnostics = @{
    Name   = 'DCDiagnostics'
    Enable = $true
    Scope  = 'DC'
    Source = @{
        Name           = 'Diagnostics (DCDIAG)'
        Data           = {
            Test-ADDomainController -Forest $ForestName -ComputerName $DomainController -WarningAction SilentlyContinue
        }
        Details        = [ordered] @{
            Area        = 'Overall'
            Category    = 'Health'
            Description = ''
            Resolution  = ''
            Importance  = 10
            Resources   = @(
                'https://social.technet.microsoft.com/Forums/en-US/b48ee073-eb71-4852-8f56-ecf6f76b3fff/how-could-i-change-result-of-dcdiag-language-to-english-?forum=winserver8gen'
            )
        }
        ExpectedOutput = $true
    }
    Tests  = [ordered] @{
        Connectivity                     = @{
            Enable     = $true
            Name       = 'DCDiag Connectivity'
            Parameters = @{
                WhereObject   = { $_.Test -eq 'Connectivity' }
                Property      = 'Result'
                ExpectedValue = $true
                OperationType = 'eq'
            }
        }
        Advertising                      = @{
            Enable     = $true
            Name       = 'DCDiag Advertising'
            Parameters = @{
                WhereObject   = { $_.Test -eq 'Advertising' }
                Property      = 'Result'
                ExpectedValue = $true
                OperationType = 'eq'
            }
        }
        CheckSecurityError               = @{
            Enable     = $true
            Name       = 'DCDiag CheckSecurityError'
            Parameters = @{
                WhereObject   = { $_.Test -eq 'CheckSecurityError' }
                Property      = 'Result'
                ExpectedValue = $true
                OperationType = 'eq'
            }
        }
        CutoffServers                    = @{
            Enable     = $true
            Name       = 'DCDiag CutoffServers'
            Parameters = @{
                WhereObject   = { $_.Test -eq 'CutoffServers' }
                Property      = 'Result'
                ExpectedValue = $true
                OperationType = 'eq'
            }
        }
        FrsEvent                         = @{
            Enable     = $true
            Name       = 'DCDiag FrsEvent'
            Parameters = @{
                WhereObject   = { $_.Test -eq 'FrsEvent' }
                Property      = 'Result'
                ExpectedValue = $true
                OperationType = 'eq'
            }
        }
        DFSREvent                        = @{
            Enable     = $true
            Name       = 'DCDiag DFSREvent'
            Parameters = @{
                WhereObject   = { $_.Test -eq 'DFSREvent' }
                Property      = 'Result'
                ExpectedValue = $true
                OperationType = 'eq'
            }
        }
        SysVolCheck                      = @{
            Enable     = $true
            Name       = 'DCDiag SysVolCheck'
            Parameters = @{
                WhereObject   = { $_.Test -eq 'SysVolCheck' }
                Property      = 'Result'
                ExpectedValue = $true
                OperationType = 'eq'
            }
        }
        FrsSysVol                        = @{
            Enable     = $true
            Name       = 'DCDiag FrsSysVol'
            Parameters = @{
                WhereObject   = { $_.Test -eq 'FrsSysVol' }
                Property      = 'Result'
                ExpectedValue = $true
                OperationType = 'eq'
            }
        }
        KccEvent                         = @{
            Enable     = $true
            Name       = 'DCDiag KccEvent'
            Parameters = @{
                WhereObject   = { $_.Test -eq 'KccEvent' }
                Property      = 'Result'
                ExpectedValue = $true
                OperationType = 'eq'
            }
        }
        KnowsOfRoleHolders               = @{
            Enable     = $true
            Name       = 'DCDiag KnowsOfRoleHolders'
            Parameters = @{
                WhereObject   = { $_.Test -eq 'KnowsOfRoleHolders' }
                Property      = 'Result'
                ExpectedValue = $true
                OperationType = 'eq'
            }
        }
        MachineAccount                   = @{
            Enable     = $true
            Name       = 'DCDiag MachineAccount'
            Parameters = @{
                WhereObject   = { $_.Test -eq 'MachineAccount' }
                Property      = 'Result'
                ExpectedValue = $true
                OperationType = 'eq'
            }
        }
        NCSecDesc                        = @{
            Enable     = $true
            Name       = 'DCDiag NCSecDesc'
            Parameters = @{
                WhereObject   = { $_.Test -eq 'NCSecDesc' }
                Property      = 'Result'
                ExpectedValue = $true
                OperationType = 'eq'
            }
        }
        NetLogons                        = @{
            Enable     = $true
            Name       = 'DCDiag NetLogons'
            Parameters = @{
                WhereObject   = { $_.Test -eq 'NetLogons' }
                Property      = 'Result'
                ExpectedValue = $true
                OperationType = 'eq'
            }
        }
        ObjectsReplicated                = @{
            Enable     = $true
            Name       = 'DCDiag ObjectsReplicated'
            Parameters = @{
                WhereObject   = { $_.Test -eq 'ObjectsReplicated' }
                Property      = 'Result'
                ExpectedValue = $true
                OperationType = 'eq'
            }
        }
        Replications                     = @{
            Enable     = $true
            Name       = 'DCDiag Replications'
            Parameters = @{
                WhereObject   = { $_.Test -eq 'Replications' }
                Property      = 'Result'
                ExpectedValue = $true
                OperationType = 'eq'
            }
        }
        RidManager                       = @{
            Enable     = $true
            Name       = 'DCDiag RidManager'
            Parameters = @{
                WhereObject   = { $_.Test -eq 'RidManager' }
                Property      = 'Result'
                ExpectedValue = $true
                OperationType = 'eq'
            }
        }
        Services                         = @{
            Enable     = $true
            Name       = 'DCDiag Services'
            Parameters = @{
                WhereObject   = { $_.Test -eq 'Services' }
                Property      = 'Result'
                ExpectedValue = $true
                OperationType = 'eq'
            }
        }
        SystemLog                        = @{
            Enable     = $true
            Name       = 'DCDiag SystemLog'
            Parameters = @{
                WhereObject   = { $_.Test -eq 'SystemLog' }
                Property      = 'Result'
                ExpectedValue = $true
                OperationType = 'eq'
            }
        }
        Topology                         = @{
            Enable     = $true
            Name       = 'DCDiag Topology'
            Parameters = @{
                WhereObject   = { $_.Test -eq 'Topology' }
                Property      = 'Result'
                ExpectedValue = $true
                OperationType = 'eq'
            }
        }
        VerifyEnterpriseReferences       = @{
            Enable     = $true
            Name       = 'DCDiag VerifyEnterpriseReferences'
            Parameters = @{
                WhereObject   = { $_.Test -eq 'VerifyEnterpriseReferences' }
                Property      = 'Result'
                ExpectedValue = $true
                OperationType = 'eq'
            }
        }
        VerifyReferences                 = @{
            Enable     = $true
            Name       = 'DCDiag VerifyReferences'
            Parameters = @{
                WhereObject   = { $_.Test -eq 'VerifyReferences' }
                Property      = 'Result'
                ExpectedValue = $true
                OperationType = 'eq'
            }
        }
        VerifyReplicas                   = @{
            Enable     = $true
            Name       = 'DCDiag VerifyReplicas'
            Parameters = @{
                WhereObject   = { $_.Test -eq 'VerifyReplicas' }
                Property      = 'Result'
                ExpectedValue = $true
                OperationType = 'eq'
            }
        }
        DNS                              = @{
            Enable     = $true
            Name       = 'DCDiag DNS'
            Parameters = @{
                WhereObject   = { $_.Test -eq 'DNS' -and $_.Target -ne $Domain }
                Property      = 'Result'
                ExpectedValue = $true
                OperationType = 'eq'
            }
        }
        ForestDnsZonesCheckSDRefDom      = @{
            Enable     = $true
            Name       = 'DCDiag ForestDnsZones CheckSDRefDom'
            Parameters = @{
                WhereObject   = { $_.Test -eq 'CheckSDRefDom' -and $_.Target -eq 'ForestDnsZones' }
                Property      = 'Result'
                ExpectedValue = $true
                OperationType = 'eq'
            }
        }
        ForestDnsZonesCrossRefValidation = @{
            Enable     = $true
            Name       = 'DCDiag ForestDnsZones CrossRefValidation'
            Parameters = @{
                WhereObject   = { $_.Test -eq 'CrossRefValidation' -and $_.Target -eq 'ForestDnsZones' }
                Property      = 'Result'
                ExpectedValue = $true
                OperationType = 'eq'
            }
        }
        DomainDnsZonesCheckSDRefDom      = @{
            Enable     = $true
            Name       = 'DCDiag DomainDnsZones CheckSDRefDom'
            Parameters = @{
                WhereObject   = { $_.Test -eq 'CheckSDRefDom' -and $_.Target -eq 'DomainDnsZones' }
                Property      = 'Result'
                ExpectedValue = $true
                OperationType = 'eq'
            }
        }
        DomainDnsZonesCrossRefValidation = @{
            Enable     = $true
            Name       = 'DCDiag DomainDnsZones CrossRefValidation'
            Parameters = @{
                WhereObject   = { $_.Test -eq 'CrossRefValidation' -and $_.Target -eq 'DomainDnsZones' }
                Property      = 'Result'
                ExpectedValue = $true
                OperationType = 'eq'
            }
        }
        SchemaCheckSDRefDom              = @{
            Enable     = $true
            Name       = 'DCDiag Schema CheckSDRefDom'
            Parameters = @{
                WhereObject   = { $_.Test -eq 'CheckSDRefDom' -and $_.Target -eq 'Schema' }
                Property      = 'Result'
                ExpectedValue = $true
                OperationType = 'eq'
            }
        }
        SchemaCrossRefValidation         = @{
            Enable     = $true
            Name       = 'DCDiag Schema CrossRefValidation'
            Parameters = @{
                WhereObject   = { $_.Test -eq 'CrossRefValidation' -and $_.Target -eq 'Schema' }
                Property      = 'Result'
                ExpectedValue = $true
                OperationType = 'eq'
            }
        }
        ConfigurationCheckSDRefDom       = @{
            Enable     = $true
            Name       = 'DCDiag Configuration CheckSDRefDom'
            Parameters = @{
                WhereObject   = { $_.Test -eq 'CheckSDRefDom' -and $_.Target -eq 'Configuration' }
                Property      = 'Result'
                ExpectedValue = $true
                OperationType = 'eq'
            }
        }
        ConfigurationCrossRefValidation  = @{
            Enable     = $true
            Name       = 'DCDiag Configuration CrossRefValidation'
            Parameters = @{
                WhereObject   = { $_.Test -eq 'CrossRefValidation' -and $_.Target -eq 'Configuration' }
                Property      = 'Result'
                ExpectedValue = $true
                OperationType = 'eq'
            }
        }
        NetbiosCheckSDRefDom             = @{
            Enable     = $true
            Name       = 'DCDiag NETBIOS CheckSDRefDom'
            Parameters = @{
                WhereObject   = { $_.Test -eq 'CheckSDRefDom' -and ($_.Target -ne 'Configuration' -and $_.Target -ne 'ForestDnsZones' -and $_.Target -ne 'DomainDnsZones' -and $_.Target -ne 'Schema') }
                Property      = 'Result'
                ExpectedValue = $true
                OperationType = 'eq'
            }
        }
        NetbiosCrossRefValidation        = @{
            Enable     = $true
            Name       = 'DCDiag NETBIOS CrossRefValidation'
            Parameters = @{
                WhereObject   = { $_.Test -eq 'CrossRefValidation' -and ($_.Target -ne 'Configuration' -and $_.Target -ne 'ForestDnsZones' -and $_.Target -ne 'DomainDnsZones' -and $_.Target -ne 'Schema') }
                Property      = 'Result'
                ExpectedValue = $true
                OperationType = 'eq'
            }
        }
        DNSDomain                        = @{
            Enable     = $true
            Name       = 'DCDiag DNS'
            Parameters = @{
                WhereObject   = { $_.Test -eq 'DNS' -and $_.Target -eq $Domain }
                Property      = 'Result'
                ExpectedValue = $true
                OperationType = 'eq'
            }
        }
        LocatorCheck                     = @{
            Enable     = $true
            Name       = 'DCDiag LocatorCheck'
            Parameters = @{
                WhereObject   = { $_.Test -eq 'LocatorCheck' }
                Property      = 'Result'
                ExpectedValue = $true
                OperationType = 'eq'
            }
        }
        FsmoCheck                        = @{
            Enable     = $true
            Name       = 'DCDiag FsmoCheck'
            Parameters = @{
                WhereObject   = { $_.Test -eq 'FsmoCheck' }
                Property      = 'Result'
                ExpectedValue = $true
                OperationType = 'eq'
            }
        }
        Intersite                        = @{
            Enable     = $true
            Name       = 'DCDiag Intersite'
            Parameters = @{
                WhereObject   = { $_.Test -eq 'Intersite' }
                Property      = 'Result'
                ExpectedValue = $true
                OperationType = 'eq'
            }
        }
    }
}

<#
ComputerName      Target         Test                       Result Data
------------      ------         ----                       ------ ----
ad1.ad.evotec.xyz AD1            Connectivity                 True       Starting test: Connectivity...
ad1.ad.evotec.xyz AD1            Advertising                  True       Starting test: Advertising...
ad1.ad.evotec.xyz AD1            CheckSecurityError           True       Starting test: CheckSecurityError...
ad1.ad.evotec.xyz AD1            CutoffServers                True       Starting test: CutoffServers...
ad1.ad.evotec.xyz AD1            FrsEvent                     True       Starting test: FrsEvent...
ad1.ad.evotec.xyz AD1            DFSREvent                    True       Starting test: DFSREvent...
ad1.ad.evotec.xyz AD1            SysVolCheck                  True       Starting test: SysVolCheck...
ad1.ad.evotec.xyz AD1            FrsSysVol                    True       Starting test: FrsSysVol...
ad1.ad.evotec.xyz AD1            KccEvent                     True       Starting test: KccEvent...
ad1.ad.evotec.xyz AD1            KnowsOfRoleHolders           True       Starting test: KnowsOfRoleHolders...
ad1.ad.evotec.xyz AD1            MachineAccount               True       Starting test: MachineAccount...
ad1.ad.evotec.xyz AD1            NCSecDesc                    True       Starting test: NCSecDesc...
ad1.ad.evotec.xyz AD1            NetLogons                    True       Starting test: NetLogons...
ad1.ad.evotec.xyz AD1            ObjectsReplicated            True       Starting test: ObjectsReplicated...
ad1.ad.evotec.xyz AD1            Replications                 True       Starting test: Replications...
ad1.ad.evotec.xyz AD1            RidManager                   True       Starting test: RidManager...
ad1.ad.evotec.xyz AD1            Services                     True       Starting test: Services...
ad1.ad.evotec.xyz AD1            SystemLog                   False       Starting test: SystemLog...
ad1.ad.evotec.xyz AD1            Topology                     True       Starting test: Topology...
ad1.ad.evotec.xyz AD1            VerifyEnterpriseReferences   True       Starting test: VerifyEnterpriseReferences...
ad1.ad.evotec.xyz AD1            VerifyReferences             True       Starting test: VerifyReferences...
ad1.ad.evotec.xyz AD1            VerifyReplicas               True       Starting test: VerifyReplicas...
ad1.ad.evotec.xyz AD1            DNS                          True       Starting test: DNS...
ad1.ad.evotec.xyz ForestDnsZones CheckSDRefDom                True       Starting test: CheckSDRefDom...
ad1.ad.evotec.xyz ForestDnsZones CrossRefValidation           True       Starting test: CrossRefValidation...
ad1.ad.evotec.xyz DomainDnsZones CheckSDRefDom                True       Starting test: CheckSDRefDom...
ad1.ad.evotec.xyz DomainDnsZones CrossRefValidation           True       Starting test: CrossRefValidation...
ad1.ad.evotec.xyz Schema         CheckSDRefDom                True       Starting test: CheckSDRefDom...
ad1.ad.evotec.xyz Schema         CrossRefValidation           True       Starting test: CrossRefValidation...
ad1.ad.evotec.xyz Configuration  CheckSDRefDom                True       Starting test: CheckSDRefDom...
ad1.ad.evotec.xyz Configuration  CrossRefValidation           True       Starting test: CrossRefValidation...
ad1.ad.evotec.xyz ad             CheckSDRefDom                True       Starting test: CheckSDRefDom...
ad1.ad.evotec.xyz ad             CrossRefValidation           True       Starting test: CrossRefValidation...
ad1.ad.evotec.xyz ad.evotec.xyz  DNS                          True       Starting test: DNS...
ad1.ad.evotec.xyz ad.evotec.xyz  LocatorCheck                 True       Starting test: LocatorCheck...
ad1.ad.evotec.xyz ad.evotec.xyz  FsmoCheck                    True       Starting test: FsmoCheck...
ad1.ad.evotec.xyz ad.evotec.xyz  Intersite                    True       Starting test: Intersite...
#>
