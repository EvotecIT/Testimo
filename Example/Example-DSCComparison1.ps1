Import-Module .\Testimo.psd1 -Force
#Import-Module C:\Support\GitHub\PSSharedGoods\PSSharedGoods.psd1 -Force
Import-Module "C:\Support\GitHub\DSCParser\DSCParser.psd1" -Force


$Sources = @(
    'AADConditionalAccessPolicy', 'AADGroupLifecyclePolicy', 'AADGroupsNamingPolicy', 'EXOAntiPhishPolicy', 'EXOAtpPolicyForO365'
    'EXOHostedContentFilterPolicy', 'EXOHostedOutboundSpamFilterPolicy', 'EXOMalwareFilterPolicy', 'EXOOrganizationConfig'
    'EXOOwaMailboxPolicy', 'EXORoleAssignmentPolicy', 'EXOSafeAttachmentPolicy', 'EXOSafeAttachmentRule', 'EXOSafeLinksPolicy', 'EXOSafeLinksRule'
    'EXOSharingPolicy', 'O365AdminAuditLogConfig', 'ODSettings', 'SCLabelPolicy', 'SCSensitivityLabel', 'SPOAccessControlSettings', 'SPOBrowserIdleSignout', 'SPO'
    'SharingSettings', 'SPOTenantSettings', 'TeamsChannelsPolicy', 'TeamsClientConfiguration',
    'TeamsGuestMeetingConfiguration', 'TeamsGuestMessagingConfiguration', 'TeamsMeetingBroadcastConfiguration', 'TeamsMeetingBroadcastPolicy',
    'TeamsMeetingConfiguration', 'TeamsMeetingPolicy', 'TeamsMessagingPolicy'
)

Invoke-Testimo -Sources $Sources {
    Compare-Testimo -Name 'DSC' -Scope 'O365' -BaseLineSourcePath "C:\Support\GitHub\Testimo\Ignore\m365\M365TenantConfig.ps1" -BaseLineTargetPath "C:\Support\GitHub\Testimo\Ignore\m365\M365_DSC.ps1" -ExcludeProperty 'ApplicationID', 'ApplicationSecret', 'Ensure', 'IsSingleInstance', 'TenantId'
    #Compare-Testimo -Name 'DSC' -Scope 'O365' -BaseLineSourcePath "C:\Support\GitHub\Testimo\Ignore\m365\M365TenantConfig.ps1" -BaseLineTargetPath "C:\Support\GitHub\Testimo\Ignore\m365\M365TenantConfig.ps1"
} -FilePath $PSScriptRoot\Reports\TestimoDSC.html -ExternalTests $PSScriptRoot\O365 -Sources O365Bookings, O365Forms, Office365Mailboxes -Variables @{
    Authorization = $Authorization
}