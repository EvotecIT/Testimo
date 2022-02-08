function Test-StepOne {
    [CmdletBinding()]
    param(
        [string] $Scope,
        [System.Collections.IDictionary] $Test,
        [string] $Domain,
        [string] $DomainController,
        [Array] $Object,
        [string] $TestName,
        [int] $Level,
        [string] $ReferenceID,
        [System.Collections.IDictionary] $Requirements,
        [string] $QueryServer,
        [System.Collections.IDictionary] $ForestDetails,
        [object] $DomainInformation,
        [object] $ForestInformation,
        [string] $ForestName
    )

    [string] $OperationType = $Test.Parameters.OperationType
    if ($OperationType -eq '') { $OperationType = 'eq' }
    [string[]] $Property = $Test.Parameters.Property
    [string[]] $PropertyExtendedValue = $Test.Parameters.PropertyExtendedValue
    $ExpectedValue = $Test.Parameters.ExpectedValue
    [nullable[int]] $ExpectedCount = $Test.Parameters.ExpectedCount
    [scriptblock] $OverwriteName = $Test.Parameters.OverwriteName
    [scriptblock] $WhereObject = $Test.Parameters.WhereObject
    [nullable[bool]] $ExpectedResult = $Test.Parameters.ExpectedResult
    [nullable[bool]] $ExpectedOutput = $Test.Parameters.ExpectedOutput
    [string] $OperationResult = $Test.Parameters.OperationResult

    if ($Object) {
        if ($WhereObject) {
            $Object = $Object | Where-Object $WhereObject
        }
        if ($null -ne $Requirements) {
            if ($null -ne $Requirements['ExpectedOutput']) {
                #if ($Requirements['MustMatch']) {
                #    $TestsSummary.Skipped = $TestsSummary.Skipped + 1
                #    continue
                #}
            }
        }

        if ($null -eq $ExpectedCount) {
            # This checks for ExpectedResult/ExpectedOutput
            # The difference is that
            # - ExpectedResult (true/false) - when ExpectedResult is True it means we filtered our objected with Where and it still provided output
            #   This allows us to not check each element in Array one by one, but just assume this in bundle
            # - ExpectedOutput (true/false) - when we do Where-Object but it's possible that Array won't contain what we are looking for, and at the same time, it's not a problem
            if ($null -eq $Object) {
                if ($ExpectedResult -eq $false) {
                    Out-Begin -Scope $Scope -Text $TestName -Level $Level -Domain $Domain -DomainController $DomainController
                    Out-Status -Scope $Scope -Text $TestName -Status $true -ExtendedValue "Data is not available. This is expected" -Domain $Domain -DomainController $DomainController -ReferenceID $ReferenceID -Test $Test
                    return $true
                } elseif ($ExpectedResult -eq $true) {
                    Out-Begin -Scope $Scope -Text $TestName -Level $Level -Domain $Domain -DomainController $DomainController
                    Out-Status -Scope $Scope -Text $TestName -Status $false -ExtendedValue 'Data is not available. This is not expected' -Domain $Domain -DomainController $DomainController -ReferenceID $ReferenceID -Test $Test
                    return $false
                }
                # This checks for NULL after Where-Object
                # Data Source is not null, but after WHERE-Object becomes NULL - we need to fail this
                if ($null -eq $ExpectedOutput -or $ExpectedOutput -eq $true) {
                    Out-Begin -Scope $Scope -Text $TestName -Level $Level -Domain $Domain -DomainController $DomainController
                    Out-Status -Scope $Scope -Text $TestName -Status $false -ExtendedValue 'Data is not available' -Domain $Domain -DomainController $DomainController -ReferenceID $ReferenceID -Test $Test
                    return $false
                } elseif ($ExpectedOutput -eq $false) {
                    Out-Begin -Scope $Scope -Text $TestName -Level $Level -Domain $Domain -DomainController $DomainController
                    Out-Status -Scope $Scope -Text $TestName -Status $true -ExtendedValue "Data is not available, but it's not required" -Domain $Domain -DomainController $DomainController -ReferenceID $ReferenceID -Test $Test
                    return $true
                }
            } else {
                if ($ExpectedResult -eq $false) {
                    Out-Begin -Scope $Scope -Text $TestName -Level $Level -Domain $Domain -DomainController $DomainController
                    Out-Status -Scope $Scope -Text $TestName -Status $false -ExtendedValue 'Data is available. This is not expected' -Domain $Domain -DomainController $DomainController -ReferenceID $ReferenceID -Test $Test
                    return $false
                } elseif ($ExpectedResult -eq $true) {
                    Out-Begin -Scope $Scope -Text $TestName -Level $Level -Domain $Domain -DomainController $DomainController
                    Out-Status -Scope $Scope -Text $TestName -Status $true -ExtendedValue "Data is available. This is expected" -Domain $Domain -DomainController $DomainController -ReferenceID $ReferenceID -Test $Test
                    return $true
                }
            }
        }

        if ($null -ne $ExpectedCount) {
            if ($OverwriteName) {
                $TestName = & $OverwriteName
            }
            Test-StepTwo -Scope $Scope -Test $Test -Object $Object -ExpectedCount $ExpectedCount -OperationType $OperationType -TestName $TestName -Level $Level -Domain $Domain -DomainController $DomainController -Property $Property -ExpectedValue $ExpectedValue -PropertyExtendedValue $PropertyExtendedValue -OperationResult $OperationResult -ReferenceID $ReferenceID -ExpectedOutput $ExpectedOutput
        } else {
            if ($Test.Parameters.Bundle -eq $true) {
                # We treat Input as a whole rather than line one by line
                Test-StepTwo -Scope $Scope -Test $Test -Object $Object -OperationType $OperationType -TestName $TestName -Level $Level -Domain $Domain -DomainController $DomainController -Property $Property -ExpectedValue $ExpectedValue -PropertyExtendedValue $PropertyExtendedValue -OperationResult $OperationResult -ReferenceID $ReferenceID -ExpectedOutput $ExpectedOutput
            } else {
                foreach ($_ in $Object) {
                    if ($OverwriteName) {
                        $TestName = & $OverwriteName
                    }
                    Test-StepTwo -Scope $Scope -Test $Test -Object $_ -OperationType $OperationType -TestName $TestName -Level $Level -Domain $Domain -DomainController $DomainController -Property $Property -ExpectedValue $ExpectedValue -PropertyExtendedValue $PropertyExtendedValue -OperationResult $OperationResult -ReferenceID $ReferenceID -ExpectedOutput $ExpectedOutput
                }
            }
        }
    }
}