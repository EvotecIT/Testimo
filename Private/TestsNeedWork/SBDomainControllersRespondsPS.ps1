<#
$Script:SBDomainControllersRespondsPS = {
    param(
        $DomainController
    )
    Start-TestProcessing -Test "Domain Controller - $($DomainController.HostName) | Responds to PowerShell Queries" -ExpectedStatus $true -IsTest -Level 1 {
        Get-WinADDomain -Domain $DomainController
    }
}

#>


$Script:SBDomainControllersRespondsPS = {
    Get-WinADDomain -Domain $DomainController
}

$Script:SBDomainControllersRespondsPSTest = {

}