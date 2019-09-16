function Out-Informative {
    param(
        [int] $Level = 0,
        [string] $Domain,
        [string] $DomainController,
        [string] $Text,
        [nullable[bool]] $Status,
        [string] $ExtendedValue,
        [switch] $Start,
        [switch] $End
    )

    if ($Start -or (-not $Start -and -not $End)) {
        $Type = 'i'
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
            $TestText = "[$Type]", "[Forest] ", $Text
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
        if ($ExtendedValue) {
            Write-Color -Text ' [', $TextStatus, ']', " [", $ExtendedValue, "]" -Color $Color
        } else {
            Write-Color -Text ' [', $TextStatus, ']' -Color $Color
        }
    }

}