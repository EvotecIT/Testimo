function Out-Begin {
    param(
        [string] $Text,
        [int] $Level,
        [string] $Type = 't'
    )
    [ConsoleColor[]] $Color = [ConsoleColor]::Cyan, [ConsoleColor]::Yellow
    Write-Color -Text "[$Type] ", $Text -Color $Color -StartSpaces $Level -NoNewLine
}