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
            $Output = (($Hosts | Where-Object { $_.HostName -eq '@' }).RecordData.NameServer) -replace ".$"
            $Compare = (Compare-Object -ReferenceObject $AllDomainControllers -DifferenceObject $Output)

            [PSCustomObject] @{
                DomainControllers = $AllDomainControllers
                NameServers       = $Output
                Status            = $null -eq $Compare
                Comment           = $null
            }
        } catch {
            [PSCustomObject] @{
                DomainControllers = $AllDomainControllers
                NameServers       = $null
                Status            = $null -eq $Compare
                Comment           = $_.Exception.Message
            }
        }

    }
}

$Script:SBServerDnsNameServers = {
    Test-DNSNameServers @args
}

#$Test = Test-DNSNameServers -DomainController DC1 -Domain 'ad.evotec.pl'
#$Test

#Test-DNSNameServers



#$ScriptBlock = { get-vm }