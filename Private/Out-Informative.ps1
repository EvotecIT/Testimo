function Out-Informative {
    <#
    .SYNOPSIS
    Outputs informative messages with customizable colors and status indicators.

    .DESCRIPTION
    The Out-Informative function is used to output informative messages with customizable colors and status indicators. It allows for specifying the level, title, text, status, extended value, and scope of the message.

    .PARAMETER Level
    Specifies the indentation level for the message.

    .PARAMETER OverrideTitle
    Specifies an optional title to override the default title.

    .PARAMETER OverrideTextStatus
    Specifies an optional text status to override the default status.

    .PARAMETER Domain
    Specifies the domain related to the message.

    .PARAMETER DomainController
    Specifies the domain controller related to the message.

    .PARAMETER Text
    Specifies the main text content of the message.

    .PARAMETER Status
    Specifies the status of the message (true for pass, false for fail, null for informative).

    .PARAMETER ExtendedValue
    Specifies additional extended value information for the message.

    .PARAMETER Start
    Indicates whether the message is the start of a section.

    .PARAMETER End
    Indicates whether the message is the end of a section.

    .PARAMETER Scope
    Specifies the scope of the message.

    .EXAMPLE
    Out-Informative -Level 1 -OverrideTitle 'Custom Title' -Text 'This is a custom message' -Status $true -ExtendedValue 'Additional info' -Scope 'Domain'
    Outputs a custom informative message with a specified title, text, pass status, extended value, and domain scope.

    .EXAMPLE
    Out-Informative -Level 0 -Text 'Default message' -Status $false
    Outputs a default informative message with a fail status.

    #>
    [CmdletBinding()]
    param(
        [int] $Level = 0,
        [string] $OverrideTitle,
        [string] $OverrideTextStatus,
        [string] $Domain,
        [string] $DomainController,
        [string] $Text,
        [nullable[bool]] $Status,
        [string] $ExtendedValue,
        [switch] $Start,
        [switch] $End,
        [string] $Scope
    )

    if ($Start -or (-not $Start -and -not $End)) {
        $Type = 'i'
        if ($Scope -in 'Forest', 'Domain', 'DC') {
            if ($Domain -and $DomainController) {
                [ConsoleColor[]] $Color = [ConsoleColor]::Yellow, [ConsoleColor]::DarkGray, [ConsoleColor]::DarkGray, [ConsoleColor]::Yellow, [ConsoleColor]::Yellow
                $TestText = "[$Type]", "[$Domain]", "[$($DomainController)] ", $Text
            } elseif ($Domain) {
                [ConsoleColor[]] $Color = [ConsoleColor]::Yellow, [ConsoleColor]::DarkGray, [ConsoleColor]::Yellow
                $TestText = "[$Type]", "[$Domain] ", $Text
            } elseif ($DomainController) {
                # Shouldn't really happen
                Write-Warning "Out-Begin - Shouldn't happen - Fix me."
            } else {
                [ConsoleColor[]] $Color = [ConsoleColor]::Yellow, [ConsoleColor]::DarkGray, [ConsoleColor]::Yellow
                if ($OverrideTitle) {
                    $TestText = "[$Type]", "[$OverrideTitle] ", $Text
                } else {
                    $TestText = "[$Type]", "[Forest] ", $Text
                }
            }
        } else {
            [ConsoleColor[]] $Color = [ConsoleColor]::Yellow, [ConsoleColor]::DarkGray, [ConsoleColor]::Yellow
            if ($OverrideTitle) {
                $TestText = "[$Type]", "[$OverrideTitle] ", $Text
            } else {
                if ($Scope) {
                    $TestText = "[$Type]", "[$Scope] ", $Text
                } else {
                    $TestText = "[$Type]", "[Testimo] ", $Text
                }
            }
        }
        Write-Color -Text $TestText -Color $Color -StartSpaces $Level -NoNewLine
    }
    if ($End -or (-not $Start -and -not $End)) {
        if ($Status -eq $true) {
            [string] $TextStatus = 'Pass'
            [ConsoleColor[]] $Color = [ConsoleColor]::Cyan, [ConsoleColor]::Green, [ConsoleColor]::Cyan, [ConsoleColor]::Cyan, [ConsoleColor]::Green, [ConsoleColor]::Cyan
        } elseif ($Status -eq $false) {
            [string] $TextStatus = 'Fail'
            [ConsoleColor[]] $Color = [ConsoleColor]::Cyan, [ConsoleColor]::Red, [ConsoleColor]::Cyan, [ConsoleColor]::Cyan, [ConsoleColor]::Red, [ConsoleColor]::Cyan
        } else {
            [string] $TextStatus = 'Informative'
            [ConsoleColor[]] $Color = [ConsoleColor]::Cyan, [ConsoleColor]::DarkGray, [ConsoleColor]::Cyan, [ConsoleColor]::Cyan, [ConsoleColor]::Magenta, [ConsoleColor]::Cyan
        }
        if ($OverrideTextStatus) {
            $TextStatus = $OverrideTextStatus
        }
        if ($ExtendedValue) {
            Write-Color -Text ' [', $TextStatus, ']', " [", $ExtendedValue, "]" -Color $Color
        } else {
            Write-Color -Text ' [', $TextStatus, ']' -Color $Color
        }
    }
}