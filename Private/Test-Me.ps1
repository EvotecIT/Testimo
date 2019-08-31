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
        [Array] $ExpectedValue,
        [string[]] $PropertyExtendedValue,
        [string] $OperationResult,
        [int] $ExpectedCount = -1,
        [string] $ReferenceID
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
                # Useless - doesn't make any sense
                $TestResult = $Object.Count -like $ExpectedCount
            } elseif ($OperationType -eq 'contains') {
                # Useless - doesn't make any sense
                $TestResult = $Object.Count -like $ExpectedCount
            } elseif ($OperationType -eq 'in') {
                # Useless - doesn't make any sense
                $TestResult = $ExpectedCount -in $Object.Count
            } elseif ($OperationType -eq 'notin') {
                # Useless - doesn't make any sense
                $TestResult = $ExpectedCount -notin $Object.Count
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
                [Array] $TestResult = for ($i = 0; $i -lt $ExpectedValue.Count; $i++) {
                    if ($OperationType -eq 'lt') {
                        $TestedValue -lt $ExpectedValue[$i]
                    } elseif ($OperationType -eq 'gt') {
                        $TestedValue -gt $ExpectedValue[$i]
                    } elseif ($OperationType -eq 'ge') {
                        $TestedValue -ge $ExpectedValue[$i]
                    } elseif ($OperationType -eq 'le') {
                        $TestedValue -le $ExpectedValue[$i]
                    } elseif ($OperationType -eq 'like') {
                        $TestedValue -like $ExpectedValue[$i]
                    } elseif ($OperationType -eq 'contains') {
                        $TestedValue -contains $ExpectedValue[$i]
                    } elseif ($OperationType -eq 'in') {
                        $ExpectedValue -in $ExpectedValue[$i]
                    } elseif ($OperationType -eq 'notin') {
                        $ExpectedValue -notin $ExpectedValue[$i]
                    } else {
                        $TestedValue -eq $ExpectedValue[$i]
                    }
                }
                $TextTestedValue = $TestedValue
            }
        } else {
            # Skipped tests
            $TestResult = $null
            $ExtendedTextValue = "Test provided but no tests required."
        }


        if ($null -eq $TestResult) {
            $ReportResult = $null
            $ReportExtended = $ExtendedTextValue
        } else {
            if ($OperationResult -eq 'OR') {
                if ($TestResult -contains $true) {
                    $ReportResult = $true
                    $ReportExtended = "Expected value ($($Operators[$OperationType])): $($ExpectedValue)"
                } else {
                    $ReportResult = $false
                    $ReportExtended = "Expected value ($($Operators[$OperationType])): $ExpectedValue, Found value: $($TextTestedValue)"
                }
            } else {
                if ($TestResult -notcontains $false) {
                    $ReportResult = $true
                    $ReportExtended = "Expected value ($($Operators[$OperationType])): $($ExpectedValue)"
                } else {
                    $ReportResult = $false
                    $ReportExtended = "Expected value ($($Operators[$OperationType])): $ExpectedValue, Found value: $($TextTestedValue)"
                }

            }
        }
        if ($PropertyExtendedValue.Count -gt 0) {
            $ReportExtended = $Object
            foreach ($V in $PropertyExtendedValue) {
                $ReportExtended = $ReportExtended.$V
            }
        }
        Out-Status -Text $TestName -Status $ReportResult -ExtendedValue $ReportExtended -Domain $Domain -DomainController $DomainController -ReferenceID $ReferenceID
        return $ReportResult
    }
    if ($Script:TestimoConfiguration.Debug.ShowErrors) {
        & $ScriptBlock
    } else {
        try {
            & $ScriptBlock
        } catch {
            Out-Status -Text $TestName -Status $false -ExtendedValue $_.Exception.Message -Domain $Domain -DomainController $DomainController -ReferenceID $ReferenceID
            return $False
        }
    }
}