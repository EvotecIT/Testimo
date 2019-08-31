$Script:SBDomainDnsZones = {
    $PSWinDocumentationDNS = Import-Module PSWinDocumentation.DNS -PassThru

    & $PSWinDocumentationDNS {
        param($Domain)
        $Zones = Get-WinDnsServerZones -ZoneName $Domain -Domain $Domain
        Compare-MultipleObjects -Objects $Zones -FormatOutput -CompareSorted:$true -ExcludeProperty GatheredFrom -SkipProperties -Property 'AgingEnabled'
    } $Domain
}