$Script:SBSysvolMode = {
    $DistinguishedName = (Get-ADDomain -Server $Domain).DistinguishedName
    $Object = "CN=DFSR-GlobalSettings,CN=System,$DistinguishedName"
    $Object = Get-ADObject -Identity $ADObj -Properties * -Server $Domain
    if ($Object.'msDFSR-Flags' -gt 47) {
        [PSCustomObject] @{
            'SysvolMode' = 'DFS-R'
        }
    } else {
        [PSCustomObject] @{
            'SysvolMode' = 'Not DFS-R'
        }
    }
}