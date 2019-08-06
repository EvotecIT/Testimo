function Out-Begin {
    param(
        [string] $Text,
        [int] $Level,
        [string] $Type = 't'
    )
    if ($Type -eq 't') {
        [ConsoleColor[]] $Color = [ConsoleColor]::Cyan, [ConsoleColor]::DarkGray
    } else {
        [ConsoleColor[]] $Color = [ConsoleColor]::Yellow, [ConsoleColor]::DarkGray
    }
    Write-Color -Text "[$Type] ", $Text -Color $Color -StartSpaces $Level -NoNewLine
}