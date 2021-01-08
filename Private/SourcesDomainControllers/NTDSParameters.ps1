<#
System Schema Version                            : 87
Root Domain                                      : DC=ad,DC=evotec,DC=xyz
Configuration NC                                 : CN=Configuration,DC=ad,DC=evotec,DC=xyz
Machine DN Name                                  : CN=NTDS Settings,CN=AD1,CN=Servers,CN=Default-First-Site-Name,CN=Sites,CN=Configuration,DC=ad,DC=evotec,DC=xyz
DsaOptions                                       : 1
IsClone                                          : 0
ServiceDll                                       : C:\Windows\system32\ntdsa.dll
DSA Working Directory                            : C:\Windows\NTDS
DSA Database file                                : C:\Windows\NTDS\ntds.dit
Database backup path                             : C:\Windows\NTDS\dsadata.bak
Database log files path                          : C:\Windows\NTDS
Hierarchy Table Recalculation interval (minutes) : 720
Database logging/recovery                        : ON
DSA Database Epoch                               : 23865
Strict Replication Consistency                   : 1
Schema Version                                   : 88
ldapserverintegrity                              : 1
Global Catalog Promotion Complete                : 1
DSA Previous Restore Count                       : 2
ComputerName                                     : AD1

#>

$NTDSParameters = @{
    Enable = $true
    Scope  = 'DC'
    Source = @{
        Name = "NTDS Parameters"
        Data = {
            Get-PSRegistry -RegistryPath "HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Services\NTDS\Parameters" -ComputerName $DomainController
        }
        Details = [ordered] @{
            Area             = ''
            Description      = ''
            Resolution   = ''
            RiskLevel        = 10
            Resources = @(

            )
        }
        ExpectedOutput = $true
    }
    Tests  = [ordered] @{
        DsaNotWritable = @{
            Enable     = $true
            Name       = 'Domain Controller should be writeable'
            Parameters = @{
                Property       = 'Dsa Not Writable'
                ExpectedOutput = $false
            }
        }
    }
}