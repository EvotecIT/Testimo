function Start-Testing {
    [CmdletBinding()]
    param(
        [ScriptBlock] $Execute,
        [string] $Scope,
        [string] $Domain,
        [string] $DomainController,
        [bool] $IsPDC,
        [Object] $ForestInformation,
        [Object] $DomainInformation,
        [System.Collections.IDictionary] $ForestDetails
    )
    $GlobalTime = Start-TimeLog

    if ($Scope -eq 'Forest') {
        $Level = 3
        $LevelTest = 6
        $LevelSummary = 3
        $LevelTestFailure = 6
    } elseif ($Scope -eq 'Domain') {
        $Level = 6
        $LevelTest = 9
        $LevelSummary = 6
        $LevelTestFailure = 9
    } elseif ($Scope -eq 'DomainControllers') {
        $Level = 9
        $LevelTest = 12
        $LevelSummary = 9
        $LevelTestFailure = 12
    } else {

    }

    if ($Domain -and $DomainController) {
        $SummaryText = "Domain $Domain, $DomainController"
    } elseif ($Domain) {
        Write-Color
        $SummaryText = "Domain $Domain"
    } else {
        $SummaryText = "Forest"
    }

    # Build requirements variables
    [bool] $IsDomainRoot = $ForestInformation.Name -eq $Domain


    # Out-Begin -Type 'i' -Text $SummaryText -Level ($LevelSummary - 3) -Domain $Domain -DomainController $DomainController
    # Out-Status -Text $SummaryText -Status $null -ExtendedValue '' -Domain $Domain -DomainController $DomainController

    Out-Informative -Text $SummaryText -Status $null -ExtendedValue '' -Domain $Domain -DomainController $DomainController -Level ($LevelSummary - 3)

    $TestsSummaryTogether = @(
        foreach ($Source in ($($Script:TestimoConfiguration.ActiveDirectory)).Keys) {
            if ($Scope -ne $Script:TestimoConfiguration.ActiveDirectory[$Source].Scope) {
                continue
            }
            $CurrentSection = $Script:TestimoConfiguration.ActiveDirectory[$Source]
            if ($null -eq $CurrentSection) {
                # Probably should write some tests
                Write-Warning "Source $Source in scope: $Scope is defined improperly. Please verify."
                continue
            }
            if ($CurrentSection['Enable'] -eq $true) {
                $Time = Start-TimeLog
                $CurrentSource = $CurrentSection['Source']
                #$CurrentTests = $CurrentSection['Tests']
                [Array] $AllTests = $CurrentSection['Tests'].Keys

                $ReferenceID = $Source #Get-RandomStringName -Size 8
                $TestsSummary = [PSCustomobject] @{
                    Passed  = 0
                    Failed  = 0
                    Skipped = 0
                    Total   = 0 # $AllTests.Count + 1 # +1 includes availability of data test
                }
                # build data output for extended results

                if ($Domain -and $DomainController) {
                    $Script:Reporting['Domains'][$Domain]['DomainControllers'][$DomainController]['Tests'][$ReferenceID] = [ordered] @{
                        Name             = $CurrentSource['Name']
                        SourceCode       = $CurrentSource['Data']
                        Details          = $CurrentSource['Details']
                        Results          = [System.Collections.Generic.List[PSCustomObject]]::new()
                        Domain           = $Domain
                        DomainController = $DomainController
                    }
                } elseif ($Domain) {
                    $Script:Reporting['Domains'][$Domain]['Tests'][$ReferenceID] = [ordered] @{
                        Name             = $CurrentSource['Name']
                        SourceCode       = $CurrentSource['Data']
                        Details          = $CurrentSource['Details']
                        Results          = [System.Collections.Generic.List[PSCustomObject]]::new()
                        Domain           = $Domain
                        DomainController = $DomainController
                    }
                } else {
                    $Script:Reporting['Forest']['Tests'][$ReferenceID] = [ordered] @{
                        Name             = $CurrentSource['Name']
                        SourceCode       = $CurrentSource['Data']
                        Details          = $CurrentSource['Details']
                        Results          = [System.Collections.Generic.List[PSCustomObject]]::new()
                        Domain           = $Domain
                        DomainController = $DomainController
                    }
                }

                if (-not $CurrentSection['Source']) {
                    Write-Warning "Source $Source in scope: $Scope is defined improperly. Please verify."
                    continue
                }

                # Check if requirements are met
                if ($CurrentSource['Requirements']) {
                    if ($null -ne $CurrentSource['Requirements']['IsDomainRoot']) {
                        if (-not $CurrentSource['Requirements']['IsDomainRoot'] -eq $IsDomainRoot) {
                            Out-Skip -Test $CurrentSource['Name'] -DomainController $DomainController -Domain $Domain -TestsSummary $TestsSummary -Source $ReferenceID -Level $Level
                            continue
                        }
                    }
                    if ($null -ne $CurrentSource['Requirements']['IsPDC']) {
                        if (-not $CurrentSource['Requirements']['IsPDC'] -eq $IsPDC) {
                            Out-Skip -Test $CurrentSource['Name'] -DomainController $DomainController -Domain $Domain -TestsSummary $TestsSummary -Source $ReferenceID -Level $Level
                            continue
                        }
                    }
                    if ($null -ne $CurrentSource['Requirements']['OperatingSystem']) {


                    }
                    if ($null -ne $CurrentSource['Requirements']['CommandAvailable']) {
                        [Array] $Commands = foreach ($Command in $CurrentSource['Requirements']['CommandAvailable']) {
                            $OutputCommand = Get-Command -Name $Command -ErrorAction SilentlyContinue
                            if (-not $OutputCommand) {
                                $false
                            }
                        }
                        if ($Commands -contains $false) {
                            $CommandsTested = $CurrentSource['Requirements']['CommandAvailable'] -join ', '
                            Out-Skip -Test $CurrentSource['Name'] -DomainController $DomainController -Domain $Domain -TestsSummary $TestsSummary -Source $ReferenceID -Level $Level -Reason "Skipping - At least one command unavailable ($CommandsTested)"
                            continue
                        }
                    }
                    if ($null -ne $CurrentSource['Requirements']['IsInternalForest']) {
                        if ($CurrentSource['Requirements']['IsInternalForest'] -eq $true) {
                            if ($ForestName) {
                                Out-Skip -Test $CurrentSource['Name'] -DomainController $DomainController -Domain $Domain -TestsSummary $TestsSummary -Source $ReferenceID -Level $Level -Reason "Skipping - External forest requested. Not supported test."
                                continue
                            }
                        }
                    }
                }
                # START - Execute TEST - By getting the Data SOURCE
                Out-Informative -Text $CurrentSource['Name'] -Level $Level -Domain $Domain -DomainController $DomainController -Start
                if ($CurrentSource['Parameters']) {
                    $SourceParameters = $CurrentSource['Parameters']
                } else {
                    $SourceParameters = @{}
                }
                $SourceParameters['DomainController'] = $DomainController
                if ($Scope -eq 'Forest') {
                    $SourceParameters['QueryServer'] = $ForestDetails['QueryServers']['Forest']['HostName'][0]
                } else {
                    $SourceParameters['QueryServer'] = $ForestDetails['QueryServers'][$Domain]['HostName'][0]
                }
                $SourceParameters['Domain'] = $Domain
                $SourceParameters['ForestDetails'] = $ForestDetails
                $SourceParameters['ForestName'] = $ForestInformation.Name
                $SourceParameters['DomainInformation'] = $DomainInformation
                $SourceParameters['ForestInformation'] = $ForestInformation
                if ($Script:TestimoConfiguration.Debug.ShowErrors) {
                    & $CurrentSource['Data'] -DomainController $DomainController -Domain $Domain
                    $ErrorMessage = $null
                } else {
                    $OutputInvoke = Invoke-CommandCustom -ScriptBlock $CurrentSource['Data'] -Parameter $SourceParameters -ReturnVerbose -ReturnError -ReturnWarning -AddParameter
                    if ($OutputInvoke.Error) {
                        $ErrorMessage = $OutputInvoke.Error.Exception.Message -replace "`n", " " -replace "`r", " "
                    } else {
                        $ErrorMessage = $null
                    }
                }
                $WarningsAndErrors = @(
                    #if ($ShowWarning) {
                    foreach ($War in $OutputInvoke.Warning) {
                        [PSCustomObject] @{
                            Type       = 'Warning'
                            Comment    = $War
                            Reason     = ''
                            TargetName = ''
                        }
                    }
                    #}
                    #if ($ShowError) {
                    foreach ($Err in $OutputInvoke.Error) {
                        [PSCustomObject] @{
                            Type       = 'Error'
                            Comment    = $Err
                            Reason     = $Err.CategoryInfo.Reason
                            TargetName = $Err.CategoryInfo.TargetName
                        }
                    }
                    #}
                )
                Out-Informative -Text $CurrentSource['Name'] -Status $null -ExtendedValue $null -Domain $Domain -DomainController $DomainController -End
                # END - Execute TEST - By getting the Data SOURCE
                $Object = $OutputInvoke.Output
                # Add data output to extended results
                if ($Domain -and $DomainController) {
                    $Script:Reporting['Domains'][$Domain]['DomainControllers'][$DomainController]['Tests'][$ReferenceID]['Data'] = $Object
                    $Script:Reporting['Domains'][$Domain]['DomainControllers'][$DomainController]['Tests'][$ReferenceID]['Verbose'] = $OutputInvoke.Verbose
                    $Script:Reporting['Domains'][$Domain]['DomainControllers'][$DomainController]['Tests'][$ReferenceID]['Warning'] = $OutputInvoke.Warning
                    $Script:Reporting['Domains'][$Domain]['DomainControllers'][$DomainController]['Tests'][$ReferenceID]['Error'] = $OutputInvoke.Error
                    $Script:Reporting['Domains'][$Domain]['DomainControllers'][$DomainController]['Tests'][$ReferenceID]['WarningsAndErrors'] = $WarningsAndErrors
                    $Script:Reporting['Domains'][$Domain]['DomainControllers'][$DomainController]['Tests'][$ReferenceID]['DetailsTests'] = [ordered]@{ }
                    $Script:Reporting['Domains'][$Domain]['DomainControllers'][$DomainController]['Tests'][$ReferenceID]['ResultsTests'] = [ordered]@{ }
                    $Script:Reporting['Domains'][$Domain]['DomainControllers'][$DomainController]['Tests'][$ReferenceID]['Information'] = $CurrentSection
                } elseif ($Domain) {
                    $Script:Reporting['Domains'][$Domain]['Tests'][$ReferenceID]['Data'] = $Object
                    $Script:Reporting['Domains'][$Domain]['Tests'][$ReferenceID]['Verbose'] = $OutputInvoke.Verbose
                    $Script:Reporting['Domains'][$Domain]['Tests'][$ReferenceID]['Warning'] = $OutputInvoke.Warning
                    $Script:Reporting['Domains'][$Domain]['Tests'][$ReferenceID]['Error'] = $OutputInvoke.Error
                    $Script:Reporting['Domains'][$Domain]['Tests'][$ReferenceID]['WarningsAndErrors'] = $WarningsAndErrors
                    $Script:Reporting['Domains'][$Domain]['Tests'][$ReferenceID]['DetailsTests'] = [ordered]@{ }
                    $Script:Reporting['Domains'][$Domain]['Tests'][$ReferenceID]['ResultsTests'] = [ordered]@{ }
                    $Script:Reporting['Domains'][$Domain]['Tests'][$ReferenceID]['Information'] = $CurrentSection
                } else {
                    $Script:Reporting['Forest']['Tests'][$ReferenceID]['Data'] = $Object
                    $Script:Reporting['Forest']['Tests'][$ReferenceID]['Verbose'] = $OutputInvoke.Verbose
                    $Script:Reporting['Forest']['Tests'][$ReferenceID]['Warning'] = $OutputInvoke.Warning
                    $Script:Reporting['Forest']['Tests'][$ReferenceID]['Error'] = $OutputInvoke.Error
                    $Script:Reporting['Forest']['Tests'][$ReferenceID]['WarningsAndErrors'] = $WarningsAndErrors
                    $Script:Reporting['Forest']['Tests'][$ReferenceID]['DetailsTests'] = [ordered]@{ }
                    $Script:Reporting['Forest']['Tests'][$ReferenceID]['ResultsTests'] = [ordered]@{ }
                    $Script:Reporting['Forest']['Tests'][$ReferenceID]['Information'] = $CurrentSection
                }
                # If there's no output from Source Data all other tests will fail
                if ($ErrorMessage) {
                    $FailAllTests = $true
                    $ExtendedValue = $ErrorMessage -join "; "
                    Out-Failure -Text $CurrentSource['Name'] -Level $LevelTest -ExtendedValue $ExtendedValue -Domain $Domain -DomainController $DomainController -ReferenceID $ReferenceID -Source $CurrentSource
                    $TestsSummary.Failed = $TestsSummary.Failed + 1
                } elseif ($Object -and $CurrentSource['ExpectedOutput'] -eq $true) {
                    # Output is provided and we did expect it - passed test
                    $FailAllTests = $false
                    Out-Begin -Text $CurrentSource['Name'] -Level $LevelTest -Domain $Domain -DomainController $DomainController
                    Out-Status -Text $CurrentSource['Name'] -Status $true -ExtendedValue 'Data is available.' -Domain $Domain -DomainController $DomainController -ReferenceID $ReferenceID -Source $CurrentSource
                    $TestsSummary.Passed = $TestsSummary.Passed + 1

                } elseif ($Object -and $CurrentSource['ExpectedOutput'] -eq $false) {
                    # Output is provided, but we expected no output - failing test
                    $FailAllTests = $false
                    Out-Failure -Text $CurrentSource['Name'] -Level $LevelTest -ExtendedValue 'Data is available. This is a bad thing.' -Domain $Domain -DomainController $DomainController -ReferenceID $ReferenceID -Source $CurrentSource
                    $TestsSummary.Failed = $TestsSummary.Failed + 1

                } elseif ($Object -and $null -eq $CurrentSource['ExpectedOutput']) {
                    # Output is provided, but we weren't sure if there should be output or not
                    $FailAllTests = $false
                    Out-Begin -Text $CurrentSource['Name'] -Level $LevelTest -Domain $Domain -DomainController $DomainController
                    Out-Status -Text $CurrentSource['Name'] -Status $null -ExtendedValue 'Data is available.' -Domain $Domain -DomainController $DomainController -ReferenceID $ReferenceID -Source $CurrentSource
                    #$TestsSummary.Passed = $TestsSummary.Passed + 1
                    $TestsSummary.Skipped = $TestsSummary.Skipped + 1

                } elseif ($null -eq $Object -and $CurrentSource['ExpectedOutput'] -eq $true) {
                    # Output was not provided and we expected it
                    $FailAllTests = $true
                    Out-Failure -Text $CurrentSource['Name'] -Level $LevelTest -ExtendedValue 'No data available.' -Domain $Domain -DomainController $DomainController -ReferenceID $ReferenceID -Source $CurrentSource
                    $TestsSummary.Failed = $TestsSummary.Failed + 1
                } elseif ($null -eq $Object -and $CurrentSource['ExpectedOutput'] -eq $false) {
                    # This tests whether there was an output from Source or not.
                    # Sometimes it makes sense to ask for data and get null/empty in return
                    # you just need to make sure to define ExpectedOutput = $false in source definition
                    $FailAllTests = $false
                    Out-Begin -Text $CurrentSource['Name'] -Level $LevelTest -Domain $Domain -DomainController $DomainController
                    Out-Status -Text $CurrentSource['Name'] -Status $true -ExtendedValue 'No data returned, which is a good thing.' -Domain $Domain -DomainController $DomainController -ReferenceID $ReferenceID -Source $CurrentSource
                    $TestsSummary.Passed = $TestsSummary.Passed + 1
                } elseif ($null -eq $Object -and $null -eq $CurrentSource['ExpectedOutput']) {
                    # Output is not provided, but we weren't sure if there should be output or not
                    $FailAllTests = $false
                    Out-Begin -Text $CurrentSource['Name'] -Level $LevelTest -Domain $Domain -DomainController $DomainController
                    Out-Status -Text $CurrentSource['Name'] -Status $null -ExtendedValue 'No data returned.' -Domain $Domain -DomainController $DomainController -ReferenceID $ReferenceID -Source $CurrentSource
                    # $TestsSummary.Passed = $TestsSummary.Passed + 1
                    $TestsSummary.Skipped = $TestsSummary.Skipped + 1
                } else {
                    $FailAllTests = $true
                    Out-Failure -Text $CurrentSource['Name'] -Level $LevelTest -ExtendedValue 'No data available.' -Domain $Domain -DomainController $DomainController -ReferenceID $ReferenceID -Source $CurrentSource
                    $TestsSummary.Failed = $TestsSummary.Failed + 1
                }

                foreach ($Test in $AllTests) {
                    # Add content with description of the test
                    if ($Domain -and $DomainController) {
                        $Script:Reporting['Domains'][$Domain]['DomainControllers'][$DomainController]['Tests'][$ReferenceID]['DetailsTests'][$Test] = $CurrentSection['Tests'][$Test]['Details']
                    } elseif ($Domain) {
                        $Script:Reporting['Domains'][$Domain]['Tests'][$ReferenceID]['DetailsTests'][$Test] = $CurrentSection['Tests'][$Test]['Details']
                    } else {
                        $Script:Reporting['Forest']['Tests'][$ReferenceID]['DetailsTests'][$Test] = $CurrentSection['Tests'][$Test]['Details']
                    }

                    $CurrentTest = $CurrentSection['Tests'][$Test]
                    if ($CurrentTest['Enable'] -eq $True) {
                        # Check for requirements
                        if ($CurrentTest['Requirements']) {
                            if ($null -ne $CurrentTest['Requirements']['IsDomainRoot']) {
                                if (-not $CurrentTest['Requirements']['IsDomainRoot'] -eq $IsDomainRoot) {
                                    $TestsSummary.Skipped = $TestsSummary.Skipped + 1
                                    continue
                                }
                            }
                            if ($null -ne $CurrentTest['Requirements']['IsPDC']) {
                                if (-not $CurrentTest['Requirements']['IsPDC'] -eq $IsPDC) {
                                    $TestsSummary.Skipped = $TestsSummary.Skipped + 1
                                    continue
                                }
                            }
                            #if ($null -ne $CurrentTest['Requirements']['ExpectedOutput']) {
                            #    if ($CurrentTest['Requirements']['ExpectedOutput'] -eq $false) {
                            #        $TestsSummary.Skipped = $TestsSummary.Skipped + 1
                            #        continue
                            #    }
                            #}
                        }
                        if (-not $FailAllTests) {
                            $testStepOneSplat = @{
                                Test             = $CurrentTest
                                Object           = $Object
                                Domain           = $Domain
                                DomainController = $DomainController
                                Level            = $LevelTest
                                TestName         = $CurrentTest['Name']
                                ReferenceID      = $ReferenceID
                                Requirements     = $CurrentTest['Requirements']
                            }
                            # We provide whatever parameters are available in Data Source to Tests (mainly for use within WhereObject)
                            #if ($CurrentSource['Parameters']) {
                            #    $testStepOneSplat['Parameters'] = $CurrentSource['Parameters']
                            #}
                            if ($Scope -eq 'Forest') {
                                $testStepOneSplat['QueryServer'] = $ForestDetails['QueryServers']['Forest']['HostName'][0]
                            } else {
                                $testStepOneSplat['QueryServer'] = $ForestDetails['QueryServers'][$Domain]['HostName'][0]
                            }
                            $testStepOneSplat['ForestDetails'] = $ForestDetails
                            $testStepOneSplat['ForestName'] = $ForestInformation.Name
                            $testStepOneSplat['DomainInformation'] = $DomainInformation
                            $testStepOneSplat['ForestInformation'] = $ForestInformation
                            $TestsResults = Test-StepOne @testStepOneSplat
                            $TestsSummary.Passed = $TestsSummary.Passed + ($TestsResults | Where-Object { $_ -eq $true }).Count
                            $TestsSummary.Failed = $TestsSummary.Failed + ($TestsResults | Where-Object { $_ -eq $false }).Count
                        } else {
                            $TestsResults = $null
                            $TestsSummary.Failed = $TestsSummary.Failed + 1
                            Out-Failure -Text $CurrentTest['Name'] -Level $LevelTestFailure -Domain $Domain -DomainController $DomainController -ReferenceID $ReferenceID -ExtendedValue 'Input data not provided. Failing test.' -Source $CurrentSource
                        }

                        if ($Domain -and $DomainController) {
                            $Script:Reporting['Domains'][$Domain]['DomainControllers'][$DomainController]['Tests'][$ReferenceID]['ResultsTests'][$Test] = $TestsResults
                        } elseif ($Domain) {
                            $Script:Reporting['Domains'][$Domain]['Tests'][$ReferenceID]['ResultsTests'][$Test] = $TestsResults
                        } else {
                            $Script:Reporting['Forest']['Tests'][$ReferenceID]['ResultsTests'][$Test] = $TestsResults
                        }
                    } else {
                        $TestsSummary.Skipped = $TestsSummary.Skipped + 1
                    }
                }
                $TestsSummary.Total = $TestsSummary.Failed + $TestsSummary.Passed + $TestsSummary.Skipped
                $TestsSummary
                Out-Summary -Text $CurrentSource['Name'] -Time $Time -Level $LevelSummary -Domain $Domain -DomainController $DomainController -TestsSummary $TestsSummary
            }
        }
        if ($Execute) {
            & $Execute
        }
    )
    $TestsSummaryFinal = [PSCustomObject] @{
        Passed  = ($TestsSummaryTogether.Passed | Measure-Object -Sum).Sum
        Failed  = ($TestsSummaryTogether.Failed | Measure-Object -Sum).Sum
        Skipped = ($TestsSummaryTogether.Skipped | Measure-Object -Sum).Sum
        Total   = ($TestsSummaryTogether.Total | Measure-Object -Sum).Sum
    }
    $TestsSummaryFinal

    if ($Domain -and $DomainController) {
        $Script:Reporting['Domains'][$Domain]['DomainControllers'][$DomainController]['Summary'] = $TestsSummaryFinal
    } elseif ($Domain) {
        $Script:Reporting['Domains'][$Domain]['Summary'] = $TestsSummaryFinal
    } else {
        $Script:Reporting['Summary'] = $TestsSummaryFinal
    }

    Out-Summary -Text $SummaryText -Time $GlobalTime -Level ($LevelSummary - 3) -Domain $Domain -DomainController $DomainController -TestsSummary $TestsSummaryFinal
}