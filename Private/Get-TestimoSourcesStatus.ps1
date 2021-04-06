function Get-TestimoSourcesStatus {
    [cmdletbinding()]
    param(
        [string] $Scope
    )
    $AllTests = foreach ($Source in $($Script:TestimoConfiguration.ActiveDirectory.Keys)) {
        if ($Scope -ne $Script:TestimoConfiguration.ActiveDirectory[$Source].Scope) {
            continue
        }
        $Script:TestimoConfiguration.ActiveDirectory["$Source"].Enable
    }
    $AllTests -contains $true
}