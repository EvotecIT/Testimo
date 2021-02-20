function Start-TestimoReport {
    [CmdletBinding()]
    param(
        [System.Collections.IDictionary] $TestResults,
        [string] $FilePath,
        [switch] $Online,
        [switch] $ShowHTML,
        [switch] $HideSteps
    )
    if ($FilePath -eq '') {
        $FilePath = Get-FileName -Extension 'html' -Temporary
    }

    $ColorPassed = 'LawnGreen'
    $ColorSkipped = 'DeepSkyBlue'
    $ColorFailed = 'Tomato'
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
        New-TableCondition -Name 'Status' -Value $true -BackgroundColor 'LawnGreen'
        New-TableCondition -Name 'Status' -Value $false -BackgroundColor 'Tomato'
        New-TableCondition -Name 'Status' -Value $null -BackgroundColor 'DeepSkyBlue'
    }
    $TestResults['Configuration']['ResultConditionsEmail'] = {
        New-TableCondition -Name 'Status' -Value $true -BackgroundColor 'LawnGreen' -Inline
        New-TableCondition -Name 'Status' -Value $false -BackgroundColor 'Tomato' -Inline
        New-TableCondition -Name 'Status' -Value $null -BackgroundColor 'DeepSkyBlue' -Inline
    }
    [Array] $PassedTests = $TestResults['Results'] | Where-Object { $_.Status -eq $true }
    [Array] $FailedTests = $TestResults['Results'] | Where-Object { $_.Status -eq $false }
    [Array] $SkippedTests = $TestResults['Results'] | Where-Object { $_.Status -ne $true -and $_.Status -ne $false }

    New-HTML -FilePath $FilePath -Online:$Online {
        New-HTMLSectionStyle -BorderRadius 0px -HeaderBackGroundColor Grey -RemoveShadow
        New-HTMLTableOption -DataStore JavaScript -BoolAsString
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
        $NumberOfSourcesExecuted += $TestResults['Forest']['Tests'].Count
        foreach ($Domain in $TestResults['Domains'].Keys) {
            $NumberOfSourcesExecuted += $TestResults['Domains'][$Domain]['Tests'].Count
            $NumberOfSourcesExecuted += $TestResults['Domains'][$Domain]['DomainControllers'].Count
        }

        if ($NumberOfSourcesExecuted -gt 1) {
            New-HTMLTab -Name 'Summary' -IconBrands galactic-senate {
                New-HTMLSection -HeaderText "Tests results" -HeaderBackGroundColor DarkGray {
                    New-HTMLContainer {
                        New-HTMLChart {
                            New-ChartPie -Name 'Passed' -Value ($PassedTests.Count) -Color $ColorPassed
                            New-ChartPie -Name 'Failed' -Value ($FailedTests.Count) -Color $ColorFailed
                            New-ChartPie -Name 'Skipped' -Value ($SkippedTests.Count) -Color $ColorSkipped
                        }
                        New-HTMLTable -DataTable $TestResults['Summary'] -HideFooter -DisableSearch {
                            New-HTMLTableContent -ColumnName 'Passed' -BackGroundColor $TestResults['Configuration']['Colors']['ColorPassed'] -Color $TestResults['Configuration']['Colors']['ColorPassedText']
                            New-HTMLTableContent -ColumnName 'Failed' -BackGroundColor $TestResults['Configuration']['Colors']['ColorFailed'] -Color $TestResults['Configuration']['Colors']['ColorFailedText']
                            New-HTMLTableContent -ColumnName 'Skipped' -BackGroundColor $TestResults['Configuration']['Colors']['ColorSkipped'] -Color $TestResults['Configuration']['Colors']['ColorSkippedText']
                        } -DataStore HTML -Buttons @() -DisablePaging
                    } -Width '35%'
                    New-HTMLContainer {
                        New-HTMLText -Text @(
                            "Below you can find overall summary of all tests executed in this Testimo run."
                        ) -FontSize 10pt
                        New-HTMLTable -DataTable $TestResults['Results'] {
                            New-HTMLTableCondition -Name 'Status' -Value $true -BackgroundColor $TestResults['Configuration']['Colors']['ColorPassed'] -Color $TestResults['Configuration']['Colors']['ColorPassedText']  #-Row
                            New-HTMLTableCondition -Name 'Status' -Value $false -BackgroundColor $TestResults['Configuration']['Colors']['ColorFailed'] -Color $TestResults['Configuration']['Colors']['ColorFailedText']  #-Row
                            New-HTMLTableCondition -Name 'Status' -Value $null -BackgroundColor $TestResults['Configuration']['Colors']['ColorSkipped'] -Color $TestResults['Configuration']['Colors']['ColorSkippedText']  #-Row
                        } -Filtering
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
                    $Results = $TestResults['Forest']['Tests'][$Source]['Results'] | Select-Object -Property DisplayName, Type, Category, Status, Importance, Action, Extended
                    $WarningsAndErrors = $TestResults['Forest']['Tests'][$Source]['WarningsAndErrors']
                    Start-TestimoReportSection -Name $Name -Data $Data -Information $Information -SourceCode $SourceCode -Results $Results -WarningsAndErrors $WarningsAndErrors -TestResults $TestResults
                }
            } else {
                New-HTMLTab -Name 'Forest' -IconBrands first-order {
                    foreach ($Source in $TestResults['Forest']['Tests'].Keys) {
                        $Name = $TestResults['Forest']['Tests'][$Source]['Name']
                        $Data = $TestResults['Forest']['Tests'][$Source]['Data']
                        $Information = $TestResults['Forest']['Tests'][$Source]['Information']
                        $SourceCode = $TestResults['Forest']['Tests'][$Source]['SourceCode']
                        $Results = $TestResults['Forest']['Tests'][$Source]['Results'] | Select-Object -Property DisplayName, Type, Category, Status, Importance, Action, Extended
                        $WarningsAndErrors = $TestResults['Forest']['Tests'][$Source]['WarningsAndErrors']
                        Start-TestimoReportSection -Name $Name -Data $Data -Information $Information -SourceCode $SourceCode -Results $Results -WarningsAndErrors $WarningsAndErrors -TestResults $TestResults
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
                                $Results = $TestResults['Domains'][$Domain]['Tests'][$Source]['Results'] | Select-Object -Property DisplayName, Type, Category, Status, Importance, Action, Extended, Domain
                                $WarningsAndErrors = $TestResults['Domains'][$Domain]['Tests'][$Source]['WarningsAndErrors']
                                Start-TestimoReportSection -Name $Name -Data $Data -Information $Information -SourceCode $SourceCode -Results $Results -WarningsAndErrors $WarningsAndErrors -HideSteps:$HideSteps -TestResults $TestResults
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
                                                    $Results = $TestResults['Domains'][$Domain]['DomainControllers'][$DC]['Tests'][$Source]['Results'] | Select-Object -Property DisplayName, Type, Category, Status, Importance, Action, Extended, Domain, DomainController
                                                    $WarningsAndErrors = $TestResults['Domains'][$Domain]['DomainControllers'][$DC]['Tests'][$Source]['WarningsAndErrors']

                                                    Start-TestimoReportSection -Name $Name -Data $Data -Information $Information -SourceCode $SourceCode -Results $Results -WarningsAndErrors $WarningsAndErrors -TestResults $TestResults
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