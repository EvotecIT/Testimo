function Test-Value {
    [CmdletBinding()]
    param(
        [Object] $Object,
        [string] $TestName,
        [string] $Property,
        [Object] $ExpectedValue,
        [string[]] $PropertyExtendedValue,
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

    if ($lt) {
        $OperationType = 'lt'
    } elseif ($gt) {
        $OperationType = 'gt'
    } elseif ($ge) {
        $OperationType = 'ge'
    } elseif ($le) {
        $OperationType = 'le'
    } else {
        $OperationType = 'eq'
    }

    if ($Object) {

        #if ($Object -is [System.Collections.IList]) {
        foreach ($_ in $Object) {
            Test-Me -OperationType $OperationType -TestName $TestName -Level $Level -Domain $Domain -DomainController $DomainController -TestedValue $_.$Property -ExpectedValue $ExpectedValue -PropertyExtendedValue $PropertyExtendedValue
        }
        #  } else {

        # }
        <#
        Out-Begin -Text $TestName -Level $Level -Domain $Domain -DomainController $DomainController #($Level * 3)
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
            if ($PropertyExtendedValue.Count -gt 0) {

                #foreach ($PropertExtended in $PropertyExtendedValue) {
                #    $Extended += $($Object.$PropertyExtendedValue)
                #}
                $Extended = $Object
                foreach ($V in $PropertyExtendedValue) {
                    $Extended = $Extended.$V
                }
            }
            Out-Status -Text $TestName -Status $TestResult -ExtendedValue $Extended -Domain $Domain -DomainController $DomainController
        } catch {
            Out-Status -Text $TestName -Status $false -ExtendedValue $_.Exception.Message -Domain $Domain -DomainController $DomainController
        }
        #>
    } else {
        Write-Warning 'Objected not passed to Test-VALUE.'
        <#
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
        #>
    }
}