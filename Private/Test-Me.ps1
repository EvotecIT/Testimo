function Test-Me {
    param(
        [string] $OperationType,
        [string] $TestName,
        [int] $Level,
        [string] $Domain,
        [string] $DomainController,
        [Object] $TestedValue,
        [Object] $ExpectedValue,
        [string[]] $PropertyExtendedValue
    )
    Out-Begin -Text $TestName -Level $Level -Domain $Domain -DomainController $DomainController #($Level * 3)
    try {
        # if ($OperationType) {
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
        <#
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
        #>
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
        return $TestResult
    } catch {
        Out-Status -Text $TestName -Status $false -ExtendedValue $_.Exception.Message -Domain $Domain -DomainController $DomainController
        return $False
    }
}