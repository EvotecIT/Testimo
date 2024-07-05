function Out-Summary {
    <#
    .SYNOPSIS
    Outputs a summary of the tests performed.

    .DESCRIPTION
    The Out-Summary function outputs a summary of the tests performed, including various details such as test results, execution time, and test counts.

    .PARAMETER Scope
    Specifies the scope of the tests (e.g., 'Forest', 'Domain', 'DC').

    .PARAMETER Time
    Specifies the stopwatch object to measure the time taken for the tests.

    .PARAMETER Text
    Specifies additional text to include in the summary.

    .PARAMETER Level
    Specifies the level of the summary.

    .PARAMETER Domain
    Specifies the domain for the tests.

    .PARAMETER DomainController
    Specifies the domain controller for the tests.

    .PARAMETER TestsSummary
    Specifies a custom object containing the summary of the tests.

    .EXAMPLE
    Out-Summary -Scope 'Domain' -Time $stopwatch -Text 'Additional information' -Level 1 -Domain 'example.com' -DomainController 'DC1' -TestsSummary $summaryObject
    Outputs a summary for the tests performed in the 'Domain' scope with the specified details.

    .EXAMPLE
    Out-Summary -Scope 'Forest' -Time $stopwatch -Text 'Detailed summary' -Level 2 -Domain 'example.com' -DomainController 'DC1' -TestsSummary $summaryObject
    Outputs a detailed summary for the tests performed in the 'Forest' scope with the specified details.
    #>
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