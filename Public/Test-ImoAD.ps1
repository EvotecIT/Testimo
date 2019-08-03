function Test-ImoAD {
    [CmdletBinding()]
    param(
        [switch] $ReturnResults
    )
    $Time = Start-TimeLog
    $Script:TestResults = [System.Collections.Generic.List[PSCustomObject]]::new()

    # Imports all commands / including private ones from PSWinDocumentation.AD
    $ADModule = Import-Module PSWinDocumentation.AD -PassThru

    $Forest = Start-TestProcessing -Test 'Forest Information - Is Available' -ExpectedStatus $true -OutputRequired {
        Get-WinADForest
    }
    Start-TestProcessing -Test "Optional features" -Level 1 -Data {
        Get-ForestOptionalFeatures
    } -Tests {
        Test-Value -TestName 'Is Recycle Bin Enabled?' -Property 'Recycle Bin Enabled' -ExpectedValue $true
        Test-Value -TestName 'is Laps Enabled?' -Property 'Laps Enabled' -ExpectedValue $true
    }

    $Replication = Start-TestProcessing -Test "Forest Replication" -Level 1 -ExpectedStatus $true -OutputRequired {
        Get-WinTestReplication -Status $true
    }
    foreach ($_ in $Replication) {
        Test-Value -TestName "Replication from $($_.Server) to $($_.ServerPartner)" -Object $_ -Property 'Status' -ExpectedValue $true -Level 2 -PropertExtendedValue 'StatusMessage'
    }


    $LastBackup = Start-TestProcessing -Test "Forest Last Backup Time" -Level 1 -OutputRequired {
        Get-WinADLastBackup
    }

    foreach ($_ in $LastBackup) {
        #Test-Value -TestName "Replication from $($_.Server) to $($_.ServerPartner)" -Object $_ -Property 'Status' -ExpectedValue $true -Level 2 -PropertExtendedValue 'StatusMessage'
        Test-Value -Level 2 -TestName "Last Backup $($_.NamingContext)" -Object $_ -Property 'LastBackupDaysAgo' -PropertExtendedValue 'LastBackup' -lt -ExpectedValue 2
    }


    foreach ($Domain in $Forest.Domains) {
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

        $DomainInformation = Start-TestProcessing -Test "Domain $Domain - Is Available" -ExpectedStatus $true -OutputRequired -IsTest {
            Get-WinADDomain -Domain $Domain
        }
        $DomainControllers = Start-TestProcessing -Test "Domain Controllers - List is Available" -ExpectedStatus $true -OutputRequired -Level 1 {
            Get-WinADDC -Domain $Domain
        }

        foreach ($_ in $DomainControllers) {
            Start-TestProcessing -Test "Testing LDAP Connectivity" -Level 1 -Data {
                Test-LDAP -ComputerName $_.HostName -WarningAction SilentlyContinue
            } -Tests {
                Test-Array -TestName "Domain Controller - $($_.HostName) | LDAP Port is Available" -Property 'LDAP' -ExpectedValue $true -SearchObjectValue $_.HostName -SearchObjectProperty 'ComputerFQDN'
                Test-Array -TestName "Domain Controller - $($_.HostName) | LDAP SSL Port is Available" -Property 'LDAPS' -ExpectedValue $true -SearchObjectValue $_.HostName -SearchObjectProperty 'ComputerFQDN'
                Test-Array -TestName "Domain Controller - $($_.HostName) | LDAP GC Port is Available" -Property 'GlobalCatalogLDAP' -ExpectedValue $true -SearchObjectValue $_.HostName -SearchObjectProperty 'ComputerFQDN'
                Test-Array -TestName "Domain Controller - $($_.HostName) | LDAP GC SSL Port is Available" -Property 'GlobalCatalogLDAPS' -ExpectedValue $true -SearchObjectValue $_.HostName -SearchObjectProperty 'ComputerFQDN'
            } -Simple
            Start-TestProcessing -Test "Domain Controller - $($_.HostName) | Connectivity Ping $($_.HostName)" -Level 1 -ExpectedStatus $true -IsTest {
                Get-WinTestConnection -Computer $_.HostName
            }
            Start-TestProcessing -Test "Domain Controller - $($_.HostName) | Connectivity Port 53 (DNS)" -Level 1 -ExpectedStatus $true -IsTest {
                Get-WinTestConnectionPort -Computer $_.HostName -Port 53
            }

            $Services = @('ADWS', 'DNS', 'DFS', 'DFSR', 'Eventlog', 'EventSystem', 'KDC', 'LanManWorkstation', 'LanManServer', 'NetLogon', 'NTDS', 'RPCSS', 'SAMSS', 'W32Time')
            Start-TestProcessing -Test "Testing Services - Domain Controller - $($_.HostName)" -Level 1 -Data {
                Get-PSService -Computers $_ -Services $Services
            } -Tests {
                foreach ($Service in $Services) {
                    Test-Array -TestName "Domain Controller - $($_.HostName) | Service $Service Status" -SearchObjectProperty 'Name' -SearchObjectValue $Service -Property 'Status' -ExpectedValue 'Running'
                    Test-Array -TestName "Domain Controller - $($_.HostName) | Service $Service Start Type" -SearchObjectProperty 'Name' -SearchObjectValue $Service -Property 'StartType' -ExpectedValue 'Automatic'
                }
            } -Simple
            Start-TestProcessing -Test "Domain Controller - $($_.HostName) | Responds to PowerShell Queries" -ExpectedStatus $true -IsTest -Level 1 {
                Get-WinADDomain -Domain $_
            }
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