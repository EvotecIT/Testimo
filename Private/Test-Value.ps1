function Test-Value {
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

        [scriptblock] $WhereObject,
        [scriptblock] $OverwriteName
    )
    if ($Object) {
        if ($WhereObject) {
            $Object = $Object | Where-Object $WhereObject
        }
        if ($ExpectedCount) {
            if ($OverwriteName) {
                $TestName = & $OverwriteName
            }
            Test-Me -Object $Object -ExpectedCount $ExpectedCount -OperationType $OperationType -TestName $TestName -Level $Level -Domain $Domain -DomainController $DomainController -Property $Property -ExpectedValue $ExpectedValue -PropertyExtendedValue $PropertyExtendedValue -OperationResult $OperationResult -ReferenceID $ReferenceID -ExpectedOutput $ExpectedOutput
        } else {
            foreach ($_ in $Object) {
                if ($OverwriteName) {
                    $TestName = & $OverwriteName
                }
                Test-Me -Object $_ -OperationType $OperationType -TestName $TestName -Level $Level -Domain $Domain -DomainController $DomainController -Property $Property -ExpectedValue $ExpectedValue -PropertyExtendedValue $PropertyExtendedValue -OperationResult $OperationResult -ReferenceID $ReferenceID -ExpectedOutput $ExpectedOutput
            }
        }
    } else {
        Write-Warning 'Objected not passed to Test-VALUE.'
    }
}