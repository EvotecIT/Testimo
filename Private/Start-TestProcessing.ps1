function Start-TestProcessing {
    [CmdletBinding()]
    param(
        [ScriptBlock] $Execute,
        [string] $Test,
        [switch] $OutputRequired,
        [nullable[bool]] $ExpectedStatus,
        [int] $Level = 0,
        [switch] $IsTest,
        [switch] $Simple,
        [string] $Domain,
        [string] $DomainController
    )

    if ($Execute) {
        if ($IsTest) {
            Out-Begin -Type 't' -Text $Test -Level $Level -Domain $Domain -DomainController $DomainController # ($Level * 3)
        } else {
            Out-Begin -Type 'i' -Text $Test -Level $Level -Domain $Domain -DomainController $DomainController # ($Level * 3)
        }
        if ($Script:TestimoConfiguration.Debug.DisableTryCatch) {
            [Array] $Output = & $Execute
            $ErrorMessage = $null
        } else {
            try {
                [Array] $Output = & $Execute
            } catch {
                $ErrorMessage = $_.Exception.Message -replace "`n", " " -replace "`r", " "
            }
        }
        if (-not $ErrorMessage) {
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

            Out-Status -Text $Test -Status $TestResult -ExtendedValue $O.Extended -Domain $Domain -DomainController $DomainController
        } else {
            Out-Status -Text $Test -Status $false -ExtendedValue $ErrorMessage -Domain $Domain -DomainController $DomainController
        }
    }
}