$Script:SBDomainDnsZones = {
    $PSWinDocumentationDNS = Import-Module PSWinDocumentation.DNS -PassThru

    & $PSWinDocumentationDNS {
        param($Domain)
        $Zones = Get-WinDnsServerZones -ZoneName $Domain -Domain $Domain
        Compare-MultipleObjects -Objects $Zones -FormatOutput -CompareSorted:$true -ExcludeProperty GatheredFrom -SkipProperties -Property 'AgingEnabled'
    } $Domain
}

$Script:SBDomainDnsZonesTestEnabled = {
    Test-Value -TestName 'Zone DNS aging should be enabled' @args
}
$Script:SBDomainDnsZonesTestIdentical = {
    Test-Value -TestName 'Zone DNS aging should be identical on all DCs' @args
}