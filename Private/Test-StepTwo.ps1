function Test-StepTwo {
    [CmdletBinding()]
    param(
        [string] $Scope,
        [System.Collections.IDictionary] $Test,
        [string] $Domain,
        [string] $DomainController,
        [Array] $Object,
        [string] $TestName,
        [string] $OperationType,
        [int] $Level,
        [string[]] $Property,
        [string[]] $PropertyExtendedValue,
        [Array] $ExpectedValue,
        [nullable[int]] $ExpectedCount,
        [string] $OperationResult,
        [string] $ReferenceID,
        [nullable[bool]] $ExpectedOutput
    )
    Out-Begin -Scope $Scope -Text $TestName -Level $Level -Domain $Domain -DomainController $DomainController

    $TemporaryBoundParameters = $PSBoundParameters

    $ScriptBlock = {
        $Operators = @{
            'lt'          = 'Less Than'
            'gt'          = 'Greater Than'
            'le'          = 'Less Or Equal'
            'ge'          = 'Greater Or Equal'
            'eq'          = 'Equal'
            'contains'    = 'Contains'
            'notcontains' = 'Not contains'
            'like'        = 'Like'
            'match'       = 'Match'
            'notmatch'    = 'Not match'
            'notin'       = 'Not in'
            'in'          = 'Either Value'
        }
        [Object] $TestedValue = $Object
        foreach ($V in $Property) {
            $TestedValue = $TestedValue.$V
        }

        if ($TemporaryBoundParameters.ContainsKey('ExpectedCount')) {
            if ($null -eq $Object) {
                $TestedValueCount = 0
            } else {
                $TestedValueCount = $TestedValue.Count
            }
            if ($OperationType -eq 'lt') {
                $TestResult = $TestedValueCount -lt $ExpectedCount
            } elseif ($OperationType -eq 'gt') {
                $TestResult = $TestedValueCount -gt $ExpectedCount
            } elseif ($OperationType -eq 'ge') {
                $TestResult = $TestedValueCount -ge $ExpectedCount
            } elseif ($OperationType -eq 'le') {
                $TestResult = $TestedValueCount -le $ExpectedCount
            } elseif ($OperationType -eq 'like') {
                # Useless - doesn't make any sense
                $TestResult = $TestedValueCount -like $ExpectedCount
            } elseif ($OperationType -eq 'contains') {
                # Useless - doesn't make any sense
                $TestResult = $TestedValueCount -contains $ExpectedCount
            } elseif ($OperationType -eq 'in') {
                # Useless - doesn't make any sense
                $TestResult = $ExpectedCount -in $TestedValueCount
            } elseif ($OperationType -eq 'notin') {
                # Useless - doesn't make any sense
                $TestResult = $ExpectedCount -notin $TestedValueCount
            } else {
                $TestResult = $TestedValueCount -eq $ExpectedCount
            }
            $TextTestedValue = $TestedValueCount
            $TextExpectedValue = $ExpectedCount

        } elseif ($TemporaryBoundParameters.ContainsKey('ExpectedValue')) {
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
                        $TestedValue -in $ExpectedValue
                        $TextExpectedValue = $ExpectedValue -join ' or '
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
                            if ($TestedValue -is [System.Collections.ICollection] -or $TestedValue -is [Array]) {
                                $CompareObjects = Compare-Object -ReferenceObject $TestedValue -DifferenceObject $CompareValue -IncludeEqual
                                #$CompareObjects

                                if ($OperationType -eq 'eq') {
                                    if ($CompareObjects.SideIndicator -notcontains "=>" -and $CompareObjects.SideIndicator -notcontains "<=" -and $CompareObjects.SideIndicator -contains "==") {
                                        $true
                                    } else {
                                        $false
                                    }
                                } elseif ($OperationType -eq 'ne') {
                                   if ($CompareObjects.SideIndicator -contains "=>" -or $CompareObjects.SideIndicator -contains "<=") {
                                       $true
                                   } else {
                                       $false
                                   }
                                } else {
                                    # Not supported for arrays
                                    $null
                                }
                            } else {
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
                                } elseif ($OperationType -eq 'notcontains') {
                                    $TestedValue -notcontains $CompareValue
                                } elseif ($OperationType -eq 'match') {
                                    $TestedValue -match $CompareValue
                                } elseif ($OperationType -eq 'notmatch') {
                                    $TestedValue -notmatch $CompareValue
                                } else {
                                    $TestedValue -eq $CompareValue
                                }
                            }
                            # gather comparevalue for display purposes
                            $OutputValues.Add($CompareValue)
                        }
                        if ($ExpectedValue.Count -eq 0) {
                            $TextExpectedValue = 'Null'
                        } else {
                            $TextExpectedValue = $OutputValues -join ', '
                        }
                    }
                    if ($null -eq $TestedValue) {
                        $TextTestedValue = 'Null'
                    } else {
                        $TextTestedValue = $TestedValue
                    }
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
                    if ($Test.Parameters.DisplayResult -ne $false) {
                        $ReportExtended = "Expected value ($($Operators[$OperationType])): $TextExpectedValue, Found value: $($TextTestedValue)"
                    } else {
                        $ReportExtended = "Expected value ($($Operators[$OperationType])): $TextExpectedValue"
                    }
                }
            } else {
                if ($TestResult -notcontains $false) {
                    $ReportResult = $true
                    $ReportExtended = "Expected value ($($Operators[$OperationType])): $($TextExpectedValue)"
                } else {
                    $ReportResult = $false
                    if ($Test.Parameters.DisplayResult -ne $false) {
                        $ReportExtended = "Expected value ($($Operators[$OperationType])): $TextExpectedValue, Found value: $($TextTestedValue)"
                    } else {
                        $ReportExtended = "Expected value ($($Operators[$OperationType])): $TextExpectedValue"
                    }
                }

            }
        }
        if ($PropertyExtendedValue.Count -gt 0) {
            $ReportExtended = $Object
            foreach ($V in $PropertyExtendedValue) {
                $ReportExtended = $ReportExtended.$V
            }
            $ReportExtended = $ReportExtended -join ', '
        }
        Out-Status -Scope $Scope -Text $TestName -Status $ReportResult -ExtendedValue $ReportExtended -Domain $Domain -DomainController $DomainController -ReferenceID $ReferenceID -Test $Test
        return $ReportResult
    }

    if ($Script:TestimoConfiguration.Debug.ShowErrors) {
        & $ScriptBlock
    } else {
        try {
            & $ScriptBlock
        } catch {
            Out-Status -Scope $Scope -Text $TestName -Status $false -ExtendedValue $_.Exception.Message -Domain $Domain -DomainController $DomainController -ReferenceID $ReferenceID -Test $Test
            return $False
        }
    }
}
