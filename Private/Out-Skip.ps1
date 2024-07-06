function Out-Skip {
    <#
    .SYNOPSIS
    Skips a specific test and updates the test summary.

    .DESCRIPTION
    The Out-Skip function is used to skip a specific test and update the test summary with the skipped test count. It also provides a reason for skipping the test.

    .PARAMETER Scope
    Specifies the scope of the test.

    .PARAMETER TestsSummary
    Specifies the summary of all tests.

    .PARAMETER Level
    Specifies the level of the test.

    .PARAMETER Domain
    Specifies the domain of the test.

    .PARAMETER DomainController
    Specifies the domain controller for the test.

    .PARAMETER Test
    Specifies the name of the test being skipped.

    .PARAMETER Source
    Specifies the source of the test.

    .PARAMETER Reason
    Specifies the reason for skipping the test. Default is 'Skipping - unmet dependency'.

    .EXAMPLE
    Out-Skip -Scope 'Integration' -TestsSummary $TestsSummary -Level 1 -Domain 'example.com' -DomainController 'DC1' -Test 'Test1' -Source 'ModuleA'

    Description
    -----------
    Skips the test named 'Test1' at level 1 in the 'Integration' scope for the domain 'example.com' using the domain controller 'DC1'. Updates the test summary with the skipped test count.

    #>
    [CmdletBinding()]
    param(
        [string] $Scope,
        [PSCustomobject] $TestsSummary,
        [int] $Level = 0,
        [string] $Domain,
        [string] $DomainController,
        [string] $Test,
        [string] $Source,
        [string] $Reason = 'Skipping - unmet dependency'

    )
    Out-Begin -Scope $Scope -Type 'i' -Text $Test -Level $Level -Domain $Domain -DomainController $DomainController

    Out-Status -Scope $Scope -Text $Test -Status $null -ExtendedValue $Reason -Domain $Domain -DomainController $DomainController -ReferenceID $Source

    $TestsSummary.Skipped = $TestsSummary.Skipped + 1
    $TestsSummary.Total = $TestsSummary.Failed + $TestsSummary.Passed + $TestsSummary.Skipped
    $TestsSummary
}