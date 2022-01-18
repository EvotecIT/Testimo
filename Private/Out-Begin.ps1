﻿function Out-Begin {
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