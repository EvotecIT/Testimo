<#
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
#>


$Script:SBDomainControllersServices = {
    $Services = @('ADWS', 'DNS', 'DFS', 'DFSR', 'Eventlog', 'EventSystem', 'KDC', 'LanManWorkstation', 'LanManServer', 'NetLogon', 'NTDS', 'RPCSS', 'SAMSS', 'W32Time')
    Get-PSService -Computers $DomainController -Services $Services
}

$Script:SBDomainControllersServicesTestStatus = {
    foreach ($_ in $Object) {
        # 12
        Test-Value -TestName "Service $($_.Name) Status" -Property 'Status' -Object $_ -ExpectedValue 'Running' -Level $LevelTest -Domain $Domain -DomainController $DomainController   #-SearchObjectProperty 'Name' -SearchObjectValue $Service -Property 'Status' -ExpectedValue 'Running'
    }
}

$Script:SBDomainControllersServicesTestStartType = {
    foreach ($_ in $Object) {
        # 12
        Test-Value -TestName "Service $($_.Name) Start Type" -Property 'StartType' -Object $_ -ExpectedValue 'Automatic' -Level $LevelTest -Domain $Domain -DomainController $DomainController #-SearchObjectProperty 'Name' -SearchObjectValue $Service -Property 'StartType' -ExpectedValue 'Automatic'
    }
}