function Test-ImoAD {
    [CmdletBinding()]
    param(
        [switch] $ReturnResults
    )
    $Time = Start-TimeLog
    $Script:TestResults = [System.Collections.Generic.List[PSCustomObject]]::new()

    # Imports all commands / including private ones from PSWinDocumentation.AD
    $ADModule = Import-Module PSWinDocumentation.AD -PassThru

    <#
    $Forest = & $Script:SBForest

    & $Script:SBForestOptionalFeatures
    & $Script:SBForestReplication
    & $Script:SBForestLastBackup

    foreach ($Domain in $Forest.Domains) {
        & $Script:SBDomainPasswordComplexity -Domain $Domain
        & $Script:SBDomainTrusts -Domain $Domain

        $DomainInformation = & $Script:SBDomainInformation -Domain $Domain

        $DomainControllers = & $Script:SBDomainControllers -Domain $Domain

        foreach ($_ in $DomainControllers) {
            & $Script:SBDomainControllersLDAP -DomainController $_
            & $Script:SBDomainControllersPing -DomainController $_
            & $Script:SBDomainControllersPort53 -DomainController $_
            & $Script:SBDomainControllersServices -DomainController $_
            & $Script:SBDomainControllersRespondsPS -DomainController $_
        }
    }
    #>

    $Forest = & $Script:SBForest

    # Tests related to FOREST
    <#
    foreach ($Test in $($Script:Configuration.Forest.Tests.Keys)) {
        $CurrentTest = $Script:Configuration.Forest.Tests[$Test]
        if ($CurrentTest['Enable']) {
            & $CurrentTest['ScriptBlock']
        }
    }
    #>

    # Tests related to FOREST
    <#
    foreach ($Source in $($Script:Configuration.Forest.Sources.Keys)) {
        $CurrentSource = $Script:Configuration.Forest.Sources[$Source]
        if ($CurrentSource['Enable'] -eq $true) {
            $Time = Start-TimeLog
            $Object = Start-TestProcessing -Test $CurrentSource['SourceName'] -Level 0 -OutputRequired {
                & $CurrentSource['SourceData'] -Domain $Domain
            }
            if ($Object) {
                $FailAllTests = $false
            } else {
                $FailAllTests = $true
            }
            foreach ($Test in $CurrentSource['Tests'].Keys) {
                $CurrentTest = $CurrentSource['Tests'][$Test]
                if ($CurrentTest['Enable'] -eq $True) {
                    if (-not $FailAllTests) {
                        if ($CurrentTest['TestParameters']) {
                            $Parameters = $CurrentTest['TestParameters']
                        } else {
                            $Parameters = $null
                        }
                        & $CurrentTest['TestSource'] -Object $Object -Domain $Domain @Parameters -Level 1
                    } else {
                        Out-Failure -Text $CurrentTest['TestName'] -Level 3
                    }
                }
            }
            Out-Summary -Text $CurrentSource['SourceName'] -Time $Time
        }
    }
    #>
    Start-Testing -Scope 'Forest'

    # Tests related to DOMAIN
    foreach ($Domain in $Forest.Domains) {
        <#
        foreach ($Source in $($Script:Configuration.Domain.Sources.Keys)) {
            $CurrentSource = $Script:Configuration.Domain.Sources[$Source]
            if ($CurrentSource['Enable'] -eq $true) {
                $Time = Start-TimeLog
                $Object = Start-TestProcessing -Test $CurrentSource['SourceName'] -Level 0 -OutputRequired {
                    & $CurrentSource['SourceData'] -Domain $Domain
                }
                if ($Object) {
                    $FailAllTests = $false
                } else {
                    $FailAllTests = $true
                }
                foreach ($Test in $CurrentSource['Tests'].Keys) {
                    $CurrentTest = $CurrentSource['Tests'][$Test]
                    if ($CurrentTest['Enable'] -eq $True) {
                        if (-not $FailAllTests) {
                            if ($CurrentTest['TestParameters']) {
                                $Parameters = $CurrentTest['TestParameters']
                            } else {
                                $Parameters = $null
                            }
                            & $CurrentTest['TestSource'] -Object $Object -Domain $Domain @Parameters -Level 1
                        } else {
                            # Out-Begin -Text $CurrentTest['TestName'] -Level 3
                            # Out-Status -Text $CurrentTest['TestName'] -Status $false -ExtendedValue 'Input data not provided. Failing test.'
                            Out-Failure -Text $CurrentTest['TestName'] -Level 3
                        }
                    }
                }
                Out-Summary -Text $CurrentSource['SourceName'] -Time $Time
            }
        }
        #>
        Start-Testing -Scope 'Domain' -Domain $Domain -DomainController $DomainController

        # Tests related to DOMAIN CONTROLLERS
        $DomainControllers = & $Script:SBDomainControllers -Domain $Domain
        foreach ($DomainController in $DomainControllers) {
            <#
            foreach ($Source in $($Script:Configuration.DomainControllers.Sources.Keys)) {
                $CurrentSource = $Script:Configuration.DomainControllers.Sources[$Source]
                if ($CurrentSource['Enable'] -eq $true) {
                    # $Data = & $CurrentSource['Data'] -DomainController $DomainController
                    $Time = Start-TimeLog
                    $Object = Start-TestProcessing -Test $CurrentSource['SourceName'] -Level 0 -OutputRequired {
                        & $CurrentSource['SourceData'] -DomainController $DomainController
                    }
                    # If there's no output from Source Data all other tests will fail
                    if ($Object) {
                        $FailAllTests = $false
                    } else {
                        $FailAllTests = $true
                    }
                    foreach ($Test in $CurrentSource['Tests'].Keys) {
                        $CurrentTest = $CurrentSource['Tests'][$Test]
                        if ($CurrentTest['Enable'] -eq $True) {
                            if (-not $FailAllTests) {
                                if ($CurrentTest['TestParameters']) {
                                    $Parameters = $CurrentTest['TestParameters']
                                } else {
                                    $Parameters = $null
                                }
                                & $CurrentTest['TestSource'] -Object $Object -Domain $Domain -DomainController $DomainController @Parameters -Level 1
                            } else {
                                Out-Failure -Text $CurrentTest['TestName'] -Level 3
                            }
                        }
                    }
                    Out-Summary -Text $CurrentSource['SourceName'] -Time $Time
                }
            }
            #>
            Start-Testing -Scope 'DomainControllers' -Domain $Domain -DomainController $DomainController
        }
    }

    # Summary
    $TestsPassed = (($Script:TestResults) | Where-Object { $_.Status -eq $true }).Count
    $TestsFailed = (($Script:TestResults) | Where-Object { $_.Status -eq $false }).Count
    $TestsSkipped = 0

    $EndTime = Stop-TimeLog -Time $Time -Option OneLiner

    Write-Color -Text '[i] ', 'Time to execute tests: ', $EndTime -Color Yellow, DarkGray, Cyan
    Write-Color -Text '[i] ', 'Tests Passed: ', $TestsPassed, ' Tests Failed: ', $TestsFailed, ' Tests Skipped: ', $TestsSkipped -Color Yellow, DarkGray, Green, DarkGray, Red, DarkGray, Cyan

    # This results informaiton in form of Array for future processing
    if ($ReturnResults) {
        $Script:TestResults
    }
}