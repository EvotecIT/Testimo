function Out-Summary {
    param(
        $Time,
        $Text,
        [int] $Level,
        [string] $Domain,
        [string] $DomainController
    )
    $EndTime = Stop-TimeLog -Time $Time -Option OneLiner

    # Write-Color -Text ' [', $Text, ']', " [", "Time:" $ExtendedValue, "]" -Color $Color

    # Write-Color -Text '[i] ', $Text, ' [', 'Time to execute tests: ', $EndTime, ']' -Color Cyan, Yellow, Cyan, DarkGray -StartSpaces $Level
    #Write-Color -Text '[i] ', 'Tests Passed: ', $TestsPassed, ' Tests Failed: ', $TestsFailed, ' Tests Skipped: ', $TestsSkipped -Color Yellow, DarkGray, Green, DarkGray, Red, DarkGray, Cyan

    $Type = 'i'

    if ($Domain -and $DomainController) {
        if ($Type -eq 't') {
            [ConsoleColor[]] $Color = [ConsoleColor]::Cyan, [ConsoleColor]::DarkGray, [ConsoleColor]::DarkGray, [ConsoleColor]::Yellow, [ConsoleColor]::Yellow, [ConsoleColor]::DarkGray
        } else {
            [ConsoleColor[]] $Color = [ConsoleColor]::Yellow, [ConsoleColor]::DarkGray, [ConsoleColor]::DarkGray, [ConsoleColor]::Yellow, [ConsoleColor]::Yellow, [ConsoleColor]::DarkGray
        }
        $TestText = "[$Type]", "[$Domain]", "[$($DomainController)] ", $Text, ' [', 'Time to execute tests: ', $EndTime, ']'
    } elseif ($Domain) {
        if ($Type -eq 't') {
            [ConsoleColor[]] $Color = [ConsoleColor]::Cyan, [ConsoleColor]::DarkGray, [ConsoleColor]::Yellow, [ConsoleColor]::DarkGray
        } else {
            [ConsoleColor[]] $Color = [ConsoleColor]::Yellow, [ConsoleColor]::DarkGray, [ConsoleColor]::Yellow, [ConsoleColor]::DarkGray
        }
        $TestText = "[$Type]", "[$Domain] ", $Text, ' [', 'Time to execute tests: ', $EndTime, ']'
    } elseif ($DomainController) {
        # Shouldn't really happen
        Write-Warning "Out-Begin - Shouldn't happen - Fix me."
    } else {
        if ($Type -eq 't') {
            [ConsoleColor[]] $Color = [ConsoleColor]::Cyan, [ConsoleColor]::DarkGray, [ConsoleColor]::Yellow, [ConsoleColor]::DarkGray
        } else {
            [ConsoleColor[]] $Color = [ConsoleColor]::Yellow, [ConsoleColor]::DarkGray, [ConsoleColor]::Yellow, [ConsoleColor]::DarkGray
        }
        $TestText = "[$Type]", "[Forest] ", $Text, ' [', 'Time to execute tests: ', $EndTime, ']'
    }

    Write-Color -Text $TestText -Color $Color -StartSpaces $Level
}