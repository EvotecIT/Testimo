
function Test-ADSites {
    param(

    )
    $ADModule = Import-Module PSWinDocumentation.AD -PassThru
    $Sites = & $ADModule { Get-WinADForestSites }

    [Array] $SitesWithoutDC = $Sites | Where-Object { $_.DomainControllersCount -eq 0 }
    [Array] $SitesWithoutSubnets = $Sites | Where-Object { $_.SubnetsCount -eq 0 }

    [PSCustomObject] @{
        SitesWithoutDC          = $SitesWithoutDC.Count
        SitesWithoutSubnets     = $SitesWithoutSubnets.Count
        SitesWithoutDCName      = $SitesWithoutDC.Name -join ', '
        SitesWithoutSubnetsName = $SitesWithoutSubnets.Name -join ', '
    }
}


$Script:SBForestSites = {
    Test-ADSites
}
<#
$Script:SBForestSitesTest1 = {
    Test-Value @args
}
$Script:SBForestSitesTest2 = {
    Test-Value @args
}
#>