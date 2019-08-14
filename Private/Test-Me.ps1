function Test-Me {
    param(
        [string] $OperationType,
        [string] $TestName,
        [int] $Level,
        [string] $Domain,
        [string] $DomainController,
        [Object] $TestedValue,
        [Object] $Object,
        [Object] $ExpectedValue,
        [string[]] $PropertyExtendedValue
    )
    Out-Begin -Text $TestName -Level $Level -Domain $Domain -DomainController $DomainController #($Level * 3)

    $ScriptBlock = {
        $Operators = @{
            'lt' = 'LessThan'
            'gt' = 'GreaterThan'
            'le' = 'LessOrEqual'
            'ge' = 'GreaterOrEqual'
            'eq' = 'Equal'
        }
        if ($null -eq $TestedValue -and $null -ne $ExpectedValue) {
            # if testedvalue is null and expected value is not null that means there's no sense in testing things
            # it should fail
            $TestResult = $false
            $TextTestedValue = 'Null'
        } else {
            if ($OperationType -eq 'lt') {
                $TestResult = $TestedValue -lt $ExpectedValue

            } elseif ($OperationType -eq 'gt') {
                $TestResult = $TestedValue -gt $ExpectedValue

            } elseif ($OperationType -eq 'ge') {
                $TestResult = $TestedValue -ge $ExpectedValue

            } elseif ($OperationType -eq 'le') {

                $TestResult = $TestedValue -le $ExpectedValue
            } else {

                $TestResult = $TestedValue -eq $ExpectedValue
            }

        }
        if ($TestResult) {
            $Extended = "Expected value ($($Operators[$OperationType])): $($ExpectedValue)"
        } else {
            $Extended = "Expected value ($($Operators[$OperationType])): $ExpectedValue, Found value: $($TextTestedValue)"
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
    }
    if ($Script:TestimoConfiguration.Debug.DisableTryCatch) {
        & $ScriptBlock
    } else {
        try {
            & $ScriptBlock
        } catch {
            Out-Status -Text $TestName -Status $false -ExtendedValue $_.Exception.Message -Domain $Domain -DomainController $DomainController
            return $False
        }
    }
}