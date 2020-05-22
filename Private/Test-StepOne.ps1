function Test-StepOne {
    [CmdletBinding()]
    param(
        [string] $Domain,
        [string] $DomainController,
        [Array] $Object,
        [string] $TestName,
        [string] $OperationType,
        [int] $Level,
        [string[]] $Property,
        [string[]] $PropertyExtendedValue,
        [Object] $ExpectedValue,
        [nullable[int]] $ExpectedCount,
        [string] $OperationResult,
        [string] $ReferenceID,
        [nullable[bool]] $ExpectedResult,
        [nullable[bool]] $ExpectedOutput,
        [scriptblock] $WhereObject,
        [scriptblock] $OverwriteName,
        [System.Collections.IDictionary] $Requirements
    )


    if ($OperationType -eq '') { $OperationType = 'eq' }

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

        # This checks for ExpectedResult/ExpectedOutput
        # The difference is that
        # - ExpectedResult (true/false) - when ExpectedResult is True it means we filtered our objected with Where and it still provided output
        #   This allows us to not check each element in Array one by one, but just assume this in bundle
        # - ExpectedOutput (true/false) - when we do Where-Object but it's possible that Array won't contain what we are looking for, and at the same time, it's not a problem
        if ($null -eq $Object) {
            if ($ExpectedResult -eq $false) {
                Out-Begin -Text $TestName -Level $Level -Domain $Domain -DomainController $DomainController
                Out-Status -Text $TestName -Status $true -ExtendedValue "Data is not available. This is expected." -Domain $Domain -DomainController $DomainController -ReferenceID $ReferenceID
                return $true
            } elseif ($ExpectedResult -eq $true) {
                Out-Begin -Text $TestName -Level $Level -Domain $Domain -DomainController $DomainController
                Out-Status -Text $TestName -Status $false -ExtendedValue 'Data is not available. This is not expected.' -Domain $Domain -DomainController $DomainController -ReferenceID $ReferenceID
                return $false
            }
            # This checks for NULL after Where-Object
            # Data Source is not null, but after WHERE-Object becomes NULL - we need to fail this
            if ($null -eq $ExpectedOutput -or $ExpectedOutput -eq $true) {
                Out-Begin -Text $TestName -Level $Level -Domain $Domain -DomainController $DomainController
                Out-Status -Text $TestName -Status $false -ExtendedValue 'Data is not available.' -Domain $Domain -DomainController $DomainController -ReferenceID $ReferenceID
                return $false
            } else {
                Out-Begin -Text $TestName -Level $Level -Domain $Domain -DomainController $DomainController
                Out-Status -Text $TestName -Status $true -ExtendedValue "Data is not available, but it's not required." -Domain $Domain -DomainController $DomainController -ReferenceID $ReferenceID
                return $true
            }
        } else {
            if ($ExpectedResult -eq $false) {
                Out-Begin -Text $TestName -Level $Level -Domain $Domain -DomainController $DomainController
                Out-Status -Text $TestName -Status $false -ExtendedValue 'Data is available. This is not expected.' -Domain $Domain -DomainController $DomainController -ReferenceID $ReferenceID
                return $false
            } elseif ($ExpectedResult -eq $true) {
                Out-Begin -Text $TestName -Level $Level -Domain $Domain -DomainController $DomainController
                Out-Status -Text $TestName -Status $true -ExtendedValue "Data is available. This is expected." -Domain $Domain -DomainController $DomainController -ReferenceID $ReferenceID
                return $true
            }
        }

        if ($null -ne $ExpectedCount) {
            if ($OverwriteName) {
                $TestName = & $OverwriteName
            }
            Test-StepTwo -Object $Object -ExpectedCount $ExpectedCount -OperationType $OperationType -TestName $TestName -Level $Level -Domain $Domain -DomainController $DomainController -Property $Property -ExpectedValue $ExpectedValue -PropertyExtendedValue $PropertyExtendedValue -OperationResult $OperationResult -ReferenceID $ReferenceID -ExpectedOutput $ExpectedOutput
        } else {
            foreach ($_ in $Object) {
                if ($OverwriteName) {
                    $TestName = & $OverwriteName
                }
                Test-StepTwo -Object $_ -OperationType $OperationType -TestName $TestName -Level $Level -Domain $Domain -DomainController $DomainController -Property $Property -ExpectedValue $ExpectedValue -PropertyExtendedValue $PropertyExtendedValue -OperationResult $OperationResult -ReferenceID $ReferenceID -ExpectedOutput $ExpectedOutput
            }
        }
    }
    #else {
    #Write-Warning 'Object not passed to Test-StepTwo.'
    #}
}