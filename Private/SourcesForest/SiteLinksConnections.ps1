$SiteLinksConnections = @{
    Enable = $true
    Scope  = 'Forest'
    Source = @{
        Name           = 'Site Links Connections'
        Data           = {
            Test-ADSiteLinks -Splitter ', ' -Forest $ForestName
        }
        Details        = [ordered] @{
            Area        = 'Configuration'
            Category    = 'Sites'
            Description = ''
            Resolution  = ''
            RiskLevel   = 10
            Severity    = 'Informational'
            Resources   = @(

            )
        }
        ExpectedOutput = $true
    }
    Tests  = [ordered] @{
        AutomaticSiteLinks              = @{
            Enable      = $true
            Name        = 'All site links are automatic'
            Description = 'Verify there are no manually configured sitelinks'
            Parameters  = @{
                Property      = 'SiteLinksManualCount'
                ExpectedValue = 0
                OperationType = 'eq'
            }
        }
        SiteLinksCrossSiteNotifications = @{
            Enable     = $true
            Name       = 'All cross-site links use notifications'
            Parameters = @{
                Property      = 'SiteLinksCrossSiteNotUseNotifyCount'
                ExpectedValue = 0
                OperationType = 'eq'
            }
        }
        SiteLinksSameSiteNotifications  = @{
            Enable     = $true
            Name       = 'All same-site links have no notifications'
            Parameters = @{
                Property      = 'SiteLinksSameSiteUseNotifyCount'
                ExpectedValue = 0
                OperationType = 'eq'
            }
        }
        NoDisabledLinks                 = @{
            Enable     = $true
            Name       = 'All links are enabled'
            Parameters = @{
                Property      = 'SiteLinksDisabledCount'
                ExpectedValue = 0
                OperationType = 'eq'
            }
        }
    }
}