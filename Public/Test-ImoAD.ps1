function Test-ImoAD {
    [CmdletBinding()]
    param(

    )
    <#
    $Forest = Start-TestProcessing -Test 'Forest Information - Is Available' -ExpectedStatus $true -OutputRequired {
        Get-WinADForest
    }
    foreach ($Domain in $Forest.Domains) {
        $DomainInformation = Start-TestProcessing -Test "Domain $Domain - Is Available" -ExpectedStatus $true -OutputRequired -Level 1 -IsTest {
            Get-WinADDomain -Domain $Domain
        }
        $DomainControllers = Start-TestProcessing -Test "Domain Controllers - List is Available" -ExpectedStatus $true -OutputRequired -Level 2 {
            Get-WinADDC -Domain $Domain
        }
        foreach ($_ in $DomainControllers) {
            Start-TestProcessing -Test "Domain Controller - $($_.HostName) | Connectivity Ping $($_.HostName)" -Level 2 -ExpectedStatus $true -IsTest {
                Get-WinTestConnection -Computer $_.HostName
            }
            Start-TestProcessing -Test "Domain Controller - $($_.HostName) | Connectivity Port 53 (DNS)" -Level 2 -ExpectedStatus $true -IsTest {
                Get-WinTestConnectionPort -Computer $_.HostName -Port 53
            }
            Start-TestProcessing -Test "Domain Controller - $($_.HostName) | Service 'DNS Server'" -Level 2 -ExpectedStatus $true -IsTest {
                Get-WinTestService -Computer $_.HostName -Service 'DNS Server' -Status 'Running'
            }
            Start-TestProcessing -Test "Domain Controller - $($_.HostName) | Service 'Active Directory Domain Services'" -Level 2 -ExpectedStatus $true -IsTest {
                Get-WinTestService -Computer $_.HostName -Service 'Active Directory Domain Services' -Status 'Running'
            }
            Start-TestProcessing -Test "Domain Controller - $($_.HostName) | Service 'Active Directory Web Services'" -Level 2 -ExpectedStatus $true -IsTest {
                Get-WinTestService -Computer $_.HostName -Service 'Active Directory Web Services' -Status 'Running'
            }
            Start-TestProcessing -Test "Domain Controller - $($_.HostName) | Service 'Kerberos Key Distribution Center'" -Level 2 -ExpectedStatus $true -IsTest {
                Get-WinTestService -Computer $_.HostName -Service 'Kerberos Key Distribution Center' -Status 'Running'
            }
            Start-TestProcessing -Test "Domain Controller - $($_.HostName) | Service 'Netlogon'" -Level 2 -ExpectedStatus $true -IsTest {
                Get-WinTestService -Computer $_.HostName -Service 'Netlogon' -Status 'Running'
            }
        }
    }
    $Replication = Start-TestProcessing -Test "Forest Replication" -Level 1 -ExpectedStatus $true -OutputRequired {
        Get-WinTestReplication -Status $true
    }
    foreach ($_ in $Replication) {
        Start-TestProcessing -Test "Replication from $($_.Server) to $($_.ServerPartner)" -Level 2 -ExpectedStatus $true -IsTest {
            Get-WinTestReplicationSingular -Replication $_
        }
    }
    Start-TestProcessing -Test "Is LAPS Available" -Level 1 -ExpectedStatus $true -IsTest {
        Get-WinTestIsLapsAvailable
    }
    #>
    $OptionalFeatures = Start-TestProcessing -Test "Is LAPS Available" -Level 1 -ExpectedStatus $true {
        Get-TestForestOptionalFeatures
    }
    Start-TestProcessing -Test "RecycleBin Enabled" -Level 1 -ExpectedStatus $true -OutputRequired -IsTest {
        $OptionalFeatures.'Recycle Bin Enabled'
    }
    Start-TestProcessing -Test "LAPS Available" -Level 1 -ExpectedStatus $true -OutputRequired -IsTest {
        $Optional.'Laps Enabled'
    }
}



function Start-Verification {
    [CmdletBinding()]
    param(
        [ScriptBlock] $Execute
    )

}

function Test-Value {
    param(
        [Object] $Object,
        [string] $Property,
        [Object] $ExpectedValue
    )

    if ($Object.$Property -eq $ExpectedValue) {

    }
}

function Get-TestForestOptionalFeatures {
    [CmdletBinding()]
    param(

    )
    try {
        $ADModule = Import-Module PSWinDocumentation.AD -PassThru
        try {
            $OptionalFeatures = & $ADModule { Get-WinADForestOptionalFeatures -WarningAction SilentlyContinue }
        } catch {
            $ErrorMessage = $_.Exception.Message -replace "`n", " " -replace "`r", " "
        }

        if ($OptionalFeatures.Count -gt 0) {
            [ordered] @{ Status = $true; Output = $OptionalFeatures; Extended = "" }
        } else {
            [ordered] @{ Status = $false; Output = $OptionalFeatures; Extended = $ErrorMessage }
        }
    } catch {
        $ErrorMessage = $_.Exception.Message -replace "`n", " " -replace "`r", " "
        [ordered] @{ Status = $false; Output = @(); Extended = $ErrorMessage }
    }
}