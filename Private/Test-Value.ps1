function Test-Value {
    [CmdletBinding()]
    param(
        [Object] $Object,
        [string] $TestName,
        [string] $Property,
        [Object] $ExpectedValue,
        [int] $Level
    )

    if ($Object) {
        Write-Color '[t] ', $TestName -Color Cyan, Yellow, Cyan -NoNewLine -StartSpaces ($Level * 3)
        if ($Object.$Property -ne $ExpectedValue) {
            Write-Color -Text ' [', 'Fail', ']' -Color Cyan, Red, Cyan #, Cyan, Green, Cyan
        } else {
            Write-Color -Text ' [', 'Pass', ']' -Color Cyan, Green, Cyan #, Cyan, Green, Cyan
        }

    } else {
        [PSCustomObject] @{
            TestName      = $TestName
            Property      = $Property
            ExpectedValue = $ExpectedValue
            Type          = 'Hash'
        }
    }
}