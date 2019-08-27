$Script:SBResolveDNSExternal = {
    $Output = Invoke-Command -ComputerName $DomainController -ErrorAction Stop {
        Resolve-DnsName -Name 'evotec.xyz' -ErrorAction SilentlyContinue
    }
    $Output
}

$Script:SBResolveDNSInternal = {
    #$Domain = 'ad.evotec.xyz'
   # $Domain = 'ad.evotec.pl'; $DomainController = 'adrodc.ad.evotec.pl'

    $Output = Invoke-Command -ComputerName $DomainController -ErrorAction Stop {
        param(
            [string] $DomainController
        )
        $AllDomainControllers = Get-ADDomainController -Identity $DomainController -Server $DomainController
        $IPs = $AllDomainControllers.IPv4Address | Sort-Object
        $Output = Resolve-DnsName -Name $DomainController -ErrorAction SilentlyContinue
        @{
            'Result'      = 'IP Comparison'
            'Status'      = if ($null -eq (Compare-Object -ReferenceObject $IPs -DifferenceObject ($Output.IP4Address | Sort-Object))) { $true } else { $false }
            'IPAddresses' = $Output.IP4Address
        }
    } -ArgumentList $DomainController
    $Output
}

#$DomainController = 'AD1'
#& $Script:SBResolveDNSInternal  #-Domain 'ad.evotec.xyz'
<#

$Domain = 'ad.evotec.pl'
$DomainController = 'AD1'
$AllDomainControllers = Get-ADDomainController -Identity $DomainController -Server $DomainController
$IPs = $AllDomainControllers.IPv4Address | Sort-Object
$Output = Resolve-DnsName -Name $DomainController -ErrorAction SilentlyContinue

$Output.IP4Address -contains $IPs
@{
    'Result'      = 'IP Comparison'
    'Status'      = if ($null -eq (Compare-Object -ReferenceObject $IPs -DifferenceObject ($Output.IP4Address | Sort-Object))) { $true } else { $false }
    'IPAddresses' = $Output.IP4Address
}
#>


#& $Script:SBResolveDNSInternal #-Domain 'ad.evotec.pl' -DomainController 'adrodc.ad.evotec.pl'