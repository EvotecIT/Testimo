function Start-TestProcessing {
    [CmdletBinding()]
    param(


        [ScriptBlock] $Execute,
        [scriptblock] $Data,
        [string] $Test,
        [switch] $OutputRequired,
        [bool] $ExpectedStatus,
        [int] $Level = 0,
        [switch] $IsTest
    )
    if ($IsTest) {
        Write-Color '[i] ', 'Executing test ', $Test -Color Blue, Yellow, Blue -NoNewLine -StartSpaces ($Level * 3)
    } else {
        Write-Color '[i] ', 'Gathering information ', $Test -Color White, Yellow, White -NoNewLine -StartSpaces ($Level * 3)
    }
    [Array] $Output = & $Execute

    if ($OutputRequired) {
        foreach ($_ in $Output.Output) {
            $_
        }
    }
    if ($ExpectedStatus -eq $Output.Status) {
        if ($Output.Extended) {
            Write-Color -Text ' [', 'Passed', ']', " [", $Output.Extended, "]" -Color Blue, Green, Blue, Blue, Green, Blue
        } else {
            Write-Color -Text ' [', 'Passed', ']' -Color Blue, Green, Blue #, Blue, Green, Blue
        }
    } else {
        if ($Output.Extended) {
            Write-Color -Text ' [', 'Fail', ']', " [", $Output.Extended, "]" -Color Blue, Red, Blue, Blue, Red, Blue
        } else {
            Write-Color -Text ' [', 'Fail', ']' -Color Blue, Red, Blue #, Blue, Green, Blue
        }
    }

    $Global:TestResults.Add(
        [PSCustomObject]@{
            Test     = $Test
            Status   = $ExpectedStatus -eq $Output.Status
            Extended = $Output.Extended
        }
    )
}

$Global:TestResults = [System.Collections.Generic.List[PSCustomObject]]::new()