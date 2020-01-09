
<#
Name                      : AD-Certificate
DisplayName               : Active Directory Certificate Services
Description               : Active Directory Certificate Services (AD CS) is used to create certification authorities and related role services that allow you to issue and manage certificates used in a variety of applications.
Installed                 : False
InstallState              : Available
FeatureType               : Role
Path                      : Active Directory Certificate Services
Depth                     : 1
DependsOn                 : {}
Parent                    :
ServerComponentDescriptor : ServerComponent_AD_Certificate
SubFeatures               : {ADCS-Cert-Authority, ADCS-Enroll-Web-Pol, ADCS-Enroll-Web-Svc, ADCS-Web-Enrollment...}
SystemService             : {}
Notification              : {}
BestPracticesModelId      : Microsoft/Windows/CertificateServices
EventQuery                : ActiveDirectoryCertificateServices.Events.xml
PostConfigurationNeeded   : False
AdditionalInfo            : {MajorVersion, MinorVersion, NumericId, InstallName}
#>

#Get-WindowsFeature -ComputerName AD1 | Where-Object { $_.'InstallState' -eq 'Installed' } | ft DisplayName, Name, DependsOn, FeatureType, Installed
#Get-WindowsFeature -ComputerName AD3 | Where-Object { $_.'InstallState' -eq 'Installed' } | ft DisplayName, Name, DependsOn, FeatureType, Installed

<#
DisplayName                                         Name                                         DependsOn                                                    FeatureType  Installed
-----------                                         ----                                         ---------                                                    -----------  ---------
Active Directory Domain Services                    AD-Domain-Services                           {NET-Framework-45-Core, PowerShell, RSAT-AD-PowerShell}      Role              True
DNS Server                                          DNS                                          {}                                                           Role              True
File and Storage Services                           FileAndStorage-Services                      {}                                                           Role              True
File and iSCSI Services                             File-Services                                {}                                                           Role Service      True
File Server                                         FS-FileServer                                {}                                                           Role Service      True
Storage Services                                    Storage-Services                             {}                                                           Role Service      True
.NET Framework 4.6 Features                         NET-Framework-45-Features                    {}                                                           Feature           True
.NET Framework 4.6                                  NET-Framework-45-Core                        {}                                                           Feature           True
WCF Services                                        NET-WCF-Services45                           {NET-Framework-45-Core}                                      Feature           True
TCP Port Sharing                                    NET-WCF-TCP-PortSharing45                    {NET-Framework-45-Core}                                      Feature           True
BitLocker Drive Encryption                          BitLocker                                    {EnhancedStorage}                                            Feature           True
Enhanced Storage                                    EnhancedStorage                              {}                                                           Feature           True
Group Policy Management                             GPMC                                         {}                                                           Feature           True
Remote Server Administration Tools                  RSAT                                         {}                                                           Feature           True
Feature Administration Tools                        RSAT-Feature-Tools                           {}                                                           Feature           True
BitLocker Drive Encryption Administration Utilities RSAT-Feature-Tools-BitLocker                 {}                                                           Feature           True
BitLocker Drive Encryption Tools                    RSAT-Feature-Tools-BitLocker-RemoteAdminTool {}                                                           Feature           True
BitLocker Recovery Password Viewer                  RSAT-Feature-Tools-BitLocker-BdeAducExt      {RSAT-ADDS-Tools}                                            Feature           True
Role Administration Tools                           RSAT-Role-Tools                              {}                                                           Feature           True
AD DS and AD LDS Tools                              RSAT-AD-Tools                                {}                                                           Feature           True
Active Directory module for Windows PowerShell      RSAT-AD-PowerShell                           {NET-Framework-45-Core, PowerShell}                          Feature           True
AD DS Tools                                         RSAT-ADDS                                    {}                                                           Feature           True
Active Directory Administrative Center              RSAT-AD-AdminCenter                          {NET-Framework-45-Core, RSAT-AD-PowerShell, RSAT-ADDS-Tools} Feature           True
AD DS Snap-Ins and Command-Line Tools               RSAT-ADDS-Tools                              {}                                                           Feature           True
DNS Server Tools                                    RSAT-DNS-Server                              {}                                                           Feature           True
SMB 1.0/CIFS File Sharing Support                   FS-SMB1                                      {}                                                           Feature           True
Telnet Client                                       Telnet-Client                                {}                                                           Feature           True
TFTP Client                                         TFTP-Client                                  {}                                                           Feature           True
Windows Defender Features                           Windows-Defender-Features                    {}                                                           Feature           True
Windows Defender                                    Windows-Defender                             {}                                                           Feature           True
GUI for Windows Defender                            Windows-Defender-Gui                         {Windows-Defender}                                           Feature           True
Windows PowerShell                                  PowerShellRoot                               {}                                                           Feature           True
Windows PowerShell 5.1                              PowerShell                                   {NET-Framework-45-Core}                                      Feature           True
Windows PowerShell ISE                              PowerShell-ISE                               {PowerShell, NET-Framework-45-Core}                          Feature           True
WoW64 Support                                       WoW64-Support                                {}                                                           Feature           True
#>


$WindowsRolesAndFeatures = @{
    Enable = $true
    Source = @{
        Name = "Windows Roles and Features"
        Data = {
            Get-WindowsFeature -ComputerName $DomainController #| Where-Object { $_.'InstallState' -eq 'Installed' }
        }
    }
    Tests  = [ordered] @{
        ActiveDirectoryDomainServices = @{
            Enable     = $true
            Name       = 'Active Directory Domain Services is installed'
            Parameters = @{
                WhereObject   = { $_.Name -eq 'AD-Domain-Services' }
                Property      = 'Installed'
                ExpectedValue = $true
                OperationType = 'eq'
            }
        }
        DNSServer                     = @{
            Enable     = $true
            Name       = 'DNS Server is installed'
            Parameters = @{
                WhereObject   = { $_.Name -eq 'DNS' }
                Property      = 'Installed'
                ExpectedValue = $true
                OperationType = 'eq'
            }
        }
        FileandStorageServices        = @{
            Enable     = $true
            Name       = 'File and Storage Services is installed'
            Parameters = @{
                WhereObject   = { $_.Name -eq 'FileAndStorage-Services' }
                Property      = 'Installed'
                ExpectedValue = $true
                OperationType = 'eq'
            }
        }
        FileandiSCSIServices        = @{
            Enable     = $true
            Name       = 'File and iSCSI Services is installed'
            Parameters = @{
                WhereObject   = { $_.Name -eq 'File-Services' }
                Property      = 'Installed'
                ExpectedValue = $true
                OperationType = 'eq'
            }
        }
        FileServer        = @{
            Enable     = $true
            Name       = 'File Server is installed'
            Parameters = @{
                WhereObject   = { $_.Name -eq 'FS-FileServer' }
                Property      = 'Installed'
                ExpectedValue = $true
                OperationType = 'eq'
            }
        }
        StorageServices        = @{
            Enable     = $true
            Name       = 'Storage Services is installed'
            Parameters = @{
                WhereObject   = { $_.Name -eq 'Storage-Services' }
                Property      = 'Installed'
                ExpectedValue = $true
                OperationType = 'eq'
            }
        }
        WindowsPowerShell51           = @{
            Enable     = $true
            Name       = 'Windows PowerShell 5.1 is installed'
            Parameters = @{
                WhereObject   = { $_.Name -eq 'PowerShell' }
                Property      = 'Installed'
                ExpectedValue = $true
                OperationType = 'eq'
            }
        }
    }
}