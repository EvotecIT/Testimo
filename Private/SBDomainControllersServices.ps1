$Script:SBDomainControllersServices = {
    param(
        $DomainController
    )
    $Services = @('ADWS', 'DNS', 'DFS', 'DFSR', 'Eventlog', 'EventSystem', 'KDC', 'LanManWorkstation', 'LanManServer', 'NetLogon', 'NTDS', 'RPCSS', 'SAMSS', 'W32Time')
    Start-TestProcessing -Test "Testing Services - Domain Controller - $($DomainController.HostName)" -Level 1 -Data {
        Get-PSService -Computers $DomainController -Services $Services
    } -Tests {
        foreach ($Service in $Services) {
            Test-Array -TestName "Domain Controller - $($DomainController.HostName) | Service $Service Status" -SearchObjectProperty 'Name' -SearchObjectValue $Service -Property 'Status' -ExpectedValue 'Running'
            Test-Array -TestName "Domain Controller - $($DomainController.HostName) | Service $Service Start Type" -SearchObjectProperty 'Name' -SearchObjectValue $Service -Property 'StartType' -ExpectedValue 'Automatic'
        }
    }
}