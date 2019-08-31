function Test-DNSNameServers {
    [cmdletBinding()]
    param(
        [string] $DomainController,
        [string] $Domain
    )
    if ($DomainController) {
        $AllDomainControllers = (Get-ADDomainController -Server $Domain -Filter { IsReadOnly -eq $false } ).HostName
        try {
            $Hosts = Get-DnsServerResourceRecord -ZoneName $Domain -ComputerName $DomainController -RRType NS -ErrorAction Stop
            $NameServers = (($Hosts | Where-Object { $_.HostName -eq '@' }).RecordData.NameServer) -replace ".$"
            $Compare = ((Compare-Object -ReferenceObject $AllDomainControllers -DifferenceObject $NameServers -IncludeEqual).SideIndicator -notin @('=>', '<='))

            [PSCustomObject] @{
                DomainControllers = $AllDomainControllers
                NameServers       = $NameServers
                Status            = $Compare
                Comment           = "Name servers found $($NameServers -join ', ')"
            }
        } catch {
            [PSCustomObject] @{
                DomainControllers = $AllDomainControllers
                NameServers       = $null
                Status            = $false
                Comment           = $_.Exception.Message
            }
        }

    }
}