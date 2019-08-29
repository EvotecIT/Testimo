$Script:SBDomainControllersTimeSettings = {
    Get-TimeSetttings -ComputerName $DomainController -Domain $Domain
}

#Get-TimeSetttings -ComputerName Ad1,AD2,AD3 -Domain 'ad.evotec.xyz' | ft -a *