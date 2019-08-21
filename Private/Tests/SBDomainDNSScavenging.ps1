$Script:SBDomainDNSScavenging = {
    $PSWinDocumentationDNS = Import-Module PSWinDocumentation.DNS -PassThru

    & $PSWinDocumentationDNS {
        param($Domain)
        # this gets all DNS Servers but limits it only to those repsponsible for scavenging
        # There should be only 1 such server

        $Object = Get-WinDnsServerScavenging -Domain $Domain
        $Object | Where-Object { $_.ScavengingInterval -ne 0 -and $null -ne $_.ScavengingInterval }

    } $Domain
}