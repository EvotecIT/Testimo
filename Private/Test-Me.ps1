function Test-Me {
    param(
        [string] $OperationType,
        [string] $TestName,
        [int] $Level,
        [string] $Domain,
        [string] $DomainController,
        [string[]] $Property,
        [Object] $TestedValue,
        [Object] $Object,
        [Object] $ExpectedValue,
        [string[]] $PropertyExtendedValue,
        [int] $ExpectedCount = -1
    )
    Out-Begin -Text $TestName -Level $Level -Domain $Domain -DomainController $DomainController #($Level * 3)


    $TestedValue = $Object
    foreach ($V in $Property) {
        $TestedValue = $TestedValue.$V
    }


    $ScriptBlock = {
        $Operators = @{
            'lt'       = 'LessThan'
            'gt'       = 'GreaterThan'
            'le'       = 'LessOrEqual'
            'ge'       = 'GreaterOrEqual'
            'eq'       = 'Equal'
            'contains' = 'Contains'
            'like'     = 'Like'
        }

        if ($ExpectedCount -ne -1) {
            if ($OperationType -eq 'lt') {
                $TestResult = $Object.Count -lt $ExpectedCount
            } elseif ($OperationType -eq 'gt') {
                $TestResult = $Object.Count -lt $ExpectedCount
            } elseif ($OperationType -eq 'ge') {
                $TestResult = $Object.Count -lt $ExpectedCount
            } elseif ($OperationType -eq 'le') {
                $TestResult = $Object.Count -lt $ExpectedCount
            } elseif ($OperationType -eq 'like') {
                $TestResult = $Object.Count -like $ExpectedCount
            } elseif ($OperationType -eq 'contains') {
                $TestResult = $Object.Count -like $ExpectedCount
            } else {
                $TestResult = $Object.Count -lt $ExpectedCount
            }
            $TextTestedValue = $Object.Count
            $ExpectedValue = $ExpectedCount

        } elseif ($null -ne $ExpectedValue) {
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
                } elseif ($OperationType -eq 'like') {
                    $TestResult = $TestedValue -like $ExpectedValue
                } elseif ($OperationType -eq 'contains') {
                    $TestResult = $TestedValue -contains $ExpectedValue
                } else {
                    $TestResult = $TestedValue -eq $ExpectedValue
                }
                $TextTestedValue = $TestedValue

            }
        } else {
            # Skipped tests
            $TestResult = $null
            $ExtendedTextValue = "Test provided but no tests required."
        }
        if ($TestResult -eq $true) {
            $Extended = "Expected value ($($Operators[$OperationType])): $($ExpectedValue)"
        } elseif ($TestResult -eq $false) {
            $Extended = "Expected value ($($Operators[$OperationType])): $ExpectedValue, Found value: $($TextTestedValue)"
        } else {
            $Extended = $ExtendedTextValue
        }

        if ($PropertyExtendedValue.Count -gt 0) {
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