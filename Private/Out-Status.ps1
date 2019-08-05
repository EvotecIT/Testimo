<#function Out-Status {
    param(
        [string] $Text,
        [nullable[bool]] $Status,
        [string] $Section,
        [string] $ExtendedValue,
        [int] $Level
    )
    if ($Status -eq $true) {
        [string] $TextStatus = 'Pass'
        [ConsoleColor[]] $Color = [ConsoleColor]::Cyan, [ConsoleColor]::Green, [ConsoleColor]::Cyan, [ConsoleColor]::Green, [ConsoleColor]::Cyan, [ConsoleColor]::Cyan, [ConsoleColor]::Green, [ConsoleColor]::Cyan
    } elseif ($Status -eq $false) {
        [string] $TextStatus = 'Fail'
        [ConsoleColor[]] $Color =  [ConsoleColor]::Cyan, [ConsoleColor]::Red, [ConsoleColor]::Cyan, [ConsoleColor]::Red, [ConsoleColor]::Cyan, [ConsoleColor]::Cyan, [ConsoleColor]::Red, [ConsoleColor]::Cyan
    } else {
        [string] $TextStatus = 'Informative'
        [ConsoleColor[]] $Color = [ConsoleColor]::Cyan, [ConsoleColor]::DarkGray, [ConsoleColor]::Cyan, [ConsoleColor]::DarkGray, [ConsoleColor]::Cyan, [ConsoleColor]::Cyan, [ConsoleColor]::DarkGray, [ConsoleColor]::Cyan
    }
    if ($ExtendedValue) {
        Write-Color -Text '[t] ', $Text, ' [', $TextStatus, ']', " [", $ExtendedValue, "]" -Color $Color -StartSpaces $Level
    } else {
        Write-Color -Text '[t] ', $Text, ' [', $TextStatus, ']' -Color $Color -StartSpaces $Level
    }
    $Script:TestResults.Add(
        [PSCustomObject]@{
            Test     = $Text
            Section  = $Section
            Status   = $Status
            Extended = $ExtendedValue
        }
    )
}
#>
function Out-Status {
    param(
        [string] $Text,
        [nullable[bool]] $Status,
        [string] $Section,
        [string] $ExtendedValue
    )
    if ($Status -eq $true) {
        [string] $TextStatus = 'Pass'
        [ConsoleColor[]] $Color = [ConsoleColor]::Cyan, [ConsoleColor]::Green, [ConsoleColor]::Cyan, [ConsoleColor]::Cyan, [ConsoleColor]::Green, [ConsoleColor]::Cyan
    } elseif ($Status -eq $false) {
        [string] $TextStatus = 'Fail'
        [ConsoleColor[]] $Color = [ConsoleColor]::Cyan, [ConsoleColor]::Red, [ConsoleColor]::Cyan, [ConsoleColor]::Cyan, [ConsoleColor]::Red, [ConsoleColor]::Cyan
    } else {
        [string] $TextStatus = 'Informative'
        [ConsoleColor[]] $Color = [ConsoleColor]::Cyan, [ConsoleColor]::DarkGray, [ConsoleColor]::Cyan, [ConsoleColor]::Cyan, [ConsoleColor]::DarkGray, [ConsoleColor]::Cyan
    }
    if ($ExtendedValue) {
        Write-Color -Text ' [', $TextStatus, ']', " [", $ExtendedValue, "]" -Color $Color
    } else {
        Write-Color -Text ' [', $TextStatus, ']' -Color $Color
    }
    $Script:TestResults.Add(
        [PSCustomObject]@{
            Test     = $Text
            Section  = $Section
            Status   = $Status
            Extended = $ExtendedValue
        }
    )
}