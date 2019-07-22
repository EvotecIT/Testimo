function Test-Value {
    [CmdletBinding()]
    param(
        [string] $TestName,
        [string] $Property,
        [Object] $ExpectedValue

    )

    [PSCustomObject] @{
        TestName      = $TestName
        Property      = $Property
        ExpectedValue = $ExpectedValue
        Type          = 'Hash'
    }
}