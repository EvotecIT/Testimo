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
        [int] $ExpectedCount = -1,
        [string] $OperationResult,
        [string] $ReferenceID,
        [nullable[bool]] $ExpectedOutput,
        [nullable[bool]] $MustExists,
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
            if ($null -ne $Requirements['MustExists']) {
                #if ($Requirements['MustMatch']) {
                #    $TestsSummary.Skipped = $TestsSummary.Skipped + 1
                #    continue
                #}
            }
        }

        if ($null -eq $Object) {
            # This checks for NULL after Where-Object
            # Data Source is not null, but after WHERE-Object becomes NULL - we need to fail this
            if ($null -eq $MustExists -or $MustExists -eq $true) {
                Out-Begin -Text $TestName -Level $Level -Domain $Domain -DomainController $DomainController
                Out-Status -Text $TestName -Status $false -ExtendedValue 'Data is not available.' -Domain $Domain -DomainController $DomainController -ReferenceID $ReferenceID
                return $false
            } else {
                Out-Begin -Text $TestName -Level $Level -Domain $Domain -DomainController $DomainController
                Out-Status -Text $TestName -Status $true -ExtendedValue "Data is not available, but it's not required." -Domain $Domain -DomainController $DomainController -ReferenceID $ReferenceID
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