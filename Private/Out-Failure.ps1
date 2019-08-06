function Out-Failure {
    param(
        [string] $Text,
        [int] $Level
    )
    Out-Begin -Text $Text -Level $Level
    Out-Status -Text $Text -Status $false -ExtendedValue 'Input data not provided. Failing test.'
}