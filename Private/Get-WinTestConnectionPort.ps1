function Get-WinTestConnectionPort {
    [CmdletBinding()]
    param(
        [string] $Computer,
        [int] $Port
    )
    try {
        $Output = Test-NetConnection -ComputerName $Computer -WarningAction SilentlyContinue -Port $Port
        if ($Output.TcpTestSucceeded) {
            [ordered] @{ Status = $true; Output = $Output; Extended = "Port available for connection." }
        } else {
            [ordered] @{ Status = $false; Output = $Output; Extended = "$($Output.PingReplyDetails.Status) - $($Output.PingReplyDetails.Address)" }
        }
    } catch {
        $ErrorMessage = $_.Exception.Message -replace "`n", " " -replace "`r", " "
        [ordered] @{ Status = $false; Output = @(); Extended = $ErrorMessage }
    }
}

function Get-WinTestIsLapsAvailable {
    [CmdletBinding()]
    param(

    )

    $ADModule = Import-Module PSWinDocumentation.AD -PassThru
    $ComputerProperties = & $ADModule { Get-WinADForestSchemaPropertiesComputers }
    if ($ComputerProperties.Name -contains 'ms-Mcs-AdmPwd') {
        [ordered] @{ Status = $true; Output = ''; Extended = "LAPS schema properties are available." }
    } else {
        [ordered] @{ Status = $false; Output = ''; Extended = "LAPS schema properties are missing." }
    }
}



$Script:Tests = @{
    ForestInformation                                     = @{

    }
    DomainControllers                                     = @{

    }
    DomainControllersPing                                 = @{

    }
    DomainControllersPort53                               = @{

    }
    DomainControllersServiceDNSServer                     = @{

    }
    DomainControllersServiceActiveDirectoryDomainServices = @{

    }
    DomainControllersServiceActiveDirectoryWebServices    = @{

    }
    DomainControllersServiceKerberosKeyDistributionCenter = @{

    }
    DomainControllersServiceNetlogon                      = @{

    }
    LAPS                                                  = @{

    }

}