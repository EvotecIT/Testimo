function ConvertTo-Source {
    [CmdletBinding()]
    param(
        [string] $Source
    )
    if ($Source.StartsWith('Forest', [System.StringComparison]::CurrentCultureIgnoreCase)) {
        $ProperSource = [ordered] @{
            Scope = 'Forest'
            Name  = $Source -replace '^Forest'
        }
    } elseif ($Source.StartsWith('Domain', [System.StringComparison]::CurrentCultureIgnoreCase)) {
        $ProperSource = [ordered] @{
            Scope = 'Domain'
            Name  = $Source -replace '^Domain'
        }
    } elseif ($Source.StartsWith('DC', [System.StringComparison]::CurrentCultureIgnoreCase)) {
        $ProperSource = [ordered] @{
            Scope = 'DomainControllers'
            Name  = $Source -replace '^DC'
        }
    }
    return $ProperSource
}