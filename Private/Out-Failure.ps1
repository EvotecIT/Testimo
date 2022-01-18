function Out-Failure {
    [CmdletBinding()]
    param(
        [string] $Scope,
        [string] $Text,
        [int] $Level,
        [string] $ExtendedValue = 'Input data not provided. Failing test.',
        [string] $Domain,
        [string] $DomainController,
        [string] $ReferenceID,
        [validateSet('e', 'i', 't')][string] $Type = 't',
        [System.Collections.IDictionary] $Source,
        [System.Collections.IDictionary] $Test
    )
    Out-Begin -Scope $Scope -Text $Text -Level $Level -Domain $Domain -DomainController $DomainController -Type $Type
    Out-Status -Scope $Scope -Text $Text -Status $false -ExtendedValue $ExtendedValue -Domain $Domain -DomainController $DomainController -ReferenceID $ReferenceID -Source $Source -Test $Test
}