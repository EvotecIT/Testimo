function Out-Begin {
    <#
    .SYNOPSIS
    Outputs formatted text based on specified parameters.

    .DESCRIPTION
    The Out-Begin function outputs formatted text to the console based on the provided Scope, Text, Level, Type, Domain, and DomainController parameters.

    .PARAMETER Scope
    Specifies the scope of the output. Valid values are 'Forest', 'Domain', or 'DC'.

    .PARAMETER Text
    Specifies the text to be displayed.

    .PARAMETER Level
    Specifies the level of the output.

    .PARAMETER Type
    Specifies the type of output. Default value is 't'.

    .PARAMETER Domain
    Specifies the domain for the output.

    .PARAMETER DomainController
    Specifies the domain controller for the output.

    .EXAMPLE
    Out-Begin -Scope 'Forest' -Text 'Sample text' -Level 1 -Type 't' -Domain 'ExampleDomain' -DomainController 'DC1'
    Outputs formatted text for the Forest scope with the specified parameters.

    .EXAMPLE
    Out-Begin -Scope 'Domain' -Text 'Error message' -Level 2 -Type 'e' -Domain 'AnotherDomain'
    Outputs an error message for the Domain scope with the specified parameters.
    #>
    [CmdletBinding()]
    param(
        [string] $Scope,
        [string] $Text,
        [int] $Level,
        [string] $Type = 't',
        [string] $Domain,
        [string] $DomainController
    )
    if ($Scope -in 'Forest', 'Domain', 'DC') {
        if ($Domain -and $DomainController) {
            if ($Type -eq 't') {
                [ConsoleColor[]] $Color = [ConsoleColor]::Cyan, [ConsoleColor]::DarkGray, [ConsoleColor]::DarkGray, [ConsoleColor]::Yellow, [ConsoleColor]::Yellow
            } elseif ($Type -eq 'e') {
                [ConsoleColor[]] $Color = [ConsoleColor]::Red, [ConsoleColor]::DarkGray, [ConsoleColor]::DarkGray, [ConsoleColor]::Yellow, [ConsoleColor]::Yellow
            } else {
                [ConsoleColor[]] $Color = [ConsoleColor]::Yellow, [ConsoleColor]::DarkGray, [ConsoleColor]::DarkGray, [ConsoleColor]::Yellow, [ConsoleColor]::Yellow
            }
            $TestText = "[$Type]", "[$Domain]", "[$($DomainController)] ", $Text
        } elseif ($Domain) {
            if ($Type -eq 't') {
                [ConsoleColor[]] $Color = [ConsoleColor]::Cyan, [ConsoleColor]::DarkGray, [ConsoleColor]::Yellow
            } elseif ($Type -eq 'e') {
                [ConsoleColor[]] $Color = [ConsoleColor]::Red, [ConsoleColor]::DarkGray, [ConsoleColor]::Yellow
            } else {
                [ConsoleColor[]] $Color = [ConsoleColor]::Yellow, [ConsoleColor]::DarkGray, [ConsoleColor]::Yellow
            }
            $TestText = "[$Type]", "[$Domain] ", $Text
        } elseif ($DomainController) {
            # Shouldn't really happen
            Write-Warning "Out-Begin - Shouldn't happen - Fix me."
        } else {
            if ($Type -eq 't') {
                [ConsoleColor[]] $Color = [ConsoleColor]::Cyan, [ConsoleColor]::DarkGray, [ConsoleColor]::Yellow
            } elseif ($Type -eq 'e') {
                [ConsoleColor[]] $Color = [ConsoleColor]::Red, [ConsoleColor]::DarkGray, [ConsoleColor]::Yellow
            } else {
                [ConsoleColor[]] $Color = [ConsoleColor]::Yellow, [ConsoleColor]::DarkGray, [ConsoleColor]::Yellow
            }
            $TestText = "[$Type]", "[Forest] ", $Text
        }
    } else {
        if ($Type -eq 't') {
            [ConsoleColor[]] $Color = [ConsoleColor]::Cyan, [ConsoleColor]::DarkGray, [ConsoleColor]::Yellow
        } elseif ($Type -eq 'e') {
            [ConsoleColor[]] $Color = [ConsoleColor]::Red, [ConsoleColor]::DarkGray, [ConsoleColor]::Yellow
        } else {
            [ConsoleColor[]] $Color = [ConsoleColor]::Yellow, [ConsoleColor]::DarkGray, [ConsoleColor]::Yellow
        }
        $TestText = "[$Type]", "[$Scope] ", $Text
    }
    Write-Color -Text $TestText -Color $Color -StartSpaces $Level -NoNewLine
}