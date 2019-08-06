function Out-Failure {
    param(
        [string] $Text,
        [int] $Level,
        [string] $ExtendedValue = 'Input data not provided. Failing test.'
    )
    Out-Begin -Text $Text -Level $Level
    Out-Status -Text $Text -Status $false -ExtendedValue $ExtendedValue
}