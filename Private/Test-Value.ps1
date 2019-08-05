function Test-Value {
    [CmdletBinding()]
    param(
        [Object] $Object,
        [string] $TestName,
        [string] $Property,
        [Object] $ExpectedValue,
        [string] $PropertExtendedValue,
        [switch] $lt,
        [switch] $gt,
        [switch] $le,
        [switch] $eq,
        [switch] $ge,
        [int] $Level
    )

    if ($Object) {
        Out-Begin -Text $TestName -Level 3
        #Write-Color '[t] ', $TestName -Color Cyan, Yellow, Cyan -NoNewLine -StartSpaces ($Level * 3)
        try {
            if ($lt) {
                $TestResult = $Object.$Property -lt $ExpectedValue
            } elseif ($gt) {
                $TestResult = $Object.$Property -gt $ExpectedValue
            } elseif ($ge) {
                $TestResult = $Object.$Property -ge $ExpectedValue
            } elseif ($le) {
                $TestResult = $Object.$Property -le $ExpectedValue
            } else {
                $TestResult = $Object.$Property -eq $ExpectedValue
            }

            # Run quick tests
            if ($TestResult) {
                #[string] $Text = 'Pass'
                # [bool] $Status = $true
                $Extended = "Expected value: $($Object.$Property)"
                #[ConsoleColor[]] $Color = [ConsoleColor]::Cyan, [ConsoleColor]::Green, [ConsoleColor]::Cyan, [ConsoleColor]::Cyan, [ConsoleColor]::Green, [ConsoleColor]::Cyan
            } else {
                # [string] $Text = 'Fail'
                #[bool] $Status = $false
                $Extended = "Expected value: $ExpectedValue, Found value: $($Object.$Property)"
                #[ConsoleColor[]] $Color = [ConsoleColor]::Cyan, [ConsoleColor]::Red, [ConsoleColor]::Cyan, [ConsoleColor]::Cyan, [ConsoleColor]::Red, [ConsoleColor]::Cyan
            }
            if ($PropertExtendedValue) {
                $Extended = $($Object.$PropertExtendedValue)
            }

            Out-Status -Text $TestName -Status $TestResult -ExtendedValue $Extended

            <#

            # Prepare output to console / and to custom object
            Write-Color -Text ' [', $Text, ']', " [", $Extended, "]" -Color $Color
            $Script:TestResults.Add(
                [PSCustomObject]@{
                    Test     = $TestName
                    Status   = $Status
                    Extended = $Extended
                }
            )
            #>
        } catch {
            Out-Status -Text $TestName -Status $false -ExtendedValue $_.Exception.Message
            <#
            Write-Color -Text ' [', 'Fail', ']', " [", $_.Exception.Message, "]" -Color Cyan, Red, Cyan, Cyan, Red, Cyan
            $Script:TestResults.Add(
                [PSCustomObject]@{
                    Test     = $TestName
                    Status   = $False
                    Extended = $_.Exception.Message
                }
            )
            #>
        }
    } else {
        if ($lt) {
            $Comparison = 'lt'
        } elseif ($gt) {
            $Comparison = 'gt'
        } elseif ($ge) {
            $Comparison = 'ge'
        } elseif ($le) {
            $Comparison = 'le'
        } else {
            $Comparison = 'eq'
        }
        [PSCustomObject] @{
            TestName      = $TestName
            Property      = $Property
            ExpectedValue = $ExpectedValue
            Comparison    = $Comparison
            Type          = 'Hash'
        }
    }
}