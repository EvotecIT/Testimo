function Test-Me {
    [CmdletBinding()]
    param(
        [string] $OperationType,
        [string] $TestName,
        [int] $Level,
        [string] $Domain,
        [string] $DomainController,
        [string[]] $Property,
        [Object] $TestedValue,
        [Array] $Object,
        [Array] $ExpectedValue,
        [string[]] $PropertyExtendedValue,
        [string] $OperationResult,
        [int] $ExpectedCount = -1,
        [string] $ReferenceID,
        [nullable[bool]] $ExpectedOutput
    )
    Out-Begin -Text $TestName -Level $Level -Domain $Domain -DomainController $DomainController #($Level * 3)

    $TestedValue = $Object
    foreach ($V in $Property) {
        $TestedValue = $TestedValue.$V
    }

    if ($OperationType -eq '') { $OperationType = 'eq' }

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
               # $OperationType = 'eq' # Adding this for display purposes
                $TestResult = $Object.Count -eq $ExpectedCount
            }
            $TextTestedValue = $Object.Count
            $TextExpectedValue = $ExpectedCount
            #$ExpectedValue = $ExpectedCount

        } elseif ($null -ne $ExpectedValue) {
            $OutputValues = [System.Collections.Generic.List[Object]]::new()
            if ($null -eq $TestedValue -and $null -ne $ExpectedValue) {
                # if testedvalue is null and expected value is not null that means there's no sense in testing things
                # it should fail
                $TestResult = for ($i = 0; $i -lt $ExpectedValue.Count; $i++) {
                    $false # return fail

                    # We need to add this to be able to convert values as below for output purposes only.
                    if ($ExpectedValue[$i] -is [string] -and $ExpectedValue[$i] -like '*Get-Date*') {
                        [scriptblock] $DateConversion = [scriptblock]::Create($ExpectedValue[$i])
                        $CompareValue = & $DateConversion
                    } else {
                        $CompareValue = $ExpectedValue[$I]
                    }
                    # gather comparevalue for display purposes
                    $OutputValues.Add($CompareValue)

                }
                $TextExpectedValue = $OutputValues -join ', '
                $TextTestedValue = 'Null'

            } else {
                [Array] $TestResult = @(
                    if ($OperationType -eq 'notin') {
                        $ExpectedValue -notin $TestedValue
                        $TextExpectedValue = $ExpectedValue
                    } elseif ($OperationType -eq 'in') {
                        $ExpectedValue -in $TestedValue
                        $TextExpectedValue = $ExpectedValue
                    } else {
                        for ($i = 0; $i -lt $ExpectedValue.Count; $i++) {

                            # this check is introduced to convert Get-Date in ExpectedValue to proper values
                            # normally it wouldn't be nessecary but since we're exporting configuration to JSON
                            # it would export currentdatetime to JSON and we don't want that.
                            if ($ExpectedValue[$i] -is [string] -and $ExpectedValue[$i] -like '*Get-Date*') {
                                [scriptblock] $DateConversion = [scriptblock]::Create($ExpectedValue[$i])
                                $CompareValue = & $DateConversion
                            } else {
                                $CompareValue = $ExpectedValue[$I]
                            }

                            if ($OperationType -eq 'lt') {
                                $TestedValue -lt $CompareValue
                            } elseif ($OperationType -eq 'gt') {
                                $TestedValue -gt $CompareValue
                            } elseif ($OperationType -eq 'ge') {
                                $TestedValue -ge $CompareValue
                            } elseif ($OperationType -eq 'le') {
                                $TestedValue -le $CompareValue
                            } elseif ($OperationType -eq 'like') {
                                $TestedValue -like $CompareValue
                            } elseif ($OperationType -eq 'contains') {
                                $TestedValue -contains $CompareValue
                            } else {
                                #$OperationType = 'eq' # Adding this for display purposes
                                $TestedValue -eq $CompareValue
                            }
                            # gather comparevalue for display purposes
                            $OutputValues.Add($CompareValue)
                        }
                        $TextExpectedValue = $OutputValues -join ', '
                    }
                    $TextTestedValue = $TestedValue
                )
            }
        } else {
            if ($ExpectedOutput -eq $false) {
                [Array] $TestResult = @(
                    if ($null -eq $TestedValue) {
                        $true
                    } else {
                        $false
                    }
                )
                $TextExpectedValue = 'No output'
            } else {
                # Skipped tests
                $TestResult = $null
                $ExtendedTextValue = "Test provided but no tests required."
            }
        }

        if ($null -eq $TestResult) {
            $ReportResult = $null
            $ReportExtended = $ExtendedTextValue
        } else {
            if ($OperationResult -eq 'OR') {
                if ($TestResult -contains $true) {
                    $ReportResult = $true
                    $ReportExtended = "Expected value ($($Operators[$OperationType])): $($TextExpectedValue)"
                } else {
                    $ReportResult = $false
                    $ReportExtended = "Expected value ($($Operators[$OperationType])): $TextExpectedValue, Found value: $($TextTestedValue)"
                }
            } else {
                if ($TestResult -notcontains $false) {
                    $ReportResult = $true
                    $ReportExtended = "Expected value ($($Operators[$OperationType])): $($TextExpectedValue)"
                } else {
                    $ReportResult = $false
                    $ReportExtended = "Expected value ($($Operators[$OperationType])): $TextExpectedValue, Found value: $($TextTestedValue)"
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
