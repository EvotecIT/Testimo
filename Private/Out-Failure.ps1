function Out-Failure {
    <#
    .SYNOPSIS
    Sends a failure status message with detailed information.

    .DESCRIPTION
    The Out-Failure function sends a failure status message with detailed information including the scope, text, level, extended value, domain, domain controller, reference ID, type, source, and test.

    .PARAMETER Scope
    Specifies the scope of the failure.

    .PARAMETER Text
    Specifies the text message associated with the failure.

    .PARAMETER Level
    Specifies the level of the failure.

    .PARAMETER ExtendedValue
    Specifies additional extended value information for the failure. Default is 'Input data not provided. Failing test.'.

    .PARAMETER Domain
    Specifies the domain associated with the failure.

    .PARAMETER DomainController
    Specifies the domain controller related to the failure.

    .PARAMETER ReferenceID
    Specifies a reference ID for the failure.

    .PARAMETER Type
    Specifies the type of failure. Valid values are 'e' (error), 'i' (information), or 't' (test). Default is 't'.

    .PARAMETER Source
    Specifies the source of the failure as a dictionary.

    .PARAMETER Test
    Specifies the test information related to the failure as a dictionary.

    .EXAMPLE
    Out-Failure -Scope "Global" -Text "Connection failed" -Level 3 -Domain "example.com" -DomainController "DC1" -ReferenceID "12345" -Type "e" -Source @{"SourceKey"="SourceValue"} -Test @{"TestKey"="TestValue"}

    Sends a failure status message with the specified parameters.

    #>
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