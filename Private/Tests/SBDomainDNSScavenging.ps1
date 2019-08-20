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

<#
$Script:SBDomainDNSScavengingTest0 = {
    Test-Value -TestName 'Scavenging DNS Servers Count' @args # ExpectedCount eq 1
}

$Script:SBDomainDNSScavengingTest1 = {
    Test-Value -TestName 'Scavenging Interval' -Property 'ScavengingInterval', 'Days' @args # ExpectedValue le 7
}

$Script:SBDomainDnsScavengingTest2 = {
    # ScavengingState True means it's enabled for all new zones
    Test-Value -TestName 'Scavenging State' -Property 'ScavengingState' @args
}

$Script:SBDomainDnsScavengingTest3 = {
    Test-Value -TestName 'Last Scavenge Time' -Property 'LastScavengeTime' @args
}
#>