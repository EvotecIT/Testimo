function Test-Value {
    [CmdletBinding()]
    param(
        [Object] $Object,
        [string] $TestName,
        [string] $Property,
        [Object] $ExpectedValue,
        [string] $PropertExtendedValue,
        [switch] $lt,
        [switch] $gt,
        [switch] $le,
        [switch] $eq,
        [switch] $ge,
        [string] $OperationType,
        [int] $Level,
        [string] $Domain,
        [Object] $DomainController
    )

    if ($Object) {
        Out-Begin -Text $TestName -Level $Level #($Level * 3)
        try {
            if ($OperationType) {
                if ($OperationType -eq 'lt') {
                    $TestResult = $Object.$Property -lt $ExpectedValue
                } elseif ($OperationType -eq 'gt') {
                    $TestResult = $Object.$Property -gt $ExpectedValue
                } elseif ($OperationType -eq 'ge') {
                    $TestResult = $Object.$Property -ge $ExpectedValue
                } elseif ($OperationType -eq 'le') {
                    $TestResult = $Object.$Property -le $ExpectedValue
                } else {
                    $TestResult = $Object.$Property -eq $ExpectedValue
                }
            } else {
                if ($lt) {
                    $TestResult = $Object.$Property -lt $ExpectedValue
                } elseif ($gt) {
                    $TestResult = $Object.$Property -gt $ExpectedValue
                } elseif ($ge) {
                    $TestResult = $Object.$Property -ge $ExpectedValue
                } elseif ($le) {
                    $TestResult = $Object.$Property -le $ExpectedValue
                } else {
                    $TestResult = $Object.$Property -eq $ExpectedValue
                }
            }
            if ($TestResult) {
                $Extended = "Expected value: $($Object.$Property)"
            } else {
                $Extended = "Expected value: $ExpectedValue, Found value: $($Object.$Property)"
            }
            if ($PropertExtendedValue) {
                $Extended = $($Object.$PropertExtendedValue)
            }
            Out-Status -Text $TestName -Status $TestResult -ExtendedValue $Extended
        } catch {
            Out-Status -Text $TestName -Status $false -ExtendedValue $_.Exception.Message
        }
    } else {
        if ($lt) {
            $Comparison = 'lt'
        } elseif ($gt) {
            $Comparison = 'gt'
        } elseif ($ge) {
            $Comparison = 'ge'
        } elseif ($le) {
            $Comparison = 'le'
        } else {
            $Comparison = 'eq'
        }
        [PSCustomObject] @{
            TestName      = $TestName
            Property      = $Property
            ExpectedValue = $ExpectedValue
            Comparison    = $Comparison
            Type          = 'Hash'
        }
    }
}