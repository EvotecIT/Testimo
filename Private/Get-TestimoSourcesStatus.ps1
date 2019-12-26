function Get-TestimoSourcesStatus {
    [cmdletbinding()]
    param(
        [string] $Scope
    )
    $AllTests = foreach ($Source in $($Script:TestimoConfiguration.$Scope.Keys)) {
        $Script:TestimoConfiguration["$Scope"]["$Source"].Enable
    }
    $AllTests -contains $true
}