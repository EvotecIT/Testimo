function Test-Array {
    [CmdletBinding()]
    param(
        [string] $TestName,
        [string] $SearchObjectProperty,
        [string] $SearchObjectValue,
        [string] $Property,
        [Object] $ExpectedValue
    )
    [PSCustomObject] @{
        TestName             = $TestName
        SearchObjectProperty = $SearchObjectProperty
        SearchObjectValue    = $SearchObjectValue

        Property             = $Property
        ExpectedValue        = $ExpectedValue
        Type                 = 'Array'
    }
}