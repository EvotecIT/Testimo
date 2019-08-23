$Script:TestWindowsUpdates = {
    #$Hosts = 'AD1', 'AD2'
    #$Hosts = 'AD1'
    Get-HotFix -ComputerName $DomainController | Sort-Object -Property InstalledOn -Descending | Select-Object -First 1  #| Where-Object { $_.InstalledOn -gt ((Get-Date).AddDays(-30)) }

    <#

    Source        Description      HotFixID      InstalledBy          InstalledOn
    ------        -----------      --------      -----------          -----------
    AD1           Update           KB4507459     NT AUTHORITY\SYSTEM  27.07.2019 00:00:00
    #>
}