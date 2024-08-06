$ComputersUnsupported = @{
    Name   = 'DomainComputersUnsupported'
    Enable = $true
    Scope  = 'Domain'
    Source = @{
        Name           = "Computers Unsupported"
        Data           = {
            $Computers = Get-ADComputer -Filter { ( operatingsystem -like "*xp*") -or (operatingsystem -like "*vista*") -or ( operatingsystem -like "*Windows NT*") -or ( operatingsystem -like "*2000*") -or ( operatingsystem -like "*2003*") } -Property Name, OperatingSystem, OperatingSystemServicePack, lastlogontimestamp -Server $Domain
            $Computers | Select-Object Name, OperatingSystem, OperatingSystemServicePack, @{name = "lastlogontimestamp"; expression = { [datetime]::fromfiletime($_.lastlogontimestamp) } }
        }
        Details        = [ordered] @{
            Area        = 'Objects'
            Category    = 'Cleanup'
            Importance  = 3
            Description = 'Computers running an unsupported operating system.'
            Resolution  = 'Upgrade or remove computers from Domain.'
            Resources   = @()
        }
        ExpectedOutput = $false
    }
}