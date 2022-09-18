Import-Module .\Testimo.psd1 -Force
Import-Module "C:\Support\GitHub\DSCParser\DSCParser.psd1" -Force

$Sources = @(
    'AADConditionalAccessPolicy', 'TeamsChannelsPolicy', 'EXOAtpPolicyForO365'
    #  'AADGroupLifecyclePolicy', 'AADGroupsNamingPolicy', 'EXOAntiPhishPolicy', 'EXOAtpPolicyForO365',
    # 'EXOHostedContentFilterPolicy', 'EXOHostedOutboundSpamFilterPolicy', 'EXOMalwareFilterPolicy', 'EXOOrganizationConfig',
    # 'EXOOwaMailboxPolicy', 'EXORoleAssignmentPolicy', 'EXOSafeAttachmentPolicy', 'EXOSafeAttachmentRule', 'EXOSafeLinksPolicy', 'EXOSafeLinksRule',
    # 'EXOSharingPolicy', 'O365AdminAuditLogConfig', 'ODSettings', 'SCLabelPolicy', 'SCSensitivityLabel', 'SPOAccessControlSettings', 'SPOBrowserIdleSignout', 'SPO'
    # 'SharingSettings', 'SPOTenantSettings', 'TeamsChannelsPolicy', 'TeamsClientConfiguration',
    # 'TeamsGuestMeetingConfiguration', 'TeamsGuestMessagingConfiguration', 'TeamsMeetingBroadcastConfiguration', 'TeamsMeetingBroadcastPolicy',
    # 'TeamsMeetingConfiguration', 'TeamsMeetingPolicy', 'TeamsMessagingPolicy'
)
#$Sources = 'DSC', 'CSEnrollMentRestrictions'

Invoke-Testimo -Sources $Sources {
    Compare-Testimo -Name 'DSC' -Scope 'O365' -BaseLineSourcePath "C:\Support\GitHub\Testimo\Ignore\m365\M365TenantConfig.ps1" -BaseLineTargetPath "C:\Support\GitHub\Testimo\Ignore\m365\M365_DSC.ps1"
}
return


$BaseLineSource = ConvertTo-DSCObject -Path "C:\Support\GitHub\Testimo\Ignore\m365\M365TenantConfig.ps1"
