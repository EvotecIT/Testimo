function ConvertTo-Source {
    param(
        [string] $Source
    )
    if ($Source.StartsWith('Forest')) {
        $ProperSource = [ordered] @{
            Scope = 'Forest'
            Name  = $Source -replace '^Forest'
        }
    } elseif ($Source.StartsWith('Domain')) {
        $ProperSource = [ordered] @{
            Scope = 'Domain'
            Name  = $Source -replace '^Domain'
        }
    } elseif ($Source.StartsWith('DC')) {
        $ProperSource = [ordered] @{
            Scope = 'DomainControllers'
            Name  = $Source -replace '^DC'
        }
    }
    return $ProperSource
}