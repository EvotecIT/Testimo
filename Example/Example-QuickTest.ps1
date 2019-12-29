Import-Module .\Testimo.psd1 -Force

#Invoke-Testimo -Sources DomainPasswordComplexity, ForestBackup #-ShowReport
#Invoke-Testimo -Sources DomainDNSForwaders,DCDiskSpace
#Invoke-Testimo -Sources DomainComputersUnsupported,DomainComputersUnsupportedMainstream,DomainPasswordComplexity
Invoke-Testimo -Sources DCDiskSpace -SkipRODC