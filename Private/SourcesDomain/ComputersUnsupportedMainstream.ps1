$ComputersUnsupportedMainstream = @{
    Enable = $true
    Scope  = 'Domain'
    Source = @{
        Name           = "Computers Unsupported Mainstream Only"
        Data           = {
            $Computers = Get-ADComputer -Filter { (operatingsystem -like "*2008*") } -Property Name, OperatingSystem, OperatingSystemServicePack, lastlogontimestamp -Server $Domain
            $Computers | Select-Object Name, OperatingSystem, OperatingSystemServicePack, @{name = "lastlogontimestamp"; expression = { [datetime]::fromfiletime($_.lastlogontimestamp) } }
        }
        Details        = [ordered] @{
            Area        = 'Cleanup'
            Category    = ''
            Severity    = ''
            Importance   = 0
            Description = 'Computers running an unsupported operating system, but with possibly Microsoft support.'
            Resolution  = 'Consider upgrading computers running Windows Server 2008 or Windows Server 2008 R2 to a version that still offers mainstream support from Microsoft.'
            Resources   = @(

            )
        }
        ExpectedOutput = $false
    }
}