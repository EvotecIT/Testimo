function Out-Failure {
    [CmdletBinding()]
    param(
        [string] $Text,
        [int] $Level,
        [string] $ExtendedValue = 'Input data not provided. Failing test.',
        [string] $Domain,
        [string] $DomainController,
        [string] $ReferenceID,
        [validateSet('e', 'i', 't')][string] $Type = 't'
    )
    Out-Begin -Text $Text -Level $Level -Domain $Domain -DomainController $DomainController -Type $Type
    Out-Status -Text $Text -Status $false -ExtendedValue $ExtendedValue -Domain $Domain -DomainController $DomainController -ReferenceID $ReferenceID
}