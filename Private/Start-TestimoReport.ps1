function Start-TestimoReport {
    [CmdletBinding()]
    param(
        [System.Collections.IDictionary] $TestResults,
        [string] $FilePath,
        [switch] $Online,
        [switch] $ShowHTML,
        [switch] $HideSteps,
        [switch] $AlwaysShowSteps,
        [string[]] $Scopes
    )
    if ($FilePath -eq '') {
        $FilePath = Get-FileName -Extension 'html' -Temporary
    }

    $ColorPassed = 'LawnGreen'
    $ColorSkipped = 'DeepSkyBlue'
    $ColorFailed = 'TorchRed'
    $ColorPassedText = 'Black'
    $ColorFailedText = 'Black'
    $ColorSkippedText = 'Black'

    $TestResults['Configuration'] = @{
        Colors = @{
            ColorPassed      = $ColorPassed
            ColorSkipped     = $ColorSkipped
            ColorFailed      = $ColorFailed
            ColorPassedText  = $ColorPassedText
            ColorFailedText  = $ColorFailedText
            ColorSkippedText = $ColorSkippedText
        }
    }
    $TestResults['Configuration']['ResultConditions'] = {
        #New-TableCondition -Name 'Status' -Value $true -BackgroundColor 'LawnGreen'
        # #New-TableCondition -Name 'Status' -Value $false -BackgroundColor 'Tomato'
        # New-TableCondition -Name 'Status' -Value $null -BackgroundColor 'DeepSkyBlue'
        foreach ($Status in $Script:StatusTranslation.Keys) {
            New-HTMLTableCondition -Name 'Assessment' -Value $Script:StatusTranslation[$Status] -BackgroundColor $Script:StatusTranslationColors[$Status] #-Row
        }
        New-HTMLTableCondition -Name 'Assessment' -Value $true -BackgroundColor $TestResults['Configuration']['Colors']['ColorPassed'] -Color $TestResults['Configuration']['Colors']['ColorPassedText'] #-Row
        New-HTMLTableCondition -Name 'Assessment' -Value $false -BackgroundColor $TestResults['Configuration']['Colors']['ColorFailed'] -Color $TestResults['Configuration']['Colors']['ColorFailedText'] #-Row
    }
    $TestResults['Configuration']['ResultConditionsEmail'] = {
        $Translations = @{
            -1 = 'Skipped'
            0  = 'Informational' # #4D9F6F # Low risk
            1  = 'Good'
            2  = 'Low' # #507DC6 # General Risk
            3  = 'Elevated' # #998D16 # Significant Risk
            4  = 'High' # #7A5928 High Risk
            5  = 'Severe' # #D65742 Server Risk
        }
        $TranslationsColors = @{
            -1 = 'DeepSkyBlue'
            0  = 'ElectricBlue'
            1  = 'LawnGreen'
            2  = 'ParisDaisy' #  # General Risk
            3  = 'SafetyOrange' #  # Significant Risk
            4  = 'InternationalOrange' #  High Risk
            5  = 'TorchRed' #  Server Risk
        }
        foreach ($Status in $Translations.Keys) {
            New-HTMLTableCondition -Name 'Assessment' -Value $Translations[$Status] -BackgroundColor $TranslationsColors[$Status] -Inline
        }
        New-HTMLTableCondition -Name 'Assessment' -Value $true -BackgroundColor 'LawnGreen' -Inline
        New-HTMLTableCondition -Name 'Assessment' -Value $false -BackgroundColor 'TorchRed' -Inline
    }
    # [Array] $PassedTests = $TestResults['Results'] | Where-Object { $_.Status -eq $true }
    # [Array] $FailedTests = $TestResults['Results'] | Where-Object { $_.Status -eq $false }
    # [Array] $SkippedTests = $TestResults['Results'] | Where-Object { $_.Status -ne $true -and $_.Status -ne $false }

    New-HTML -FilePath $FilePath -Online:$Online {
        New-HTMLSectionStyle -BorderRadius 0px -HeaderBackGroundColor Grey -RemoveShadow
        New-HTMLTableOption -DataStore JavaScript -BoolAsString -ArrayJoin -ArrayJoinString ', ' -DateTimeFormat 'dd.MM.yyyy HH:mm:ss'
        New-HTMLTabStyle -BorderRadius 0px -BackgroundColorActive SlateGrey

        New-HTMLHeader {
            New-HTMLSection -Invisible {
                New-HTMLSection {
                    New-HTMLText -Text "Report generated on $(Get-Date)" -Color Blue
                } -JustifyContent flex-start -Invisible
                New-HTMLSection {
                    New-HTMLText -Text $Script:Reporting['Version'] -Color Blue
                } -JustifyContent flex-end -Invisible
            }
        }

        # Find amount of sources used. If just one, skip summary
        $NumberOfSourcesExecuted = 0
        #$NumberOfSourcesExecuted += $TestResults['Forest']['Tests'].Count
        foreach ($Key in $TestResults.Keys) {
            if ($Key -notin 'Version', 'Errors', 'Results', 'Summary', 'Domains', 'BySource', 'Configuration') {
                $NumberOfSourcesExecuted += $TestResults[$Key]['Tests'].Count
            }
        }
        foreach ($Domain in $TestResults['Domains'].Keys) {
            $NumberOfSourcesExecuted += $TestResults['Domains'][$Domain]['Tests'].Count
            $NumberOfSourcesExecuted += $TestResults['Domains'][$Domain]['DomainControllers'].Count
        }

        $ChartData = New-ChartData -Results $TestResults['Results']
        $TableData = [ordered] @{}
        foreach ($Chart in $ChartData.Keys) {
            $TableData[$Chart] = $ChartData[$Chart].Count
        }
        $TableData['Total'] = $TestResults['Summary'].Total
        $DisplayTableData = [PSCustomObject] $TableData

        if ($NumberOfSourcesExecuted -gt 1) {
            New-HTMLTab -Name 'Summary' -IconBrands galactic-senate {
                New-HTMLSection -HeaderText "Tests results" -HeaderBackGroundColor DarkGray {
                    New-HTMLContainer {
                        New-HTMLChart {
                            #New-ChartPie -Name 'Passed' -Value ($PassedTests.Count) -Color $ColorPassed
                            #New-ChartPie -Name 'Failed' -Value ($FailedTests.Count) -Color $ColorFailed
                            #New-ChartPie -Name 'Skipped' -Value ($SkippedTests.Count) -Color $ColorSkipped
                            foreach ($Key in $ChartData.Keys) {
                                New-ChartPie -Name $Key -Value $ChartData[$Key].Count -Color $ChartData[$Key].Color
                            }
                        }
                        New-HTMLTable -DataTable $DisplayTableData -HideFooter -DisableSearch {
                            foreach ($Chart in $ChartData.Keys) {
                                New-HTMLTableContent -ColumnName $Chart -BackGroundColor $ChartData[$Chart].Color -Color Black
                            }
                            #New-HTMLTableContent -ColumnName 'Passed' -BackGroundColor $TestResults['Configuration']['Colors']['ColorPassed'] -Color $TestResults['Configuration']['Colors']['ColorPassedText']
                            #New-HTMLTableContent -ColumnName 'Failed' -BackGroundColor $TestResults['Configuration']['Colors']['ColorFailed'] -Color $TestResults['Configuration']['Colors']['ColorFailedText']
                            #New-HTMLTableContent -ColumnName 'Skipped' -BackGroundColor $TestResults['Configuration']['Colors']['ColorSkipped'] -Color $TestResults['Configuration']['Colors']['ColorSkippedText']
                        } -DataStore HTML -Buttons @() -DisablePaging -DisableInfo -DisableOrdering
                    } -Width '35%'
                    New-HTMLContainer {
                        New-HTMLText -Text @(
                            "Below you can find overall summary of all tests executed in this Testimo run."
                        ) -FontSize 10pt

                        $ResultsDisplay = $TestResults['Results'] | Select-Object -Property DisplayName, Type, Category, Assessment, Importance, Action, Extended, Domain, DomainController
                        New-HTMLTable -DataTable $ResultsDisplay {
                            #New-HTMLTableCondition -Name 'Status' -Value $true -BackgroundColor $TestResults['Configuration']['Colors']['ColorPassed'] -Color $TestResults['Configuration']['Colors']['ColorPassedText']  #-Row
                            #New-HTMLTableCondition -Name 'Status' -Value $false -BackgroundColor $TestResults['Configuration']['Colors']['ColorFailed'] -Color $TestResults['Configuration']['Colors']['ColorFailedText']  #-Row
                            #New-HTMLTableCondition -Name 'Status' -Value $null -BackgroundColor $TestResults['Configuration']['Colors']['ColorSkipped'] -Color $TestResults['Configuration']['Colors']['ColorSkippedText']  #-Row
                            foreach ($Status in $Script:StatusTranslation.Keys) {
                                New-HTMLTableCondition -Name 'Assessment' -Value $Script:StatusTranslation[$Status] -BackgroundColor $Script:StatusTranslationColors[$Status] -Row
                            }
                            New-HTMLTableCondition -Name 'Assessment' -Value $true -BackgroundColor $TestResults['Configuration']['Colors']['ColorPassed'] -Color $TestResults['Configuration']['Colors']['ColorPassedText'] -Row
                            New-HTMLTableCondition -Name 'Assessment' -Value $false -BackgroundColor $TestResults['Configuration']['Colors']['ColorFailed'] -Color $TestResults['Configuration']['Colors']['ColorFailedText'] -Row
                        } -Filtering
                    }
                }
            }
        }
        foreach ($Scope in $Scopes) {
            if ($TestResults[$Scope]['Tests'].Count -gt 0) {
                # There's at least 1 forest test - so lets go
                if ($NumberOfSourcesExecuted -eq 1) {
                    # there's just one forest test, and only 1 forest test in total so we don't need tabs
                    foreach ($Source in $TestResults[$Scope]['Tests'].Keys) {
                        $Name = $TestResults[$Scope]['Tests'][$Source]['Name']
                        $Data = $TestResults[$Scope]['Tests'][$Source]['Data']
                        $Information = $TestResults[$Scope]['Tests'][$Source]['Information']
                        $SourceCode = $TestResults[$Scope]['Tests'][$Source]['SourceCode']
                        $Results = $TestResults[$Scope]['Tests'][$Source]['Results'] #| Select-Object -Property DisplayName, Type, Category, Assessment, Importance, Action, Extended
                        $WarningsAndErrors = $TestResults[$Scope]['Tests'][$Source]['WarningsAndErrors']
                        Start-TestimoReportSection -Name $Name -Data $Data -Information $Information -SourceCode $SourceCode -Results $Results -WarningsAndErrors $WarningsAndErrors -TestResults $TestResults -Type $Scope -AlwaysShowSteps:$AlwaysShowSteps.IsPresent
                    }
                } else {
                    New-HTMLTab -Name $Scope -IconBrands first-order {
                        foreach ($Source in $TestResults[$Scope]['Tests'].Keys) {
                            $Name = $TestResults[$Scope]['Tests'][$Source]['Name']
                            $Data = $TestResults[$Scope]['Tests'][$Source]['Data']
                            $Information = $TestResults[$Scope]['Tests'][$Source]['Information']
                            $SourceCode = $TestResults[$Scope]['Tests'][$Source]['SourceCode']
                            $Results = $TestResults[$Scope]['Tests'][$Source]['Results'] #| Select-Object -Property DisplayName, Type, Category, Assessment, Importance, Action, Extended
                            $WarningsAndErrors = $TestResults[$Scope]['Tests'][$Source]['WarningsAndErrors']
                            Start-TestimoReportSection -Name $Name -Data $Data -Information $Information -SourceCode $SourceCode -Results $Results -WarningsAndErrors $WarningsAndErrors -TestResults $TestResults -Type $Scope -AlwaysShowSteps:$AlwaysShowSteps.IsPresent
                        }
                    }
                }
            }
        }
        if ($TestResults['Forest']['Tests'].Count -gt 0) {
            # There's at least 1 forest test - so lets go
            if ($NumberOfSourcesExecuted -eq 1) {
                # there's just one forest test, and only 1 forest test in total so we don't need tabs
                foreach ($Source in $TestResults['Forest']['Tests'].Keys) {
                    $Name = $TestResults['Forest']['Tests'][$Source]['Name']
                    $Data = $TestResults['Forest']['Tests'][$Source]['Data']
                    $Information = $TestResults['Forest']['Tests'][$Source]['Information']
                    $SourceCode = $TestResults['Forest']['Tests'][$Source]['SourceCode']
                    $Results = $TestResults['Forest']['Tests'][$Source]['Results'] #| Select-Object -Property DisplayName, Type, Category, Assessment, Importance, Action, Extended
                    $WarningsAndErrors = $TestResults['Forest']['Tests'][$Source]['WarningsAndErrors']
                    Start-TestimoReportSection -Name $Name -Data $Data -Information $Information -SourceCode $SourceCode -Results $Results -WarningsAndErrors $WarningsAndErrors -TestResults $TestResults -Type 'Forest' -AlwaysShowSteps:$AlwaysShowSteps.IsPresent
                }
            } else {
                New-HTMLTab -Name 'Forest' -IconBrands first-order {
                    foreach ($Source in $TestResults['Forest']['Tests'].Keys) {
                        $Name = $TestResults['Forest']['Tests'][$Source]['Name']
                        $Data = $TestResults['Forest']['Tests'][$Source]['Data']
                        $Information = $TestResults['Forest']['Tests'][$Source]['Information']
                        $SourceCode = $TestResults['Forest']['Tests'][$Source]['SourceCode']
                        $Results = $TestResults['Forest']['Tests'][$Source]['Results'] #| Select-Object -Property DisplayName, Type, Category, Assessment, Importance, Action, Extended
                        $WarningsAndErrors = $TestResults['Forest']['Tests'][$Source]['WarningsAndErrors']
                        Start-TestimoReportSection -Name $Name -Data $Data -Information $Information -SourceCode $SourceCode -Results $Results -WarningsAndErrors $WarningsAndErrors -TestResults $TestResults -Type 'Forest' -AlwaysShowSteps:$AlwaysShowSteps.IsPresent
                    }
                }
            }
        }
        $DomainsFound = @{}
        [Array] $ProcessDomains = foreach ($Domain in $TestResults['Domains'].Keys) {
            if ($TestResults['Domains'][$Domain]['Tests'].Count -gt 0) {
                $DomainsFound[$Domain] = $true
                $true
            }
        }
        if ($ProcessDomains -contains $true) {
            New-HTMLTab -Name 'Domains' -IconBrands wpbeginner {
                foreach ($Domain in $TestResults['Domains'].Keys) {
                    if ($TestResults['Domains'][$Domain]['Tests'].Count -gt 0 -or $TestResults['Domains'][$Domain]['DomainControllers'].Count -gt 0) {
                        New-HTMLTab -Name "Domain $Domain" -IconBrands deskpro {
                            foreach ($Source in $TestResults['Domains'][$Domain]['Tests'].Keys) {
                                $Information = $TestResults['Domains'][$Domain]['Tests'][$Source]['Information']
                                $Name = $TestResults['Domains'][$Domain]['Tests'][$Source]['Name']
                                $Data = $TestResults['Domains'][$Domain]['Tests'][$Source]['Data']
                                $SourceCode = $TestResults['Domains'][$Domain]['Tests'][$Source]['SourceCode']
                                $Results = $TestResults['Domains'][$Domain]['Tests'][$Source]['Results'] #| Select-Object -Property DisplayName, Type, Category, Assessment, Importance, Action, Extended, Domain
                                $WarningsAndErrors = $TestResults['Domains'][$Domain]['Tests'][$Source]['WarningsAndErrors']
                                Start-TestimoReportSection -Name $Name -Data $Data -Information $Information -SourceCode $SourceCode -Results $Results -WarningsAndErrors $WarningsAndErrors -HideSteps:$HideSteps -TestResults $TestResults -Type 'Domain' -AlwaysShowSteps:$AlwaysShowSteps.IsPresent
                            }
                        }
                    }
                }
            }
        }

        if ($TestResults['Domains'].Keys.Count -gt 0) {
            $DomainsFound = @{}
            [Array] $ProcessDomainControllers = foreach ($Domain in $TestResults['Domains'].Keys) {
                if ($TestResults['Domains'][$Domain]['DomainControllers'].Count -gt 0) {
                    $DomainsFound[$Domain] = $true
                    $true
                }
            }
            if ($ProcessDomainControllers -contains $true) {
                New-HTMLTab -Name 'Domain Controllers' -IconRegular snowflake {
                    foreach ($Domain in $TestResults['Domains'].Keys) {
                        if ($TestResults['Domains'][$Domain]['Tests'].Count -gt 0 -or $TestResults['Domains'][$Domain]['DomainControllers'].Count -gt 0) {
                            New-HTMLTab -Name "Domain $Domain" -IconBrands deskpro {
                                if ($TestResults['Domains'][$Domain]['DomainControllers'].Count -gt 0) {
                                    #New-HTMLTabPanel -Orientation vertical {
                                    foreach ($DC in $TestResults['Domains'][$Domain]['DomainControllers'].Keys) {
                                        New-HTMLTab -TabName $DC -TextColor DarkSlateGray {
                                            #-HeaderText "Domain Controller - $DC" -HeaderBackGroundColor DarkSlateGray {
                                            New-HTMLContainer {
                                                foreach ($Source in  $TestResults['Domains'][$Domain]['DomainControllers'][$DC]['Tests'].Keys) {
                                                    $Information = $TestResults['Domains'][$Domain]['DomainControllers'][$DC]['Tests'][$Source]['Information']
                                                    $Name = $TestResults['Domains'][$Domain]['DomainControllers'][$DC]['Tests'][$Source]['Name']
                                                    $Data = $TestResults['Domains'][$Domain]['DomainControllers'][$DC]['Tests'][$Source]['Data']
                                                    $SourceCode = $TestResults['Domains'][$Domain]['DomainControllers'][$DC]['Tests'][$Source]['SourceCode']
                                                    $Results = $TestResults['Domains'][$Domain]['DomainControllers'][$DC]['Tests'][$Source]['Results'] #| Select-Object -Property DisplayName, Type, Category, Assessment, Importance, Action, Extended, Domain, DomainController
                                                    $WarningsAndErrors = $TestResults['Domains'][$Domain]['DomainControllers'][$DC]['Tests'][$Source]['WarningsAndErrors']

                                                    Start-TestimoReportSection -Name $Name -Data $Data -Information $Information -SourceCode $SourceCode -Results $Results -WarningsAndErrors $WarningsAndErrors -TestResults $TestResults -Type 'DC' -AlwaysShowSteps:$AlwaysShowSteps.IsPresent
                                                }
                                            }
                                        }
                                        #}
                                    }
                                }
                            }
                        }
                    }
                }
            }
        }
    } -ShowHTML:$ShowHTML
}