Import-Module .\Testimo.psd1 -Force #-Verbose

if (-not $Credentials) {
    # $Credentials = Get-Credential
}
# This makes a connection to Office 365 tenant
# since we don't want to save the data we null it out
# keep in mind that if there's an MFA you would be better left without Credentials and just let it prompt you
$Authorization = Connect-O365Admin -Verbose
#$ExchangeConnection = Connect-ExchangeOnline

Invoke-Testimo -ExternalTests $PSScriptRoot\O365 -Sources O365Bookings, O365Forms, Office365Mailboxes -Variables @{
    Authorization = $Authorization
} -IncludeDomainControllers AD1


#Invoke-Testimo -ExternalTests $PSScriptRoot\O365 -Sources O365Bookings,Office365Mailboxes -Variables @{
# Authorization = $Authorization1
#}

#Invoke-Testimo -ExternalTests $PSScriptRoot\O365 -Sources ForestBackup, ForestDHCP

#Invoke-Testimo -Sources DCServices, DCSMBProtocols, DomainLDAP -IncludeDomainControllers AD1


# Invoke-Testimo -ExternalTests $PSScriptRoot\O365 -Sources O365Bookings, Office365Mailboxes, ForestBackup, ForestDHCP, DCServices, SomeRandomTest -Variables @{
#    Authorization = $Authorization1
# } -AlwaysShowSteps


#Invoke-Testimo -Sources ForestBackup, DomainMachineQuota, O365Bookings
#Invoke-Testimo -Sources ForestBackup, DomainMachineQuota, O365Bookings

#Invoke-Testimo -Sources DCServices, DCSMBProtocols, DomainLDAP -IncludeDomainControllers AD1 -AlwaysShowSteps
#Invoke-Testimo -Sources ForestBackup, DomainMachineQuota, ForestDHCP, ForestSites

# Invoke-Testimo -ExternalTests $PSScriptRoot\O365 -Sources Office365Forms, O365Bookings, Office365Mailboxes -Variables @{
#    Authorization = $Authorization1
# }

# $Test = Invoke-Testimo -Sources DCServices -PassThru -ExtendedResults
# $Test