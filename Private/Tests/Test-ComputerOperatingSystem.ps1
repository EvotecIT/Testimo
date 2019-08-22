$Script:ComputerOperatingSystem = {
    Get-ComputerOperatingSystem -ComputerName $DomainController -WarningAction SilentlyContinue
}