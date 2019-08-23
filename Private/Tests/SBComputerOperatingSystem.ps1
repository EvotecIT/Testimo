$Script:SBComputerOperatingSystem = {
    Get-ComputerOperatingSystem -ComputerName $DomainController -WarningAction SilentlyContinue
}