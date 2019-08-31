$Script:SBDomainDNSForwaders = {
    $PSWinDocumentationDNS = Import-Module PSWinDocumentation.DNS -PassThru

    & $PSWinDocumentationDNS {
        param($Domain)
        $Forwarders = Get-WinDnsServerForwarder -Domain $Domain -WarningAction SilentlyContinue
        Compare-MultipleObjects -Objects $Forwarders -FormatOutput -CompareSorted:$true -ExcludeProperty GatheredFrom -SkipProperties -Property 'IpAddress' #| Out-HtmlView -ScrollX -DisablePaging  -Filtering
    } $Domain
}