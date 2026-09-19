function Get-TestimoEventLogDetails {
    <#
    .SYNOPSIS
    Returns event-log details only when EventViewerX collected a complete snapshot.

    .DESCRIPTION
    Testimo's health comparisons must not treat a partially read field's default value as
    evidence that a channel is healthy. Diagnostics remain visible in the report warning stream.
    #>
    [CmdletBinding()]
    param(
        [Parameter(Mandatory)]
        [string] $MachineName
    )

    $results = Get-EVXLog -LogName 'Application', 'System', 'Security', 'Microsoft-Windows-PowerShell/Operational' -MachineName $MachineName -AsResult
    foreach ($result in $results) {
        if ($result.Status -ne 'Success' -or $null -eq $result.Details) {
            Write-Warning $result.DiagnosticMessage
            continue
        }

        $result.Details
    }
}
