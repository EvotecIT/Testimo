$Script:SBResolveDNSExternal = {
    $Output = Invoke-Command -ComputerName $DomainController {
        Resolve-DnsName -Name 'evotec.xyz'
    }
    $Output
}

$Script:SBResolveDNSInternal = {
    $AllDomainControllers = Get-ADDomainController -Filter * -Server $Domain
    $IPs = $AllDomainControllers.IPv4Address | Sort-Object
    $Output = Resolve-DnsName -Name $Domain
    @{
        'Result' = 'IP Comparison'
        'Status' = if ($null -eq (Compare-Object -ReferenceObject $IPs -DifferenceObject ($Output.IP4Address | Sort-Object))) { $true } else { $false }
    }
}