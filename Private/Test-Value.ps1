function Test-Value {
    [CmdletBinding()]
    param(
        [Object] $Object,
        [string] $TestName,
        [string[]] $Property,
        [Object] $ExpectedValue,
        [string[]] $PropertyExtendedValue,
        [string] $OperationType,
        [int] $Level,
        [string] $Domain,
        [Object] $DomainController,
        [int] $ExpectedCount,
        [string] $OperationResult,
        [scriptblock] $WhereObject,
        [string] $ReferenceID,
        [scriptblock] $OverwriteName
    )
    if ($Object) {


        if ($ExpectedCount) {
            if ($OverwriteName) {
                $TestName = & $OverwriteName
            }
            Test-Me -Object $Object -ExpectedCount $ExpectedCount -OperationType $OperationType -TestName $TestName -Level $Level -Domain $Domain -DomainController $DomainController -Property $Property -ExpectedValue $ExpectedValue -PropertyExtendedValue $PropertyExtendedValue -OperationResult $OperationResult -ReferenceID $ReferenceID
        } else {
            if ($WhereObject) {
                if ($OverwriteName) {
                    $TestName = & $OverwriteName
                }
                $Object = $Object | Where-Object $WhereObject
                Test-Me -Object $Object -OperationType $OperationType -TestName $TestName -Level $Level -Domain $Domain -DomainController $DomainController -Property $Property -ExpectedValue $ExpectedValue -PropertyExtendedValue $PropertyExtendedValue -OperationResult $OperationResult -ReferenceID $ReferenceID
            } else {
                foreach ($_ in $Object) {
                    if ($OverwriteName) {
                        $TestName = & $OverwriteName
                    }
                    Test-Me -Object $_ -OperationType $OperationType -TestName $TestName -Level $Level -Domain $Domain -DomainController $DomainController -Property $Property -ExpectedValue $ExpectedValue -PropertyExtendedValue $PropertyExtendedValue -OperationResult $OperationResult -ReferenceID $ReferenceID
                }
            }
        }
    } else {
        Write-Warning 'Objected not passed to Test-VALUE.'
    }
}