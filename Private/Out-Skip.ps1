function Out-Skip {
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