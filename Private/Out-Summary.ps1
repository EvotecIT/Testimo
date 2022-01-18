function Out-Summary {
    [CmdletBinding()]
    param(
        [string] $Scope,
        [System.Diagnostics.Stopwatch] $Time,
        $Text,
        [int] $Level,
        [string] $Domain,
        [string] $DomainController,
        [PSCustomobject] $TestsSummary
    )
    $EndTime = Stop-TimeLog -Time $Time -Option OneLiner
    $Type = 'i'
    if ($Scope -in 'Forest', 'Domain', 'DC') {
        if ($Domain -and $DomainController) {
            if ($Type -eq 't') {
                [ConsoleColor[]] $Color = @(
                    [ConsoleColor]::Cyan,
                    [ConsoleColor]::DarkGray,
                    [ConsoleColor]::DarkGray,
                    [ConsoleColor]::Yellow,
                    [ConsoleColor]::Yellow,
                    [ConsoleColor]::DarkGray,
                    [ConsoleColor]::Yellow,
                    [ConsoleColor]::DarkGray
                )
            } else {
                [ConsoleColor[]] $Color = @(
                    [ConsoleColor]::Yellow, # Type
                    [ConsoleColor]::DarkGray, # Domain
                    [ConsoleColor]::DarkGray, # Domain Controller
                    [ConsoleColor]::Yellow, # Text
                    [ConsoleColor]::Yellow, # [
                    [ConsoleColor]::DarkGray, # Time To Execute Text
                    [ConsoleColor]::Yellow, # Actual Time
                    [ConsoleColor]::DarkGray, # Bracket ]
                    [ConsoleColor]::DarkGray # Bracket [
                    [ConsoleColor]::Yellow, # Tests Total text
                    [ConsoleColor]::White, # Count Tests
                    [ConsoleColor]::Yellow # Tests Tests
                    [ConsoleColor]::Green # Tests passed
                    [ConsoleColor]::Yellow # Tests failed
                    [ConsoleColor]::Red # Tests failed count
                    [ConsoleColor]::Yellow # Tests skipped
                    [ConsoleColor]::Cyan # Tests skipped count
                )
            }
            $TestText = @(
                "[$Type]", # Yellow
                "[$Domain]", # DarkGray
                "[$($DomainController)] ", # DarkGray
                $Text, # Yellow
                ' [', # Yellow
                'Time to execute tests: ', # DarkGray
                $EndTime, # Yellow
                ']', # DarkGray
                '[', # DarkGray
                'Tests Total: ', # Yellow
            ($TestsSummary.Total), # White
                ', Passed: ', # Yellow
            ($TestsSummary.Passed),
                ', Failed: ',
            ($TestsSummary.Failed),
                ', Skipped: ',
            ($TestsSummary.Skipped),
                ']'
            )
        } elseif ($Domain) {
            if ($Type -eq 't') {
                [ConsoleColor[]] $Color = [ConsoleColor]::Cyan, [ConsoleColor]::DarkGray, [ConsoleColor]::Yellow, [ConsoleColor]::DarkGray, [ConsoleColor]::Yellow, [ConsoleColor]::DarkGray
            } else {
                [ConsoleColor[]] $Color = @(
                    [ConsoleColor]::Yellow, # Type
                    [ConsoleColor]::DarkGray, # Domain
                    #[ConsoleColor]::DarkGray, # Domain Controller
                    [ConsoleColor]::Yellow, # Text
                    [ConsoleColor]::Yellow, # [
                    [ConsoleColor]::DarkGray, # Time To Execute Text
                    [ConsoleColor]::Yellow, # Actual Time
                    [ConsoleColor]::DarkGray, # Bracket ]
                    [ConsoleColor]::DarkGray # Bracket [
                    [ConsoleColor]::Yellow, # Tests Total text
                    [ConsoleColor]::White, # Count Tests
                    [ConsoleColor]::Yellow # Tests Tests
                    [ConsoleColor]::Green # Tests passed
                    [ConsoleColor]::Yellow # Tests failed
                    [ConsoleColor]::Red # Tests failed count
                    [ConsoleColor]::Yellow # Tests skipped
                    [ConsoleColor]::Cyan # Tests skipped count
                )
            }
            $TestText = @(
                "[$Type]", # Yellow
                "[$Domain] ", # DarkGray
                # "[$($DomainController)] ", # DarkGray
                $Text, # Yellow
                ' [', # Yellow
                'Time to execute tests: ', # DarkGray
                $EndTime, # Yellow
                ']', # DarkGray
                '[', # DarkGray
                'Tests Total: ', # Yellow
            ($TestsSummary.Total), # White
                ', Passed: ', # Yellow
            ($TestsSummary.Passed),
                ', Failed: ',
            ($TestsSummary.Failed),
                ', Skipped: ',
            ($TestsSummary.Skipped),
                ']'
            )
        } elseif ($DomainController) {
            # Shouldn't really happen
            Write-Warning "Out-Begin - Shouldn't happen - Fix me."
        } else {
            if ($Type -eq 't') {
                [ConsoleColor[]] $Color = [ConsoleColor]::Cyan, [ConsoleColor]::DarkGray, [ConsoleColor]::Yellow, [ConsoleColor]::DarkGray, [ConsoleColor]::Yellow, [ConsoleColor]::DarkGray
            } else {
                [ConsoleColor[]] $Color = @(
                    [ConsoleColor]::Yellow, # Type
                    [ConsoleColor]::DarkGray, # Domain / Forest
                    #[ConsoleColor]::DarkGray, # Domain Controller
                    [ConsoleColor]::Yellow, # Text
                    [ConsoleColor]::Yellow, # [
                    [ConsoleColor]::DarkGray, # Time To Execute Text
                    [ConsoleColor]::Yellow, # Actual Time
                    [ConsoleColor]::DarkGray, # Bracket ]
                    [ConsoleColor]::DarkGray # Bracket [
                    [ConsoleColor]::Yellow, # Tests Total text
                    [ConsoleColor]::White, # Count Tests
                    [ConsoleColor]::Yellow # Tests Tests
                    [ConsoleColor]::Green # Tests passed
                    [ConsoleColor]::Yellow # Tests failed
                    [ConsoleColor]::Red # Tests failed count
                    [ConsoleColor]::Yellow # Tests skipped
                    [ConsoleColor]::Cyan # Tests skipped count
                )
            }
            $TestText = @(
                "[$Type]", # Yellow
                "[Forest] ", # DarkGray
                # "[$($DomainController)] ", # DarkGray
                $Text, # Yellow
                ' [', # Yellow
                'Time to execute tests: ', # DarkGray
                $EndTime, # Yellow
                ']', # DarkGray
                '[', # DarkGray
                'Tests Total: ', # Yellow
            ($TestsSummary.Total), # White
                ', Passed: ', # Yellow
            ($TestsSummary.Passed),
                ', Failed: ',
            ($TestsSummary.Failed),
                ', Skipped: ',
            ($TestsSummary.Skipped),
                ']'
            )
        }
    } else {
        if ($Type -eq 't') {
            [ConsoleColor[]] $Color = [ConsoleColor]::Cyan, [ConsoleColor]::DarkGray, [ConsoleColor]::Yellow, [ConsoleColor]::DarkGray, [ConsoleColor]::Yellow, [ConsoleColor]::DarkGray
        } else {
            [ConsoleColor[]] $Color = @(
                [ConsoleColor]::Yellow, # Type
                [ConsoleColor]::DarkGray, # Domain / Forest
                #[ConsoleColor]::DarkGray, # Domain Controller
                [ConsoleColor]::Yellow, # Text
                [ConsoleColor]::Yellow, # [
                [ConsoleColor]::DarkGray, # Time To Execute Text
                [ConsoleColor]::Yellow, # Actual Time
                [ConsoleColor]::DarkGray, # Bracket ]
                [ConsoleColor]::DarkGray # Bracket [
                [ConsoleColor]::Yellow, # Tests Total text
                [ConsoleColor]::White, # Count Tests
                [ConsoleColor]::Yellow # Tests Tests
                [ConsoleColor]::Green # Tests passed
                [ConsoleColor]::Yellow # Tests failed
                [ConsoleColor]::Red # Tests failed count
                [ConsoleColor]::Yellow # Tests skipped
                [ConsoleColor]::Cyan # Tests skipped count
            )
        }
        $TestText = @(
            "[$Type]", # Yellow
            "[$Scope] ", # DarkGray
            # "[$($DomainController)] ", # DarkGray
            $Text, # Yellow
            ' [', # Yellow
            'Time to execute tests: ', # DarkGray
            $EndTime, # Yellow
            ']', # DarkGray
            '[', # DarkGray
            'Tests Total: ', # Yellow
        ($TestsSummary.Total), # White
            ', Passed: ', # Yellow
        ($TestsSummary.Passed),
            ', Failed: ',
        ($TestsSummary.Failed),
            ', Skipped: ',
        ($TestsSummary.Skipped),
            ']'
        )
    }
    Write-Color -Text $TestText -Color $Color -StartSpaces $Level
}