<#
$Script:SBDomainTrusts = {
    param(
        [string] $Domain
    )

    $Trusts = Start-TestProcessing -Test "Testing Trusts Availability" -Level 1 -OutputRequired {
        & $ADModule { param($Domain); Get-WinADDomainTrusts -Domain $Domain } $Domain
    }
    # All trusts should be OK
    foreach ($_ in $Trusts) {
        Test-Value -TestName "Trust status verification | Source $Domain, Target $($_.'Trust Target'), Direction $($_.'Trust Direction')" -Level 2 -Object $_ -Property 'Trust Status' -ExpectedValue 'OK'
    }
    # TGTDelegation as per https://blogs.technet.microsoft.com/askpfeplat/2019/04/11/changes-to-ticket-granting-ticket-tgt-delegation-across-trusts-in-windows-server-askpfeplat-edition/
    # TGTDelegation should be set to $True (contrary to name)
    foreach ($_ in $Trusts) {
        if ($($_.'Trust Direction' -eq 'BiDirectional' -or $_.'Trust Direction' -eq 'InBound')) {
            Test-Value -TestName "Trust Unconstrained TGTDelegation | Source $Domain, Target $($_.'Trust Target'), Direction $($_.'Trust Direction')" -Level 2 -Object $_ -Property 'TGTDelegation' -ExpectedValue $True
        }
    }
}
#>

$Script:SBDomainTrustsData = {
    & $ADModule {
        param($Domain);
        Get-WinADDomainTrusts -Domain $Domain
    } $Domain @args
}
$Script:SBDomainTrustsConnectivity = {
    # All trusts should be OK
    Test-Value -TestName "Trust status verification | Source $Domain, Target $($_.'Trust Target'), Direction $($_.'Trust Direction')" -Property 'Trust Status' -ExpectedValue 'OK' @args
}

$Script:SBDomainTrustsUnconstrainedDelegation = {
    # TGTDelegation as per https://blogs.technet.microsoft.com/askpfeplat/2019/04/11/changes-to-ticket-granting-ticket-tgt-delegation-across-trusts-in-windows-server-askpfeplat-edition/
    # TGTDelegation should be set to $True (contrary to name)
    if ($($Object.'Trust Direction' -eq 'BiDirectional' -or $Object.'Trust Direction' -eq 'InBound')) {
        Test-Value -TestName "Trust Unconstrained TGTDelegation | Source $Domain, Target $($_.'Trust Target'), Direction $($_.'Trust Direction')" -Property 'TGTDelegation' -ExpectedValue $True @args
    }
}