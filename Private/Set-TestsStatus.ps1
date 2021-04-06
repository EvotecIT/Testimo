function Set-TestsStatus {
    [CmdletBinding()]
    param(
        [string[]] $Sources,
        [string[]] $ExcludeSources
    )
    foreach ($Source in $Script:TestimoConfiguration.ActiveDirectory.Keys) {
        $Script:TestimoConfiguration.ActiveDirectory[$Source]['Enable'] = $false
    }
    foreach ($Source in $Sources) {
        $Script:TestimoConfiguration.ActiveDirectory[$Source]['Enable'] = $true
    }
    foreach ($Source in $ExcludeSources) {
        $Script:TestimoConfiguration.ActiveDirectory[$Source]['Enable'] = $false
    }
}