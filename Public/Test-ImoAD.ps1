function Test-ImoAD {
    [CmdletBinding()]
    param(
        [switch] $ReturnResults
    )
    $Time = Start-TimeLog
    $Script:TestResults = [System.Collections.Generic.List[PSCustomObject]]::new()

    # Imports all commands / including private ones from PSWinDocumentation.AD
    $ADModule = Import-Module PSWinDocumentation.AD -PassThru

    $Forest = & $Script:SBForest

    #& $Script:SBForestOptionalFeatures
    #& $Script:SBForestReplication
    #& $Script:SBForestLastBackup

    foreach ($Domain in $Forest.Domains) {
        #& $Script:SBDomainPasswordComplexity -Domain $Domain
        #& $Script:SBDomainTrusts -Domain $Domain

        $DomainInformation = & $Script:SBDomainInformation -Domain $Domain

        $DomainControllers = & $Script:SBDomainControllers -Domain $Domain

        foreach ($_ in $DomainControllers) {
            & $Script:SBDomainControllersLDAP -DomainController $_
            <#
            Start-TestProcessing -Test "Testing LDAP Connectivity" -Level 1 -Data {
                Test-LDAP -ComputerName $_.HostName -WarningAction SilentlyContinue
            } -Tests {
                Test-Array -TestName "Domain Controller - $($_.HostName) | LDAP Port is Available" -Property 'LDAP' -ExpectedValue $true -SearchObjectValue $_.HostName -SearchObjectProperty 'ComputerFQDN'
                Test-Array -TestName "Domain Controller - $($_.HostName) | LDAP SSL Port is Available" -Property 'LDAPS' -ExpectedValue $true -SearchObjectValue $_.HostName -SearchObjectProperty 'ComputerFQDN'
                Test-Array -TestName "Domain Controller - $($_.HostName) | LDAP GC Port is Available" -Property 'GlobalCatalogLDAP' -ExpectedValue $true -SearchObjectValue $_.HostName -SearchObjectProperty 'ComputerFQDN'
                Test-Array -TestName "Domain Controller - $($_.HostName) | LDAP GC SSL Port is Available" -Property 'GlobalCatalogLDAPS' -ExpectedValue $true -SearchObjectValue $_.HostName -SearchObjectProperty 'ComputerFQDN'
            }
            #>

            & $Script:SBDomainControllersPing -DomainController $_
            & $Script:SBDomainControllersPort53 -DomainController $_

            <#
            Start-TestProcessing -Test "Domain Controller - $($_.HostName) | Connectivity Ping $($_.HostName)" -Level 1 -ExpectedStatus $true -IsTest {
                Get-WinTestConnection -Computer $_.HostName
            }
            Start-TestProcessing -Test "Domain Controller - $($_.HostName) | Connectivity Port 53 (DNS)" -Level 1 -ExpectedStatus $true -IsTest {
                Get-WinTestConnectionPort -Computer $_.HostName -Port 53
            }
            #>

            & $Script:SBDomainControllersServices -DomainController $_
            <#
            $Services = @('ADWS', 'DNS', 'DFS', 'DFSR', 'Eventlog', 'EventSystem', 'KDC', 'LanManWorkstation', 'LanManServer', 'NetLogon', 'NTDS', 'RPCSS', 'SAMSS', 'W32Time')
            Start-TestProcessing -Test "Testing Services - Domain Controller - $($_.HostName)" -Level 1 -Data {
                Get-PSService -Computers $_ -Services $Services
            } -Tests {
                foreach ($Service in $Services) {
                    Test-Array -TestName "Domain Controller - $($_.HostName) | Service $Service Status" -SearchObjectProperty 'Name' -SearchObjectValue $Service -Property 'Status' -ExpectedValue 'Running'
                    Test-Array -TestName "Domain Controller - $($_.HostName) | Service $Service Start Type" -SearchObjectProperty 'Name' -SearchObjectValue $Service -Property 'StartType' -ExpectedValue 'Automatic'
                }
            }
            #>
            & $Script:SBDomainControllersRespondsPS -DomainController $_

            <#
            Start-TestProcessing -Test "Domain Controller - $($_.HostName) | Responds to PowerShell Queries" -ExpectedStatus $true -IsTest -Level 1 {
                Get-WinADDomain -Domain $_
            }
            #>
        }
    }
    $TestsPassed = (($Script:TestResults) | Where-Object { $_.Status -eq $true }).Count
    $TestsFailed = (($Script:TestResults) | Where-Object { $_.Status -eq $false }).Count
    $TestsSkipped = 0
    #$TestsInformational = 0

    $EndTime = Stop-TimeLog -Time $Time -Option OneLiner

    Write-Color -Text '[i] ', 'Time to execute tests: ', $EndTime -Color Yellow, DarkGray, Cyan
    Write-Color -Text '[i] ', 'Tests Passed: ', $TestsPassed, ' Tests Failed: ', $TestsFailed, ' Tests Skipped: ', $TestsSkipped -Color Yellow, DarkGray, Green, DarkGray, Red, DarkGray, Cyan

    # This results informaiton in form of Array for future processing
    if ($ReturnResults) {
        $Script:TestResults
    }
}