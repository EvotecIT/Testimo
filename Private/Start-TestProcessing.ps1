function Start-TestProcessing {
    [CmdletBinding()]
    param(
        [ScriptBlock] $Execute,
        [ScriptBlock] $Data,
        [ScriptBlock] $Tests,
        [string] $Test,
        [switch] $OutputRequired,
        [nullable[bool]] $ExpectedStatus,
        [int] $Level = 0,
        [switch] $IsTest,
        [switch] $Simple
    )

    if ($Execute) {
        if ($IsTest) {
            Out-Begin -Type 't' -Text $Test -Level ($Level * 3)
        } else {
            Out-Begin -Type 'i' -Text $Test -Level ($Level * 3)
        }

        [Array] $Output = & $Execute
        foreach ($O in $Output) {
            if ($OutputRequired.IsPresent) {
                if ($O['Output']) {
                    foreach ($_ in $O['Output']) {
                        $_
                    }
                } else {
                    foreach ($_ in $O) {
                        $_
                    }
                }
            }
        }
        if ($null -eq $ExpectedStatus) {
            $TestResult = $null
        } else {
            $TestResult = $ExpectedStatus -eq $Output.Status
        }

        Out-Status -Text $Test -Status $TestResult -ExtendedValue $O.Extended
        return
    }

    if ($Data) {
        Out-Begin -Type 'i' -Text $Test -Level ($Level * 3)

        [Array] $Output = & $Data
        if ($Output.Contains('Status') -and $Output.Contains('Extended') -and $Output.Contains('Output')) {
            $GatheredData = $Output.Output
            Out-Status -Text $Test -Status $Output.Status -ExtendedValue $Output.Extended

        } else {
            $GatheredData = $Output
            Out-Status -Text $Test -Status $null
        }

        [Array] $TestsExecution = & $Tests
        foreach ($_ in $TestsExecution) {
            Out-Begin -Text $_.TestName -Level ($Level * 6)
            if ($_.Type -eq 'Hash') {
                $Value = $GatheredData.$($_.Property)

                if ($_.Comparison -eq 'lt') {
                    $TestResult = $Value -lt $_.ExpectedValue
                } elseif ($_.Comparison -eq 'gt') {
                    $TestResult = $Value -gt $_.ExpectedValue
                } elseif ($_.Comparison -eq 'ge') {
                    $TestResult = $Value -ge $_.ExpectedValue
                } elseif ($_.Comparison -eq 'le') {
                    $TestResult = $Value -le $_.ExpectedValue
                } else {
                    $TestResult = $Value -eq $_.ExpectedValue
                }

                Out-Status -Text $_.TestName -Status $TestResult -ExtendedValue $Value
            } elseif ($_.Type -eq 'Array') {
                foreach ($Object in $GatheredData) {

                    if ($Object.$($_.SearchObjectProperty) -eq $_.SearchObjectValue) {
                        $Value = $Object.$($_.Property)

                        $TestResult = $Value -eq $_.ExpectedValue

                        Out-Status -Text $_.TestName -Status $TestResult -ExtendedValue $Value
                    }

                }
            }
        }

    }
}