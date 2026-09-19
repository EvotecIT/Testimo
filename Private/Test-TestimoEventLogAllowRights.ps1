function Test-TestimoEventLogAllowRights {
    <#
    .SYNOPSIS
    Checks whether channel DACL allow entries contain event-log rights for a trustee.

    .DESCRIPTION
    Combines the rights from allow entries for the same SID returned by Get-EVXLog, including
    inherited entries. This does not calculate effective access, which can also depend on
    deny entries, ACE ordering, and group membership.

    .PARAMETER AccessRules
    Parsed channel DACL entries from Get-EVXLog.

    .PARAMETER TrusteeSid
    SID of the trustee, independent of localized account names.

    .PARAMETER RequiredRights
    Event-log rights mask: 1 for Read, 2 for Write, and 4 for Clear.
    #>
    [CmdletBinding()]
    param(
        [AllowNull()]
        [object[]] $AccessRules,
        [Parameter(Mandatory)]
        [string] $TrusteeSid,
        [Parameter(Mandatory)]
        [ValidateRange(1, 7)]
        [int] $RequiredRights
    )

    $AllowedRights = 0
    foreach ($Rule in $AccessRules) {
        if ($null -ne $Rule -and
            $Rule.TrusteeSid -eq $TrusteeSid -and
            $Rule.IsAllow) {
            $AllowedRights = $AllowedRights -bor $Rule.AccessMask
        }
    }

    ($AllowedRights -band $RequiredRights) -eq $RequiredRights
}
