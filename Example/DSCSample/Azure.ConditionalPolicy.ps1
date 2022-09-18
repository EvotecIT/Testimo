@{
    Name   = 'AzureADConditionalPolicyDenyBasicAuth'
    Enable = $true
    Scope  = 'AzureAD'
    Source = @{
        Name           = 'Azure AD Conditional Access Deny Basic Auth'
        Data           = {
            Get-AzureADMSConditionalAccessPolicy | Where-Object { $_.DisplayName -eq "All - Deny Basic authentication" }
        }
        Flatten        = $true
        Details        = [ordered] @{
            Category    = 'AzureAD'
            Description = ''
            Importance  = 0
            ActionType  = 0
            Resources   = @(

            )
            Tags        = 'O365', 'Configuration', 'AzureAD'
            StatusTrue  = 0
            StatusFalse = 5
        }
        ExpectedOutput = $true
    }
    Tests  = [ordered] @{
        "Conditions.Applications.IncludeApplications.1" = 'All'

        # AADConditionalAccessPolicy = @{
        #     Enable     = $true
        #     Name       = 'Hidden Mailboxes'
        #     Parameters = @{
        #         ApplicationEnforcedRestrictionsIsEnabled = $False;
        #         BuiltInControls                          = @("block");
        #         ClientAppTypes                           = @("exchangeActiveSync", "other");
        #         CloudAppSecurityIsEnabled                = $False;
        #         CloudAppSecurityType                     = "";
        #         Credential                               = $Credscredential;
        #         DisplayName                              = "All - Deny Basic authentication";
        #         Ensure                                   = "Present";
        #         ExcludeApplications                      = @();
        #         ExcludeDevices                           = @();
        #         ExcludeGroups                            = @();
        #         ExcludeLocations                         = @();
        #         ExcludePlatforms                         = @();
        #         ExcludeRoles                             = @();
        #         ExcludeUsers                             = @("admin@$OrganizationName");
        #         GrantControlOperator                     = "OR";
        #         Id                                       = "77000763-8b9e-485a-8cfe-735b2bde5f50";
        #         IncludeApplications                      = @("All");
        #         IncludeDevices                           = @();
        #         IncludeGroups                            = @();
        #         IncludeLocations                         = @();
        #         IncludePlatforms                         = @();
        #         IncludeRoles                             = @();
        #         IncludeUserActions                       = @();
        #         IncludeUsers                             = @("All");
        #         PersistentBrowserIsEnabled               = $False;
        #         PersistentBrowserMode                    = "";
        #         SignInFrequencyIsEnabled                 = $False;
        #         SignInFrequencyType                      = "";
        #         SignInRiskLevels                         = @();
        #         State                                    = "enabled";
        #         UserRiskLevels                           = @();
        #     }
        #     Details    = [ordered] @{
        #         Category    = 'Configuration'
        #         Importance  = 5
        #         ActionType  = 2
        #         StatusTrue  = 1
        #         StatusFalse = 5
        #     }
        # }
    }
}