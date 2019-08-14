function Test-Value {
    [CmdletBinding()]
    param(
        [Object] $Object,
        [string] $TestName,
        [string] $Property,
        [Object] $ExpectedValue,
        [string[]] $PropertyExtendedValue,
        [switch] $lt,
        [switch] $gt,
        [switch] $le,
        [switch] $eq,
        [switch] $ge,
        [string] $OperationType,
        [int] $Level,
        [string] $Domain,
        [Object] $DomainController
    )

    if (-not $OperationType) {
        if ($lt) {
            $OperationType = 'lt'
        } elseif ($gt) {
            $OperationType = 'gt'
        } elseif ($ge) {
            $OperationType = 'ge'
        } elseif ($le) {
            $OperationType = 'le'
        } else {
            $OperationType = 'eq'
        }
    }
    if ($Object) {
        foreach ($_ in $Object) {
            Test-Me -Object $_ -OperationType $OperationType -TestName $TestName -Level $Level -Domain $Domain -DomainController $DomainController -TestedValue $_.$Property -ExpectedValue $ExpectedValue -PropertyExtendedValue $PropertyExtendedValue
        }
    } else {
        Write-Warning 'Objected not passed to Test-VALUE.'
    }
}