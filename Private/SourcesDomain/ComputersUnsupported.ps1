$ComputersUnsupported = @{
    Name   = 'DomainComputersUnsupported'
    Enable = $true
    Scope  = 'Domain'
    Source = @{
        Name           = "Computers Unsupported"
        Data           = {
            $Computers = Get-ADComputer -Filter { (Get-operatingsystem -like "*xp*") -or (Get-operatingsystem -like "*vista*") -or (Get-operatingsystem -like "*Windows NT*") -or (Get-operatingsystem -like "*2000*") -or (Get-operatingsystem -like "*2003*") } -Property Name, OperatingSystem, OperatingSystemServicePack, lastlogontimestamp -Server $Domain
            $Computers | Select-Object Name, OperatingSystem, OperatingSystemServicePack, @{name = "lastlogontimestamp"; expression = { [datetime]::fromfiletime($_.lastlogontimestamp) } }
        }
        Details        = [ordered] @{
            Area        = 'Cleanup'
            Category    = ''
            Severity    = ''
            Importance  = 0
            Description = 'Computers running an unsupported operating system.'
            Resolution  = 'Upgrade or remove computers from Domain.'
            Resources   = @(

            )
        }
        ExpectedOutput = $false
    }
}