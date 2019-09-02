function Test-ADSiteLinks {
    [cmdletBinding()]
    param(
        [string] $Splitter
    )
    [Array] $SiteLinks = Get-WinADSiteConnections
    $Collection = @($SiteLinks).Where( { $_.Options -notcontains 'IsGenerated' -and $_.EnabledConnection -eq $true }, 'Split')
    $LinksManual = foreach ($Link in $Collection[0]) {
        "$($Link.ServerFrom) to $($Link.ServerTo)"
    }
    $LinksAutomatic = foreach ($Link in $Collection[1]) {
        "$($Link.ServerFrom) to $($Link.ServerTo)"
    }
    $CollectionNotifications = @($SiteLinks).Where( { $_.Options -notcontains 'UseNotify' -and $_.EnabledConnection -eq $true }, 'Split')
    $LinksNotUsingNotifications = foreach ($Link in $CollectionNotifications[0]) {
        "$($Link.ServerFrom) to $($Link.ServerTo)"
    }
    $LinksUsingNotifications = foreach ($Link in $CollectionNotifications[1]) {
        "$($Link.ServerFrom) to $($Link.ServerTo)"
    }
    [ordered] @{
        SiteLinksManual              = if ($Splitter -eq '') { $LinksManual } else { $LinksManual -join $Splitter }
        SiteLinksAutomatic           = if ($Splitter -eq '') { $LinksAutomatic } else { $LinksAutomatic -join $Splitter }
        SiteLinksUseNotify           = if ($Splitter -eq '') { $LinksUsingNotifications } else { $LinksUsingNotifications -join $Splitter }
        SiteLinksNotUsingNotify      = if ($Splitter -eq '') { $LinksNotUsingNotifications } else { $LinksNotUsingNotifications -join $Splitter }
        SiteLinksUseNotifyCount      = $CollectionNotifications[1].Count
        SiteLinksNotUsingNotifyCount = $CollectionNotifications[0].Count
        SiteLinksManualCount         = $Collection[0].Count
        SiteLinksAutomaticCount      = $Collection[1].Count
        SiteLinksTotalCount          = ($SiteLinks | Where-Object { $_.EnabledConnection -eq $true } ).Count
    }
}