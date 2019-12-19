function Start-TestProcessing {
    [CmdletBinding()]
    param(
        [ScriptBlock] $Execute,
        [string] $Test,
        [switch] $OutputRequired,
        [nullable[bool]] $ExpectedStatus,
        [int] $Level = 0,
       # [switch] $IsTest,
        [switch] $Simple,
        [string] $Domain,
        [string] $DomainController,
        [string] $ReferenceID
    )

    if ($Execute) {
       # if ($IsTest) {
           # Out-Begin -Type 't' -Text $Test -Level $Level -Domain $Domain -DomainController $DomainController
        #} else {
            #Out-Begin -Type 'i' -Text $Test -Level $Level -Domain $Domain -DomainController $DomainController
            Out-Informative -Text $Test -Level $Level -Domain $Domain -DomainController $DomainController -Start
       # }
        if ($Script:TestimoConfiguration.Debug.ShowErrors) {
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

            #Out-Status -Text $Test -Status $TestResult -ExtendedValue $O.Extended -Domain $Domain -DomainController $DomainController -ReferenceID $ReferenceID

            #Out-Informative -Text $Test -Status $TestResult -ExtendedValue $O.Extended -Domain $Domain -DomainController $DomainController -ReferenceID $ReferenceID -End
            Out-Informative -Text $Test -Status $TestResult -ExtendedValue $O.Extended -Domain $Domain -DomainController $DomainController -End
        } else {
           # Out-Informative -Text $Test -Status $TestResult -ExtendedValue $ErrorMessage -Domain $Domain -DomainController $DomainController -ReferenceID $ReferenceID -End
            Out-Informative -Text $Test -Status $TestResult -ExtendedValue $ErrorMessage -Domain $Domain -DomainController $DomainController -End
            #Out-Status -Text $Test -Status $false -ExtendedValue $ErrorMessage -Domain $Domain -DomainController $DomainController -ReferenceID $ReferenceID
        }
    }
}