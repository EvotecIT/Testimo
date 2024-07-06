function Get-TestimoSourcesStatus {
    <#
    .SYNOPSIS
    Retrieves the status of Testimo sources based on the specified scope.

    .DESCRIPTION
    This function retrieves the status of Testimo sources based on the specified scope. It checks if any Testimo source within the specified scope is enabled.

    .PARAMETER Scope
    Specifies the scope for which the Testimo sources status should be retrieved.

    .EXAMPLE
    Get-TestimoSourcesStatus -Scope "Global"
    Retrieves the status of Testimo sources within the Global scope.

    .EXAMPLE
    Get-TestimoSourcesStatus -Scope "Local"
    Retrieves the status of Testimo sources within the Local scope.
    #>
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