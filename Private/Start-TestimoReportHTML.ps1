function Start-TestimoReportHTML {
    <#
    .SYNOPSIS
    Generates an HTML report based on the provided test results.

    .DESCRIPTION
    This function generates an HTML report based on the test results provided. It allows customization of the report format and content.

    .PARAMETER TestResults
    Specifies the test results to be included in the report.

    .PARAMETER FilePath
    Specifies the file path where the HTML report will be saved.

    .PARAMETER Online
    Indicates whether the report should be viewable online.

    .PARAMETER ShowHTML
    Indicates whether to display the HTML content.

    .PARAMETER HideSteps
    Indicates whether to hide detailed steps in the report.

    .PARAMETER AlwaysShowSteps
    Indicates whether to always show detailed steps in the report.

    .PARAMETER Scopes
    Specifies the scopes to be included in the report.

    .EXAMPLE
    Start-TestimoReportHTML -TestResults $TestResults -FilePath "C:\Reports\TestReport.html" -Online -ShowHTML -Scopes "Forest", "Domains"
    Generates an HTML report based on the provided test results, saves it to "C:\Reports\TestReport.html", displays it online, and includes scopes "Forest" and "Domains".

    .NOTES
    File Name      : Start-TestimoReportHTML.ps1
    Prerequisite   : This function requires the New-HTML and Start-TimeLog functions.
    #>
    [cmdletBinding()]
    param(
        [System.Collections.IDictionary] $TestResults,
        [string] $FilePath,
        [switch] $Online,
        [switch] $ShowHTML,
        [switch] $HideSteps,
        [switch] $AlwaysShowSteps,
        [string[]] $Scopes

    )
    $Time = Start-TimeLog
    Out-Informative -OverrideTitle 'Testimo' -Text 'HTML Report Generation Started' -Level 0 -Status $null #-ExtendedValue $Script:Reporting['Version']

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

        if ($NumberOfSourcesExecuted -gt 1) {
            Start-TestimoReportSummaryAdvanced -TestResults $TestResults
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
                        try {
                            Start-TestimoReportSection -Name $Name -Data $Data -Information $Information -SourceCode $SourceCode -Results $Results -WarningsAndErrors $WarningsAndErrors -TestResults $TestResults -Type $Scope -AlwaysShowSteps:$AlwaysShowSteps.IsPresent
                        } catch {
                            Write-Warning -Message "Failed to generate report (1) for $Source in $Scope"
                        }
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
                            try {
                                Start-TestimoReportSection -Name $Name -Data $Data -Information $Information -SourceCode $SourceCode -Results $Results -WarningsAndErrors $WarningsAndErrors -TestResults $TestResults -Type $Scope -AlwaysShowSteps:$AlwaysShowSteps.IsPresent
                            } catch {
                                Write-Warning -Message "Failed to generate report (2) for $Source in $Scope"
                            }
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
                    try {
                        Start-TestimoReportSection -Name $Name -Data $Data -Information $Information -SourceCode $SourceCode -Results $Results -WarningsAndErrors $WarningsAndErrors -TestResults $TestResults -Type 'Forest' -AlwaysShowSteps:$AlwaysShowSteps.IsPresent
                    } catch {
                        Write-Warning -Message "Failed to generate report (3) for $Source in $Scope"
                    }
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
                        try {
                            Start-TestimoReportSection -Name $Name -Data $Data -Information $Information -SourceCode $SourceCode -Results $Results -WarningsAndErrors $WarningsAndErrors -TestResults $TestResults -Type 'Forest' -AlwaysShowSteps:$AlwaysShowSteps.IsPresent
                        } catch {
                            Write-Warning -Message "Failed to generate report (4) for $Source in $Scope"
                        }
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
                                try {
                                    Start-TestimoReportSection -Name $Name -Data $Data -Information $Information -SourceCode $SourceCode -Results $Results -WarningsAndErrors $WarningsAndErrors -HideSteps:$HideSteps -TestResults $TestResults -Type 'Domain' -AlwaysShowSteps:$AlwaysShowSteps.IsPresent
                                } catch {
                                    Write-Warning -Message "Failed to generate report (5) for $Source in domain $Domain"
                                }
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
                                                foreach ($Source in $TestResults['Domains'][$Domain]['DomainControllers'][$DC]['Tests'].Keys) {
                                                    $Information = $TestResults['Domains'][$Domain]['DomainControllers'][$DC]['Tests'][$Source]['Information']
                                                    $Name = $TestResults['Domains'][$Domain]['DomainControllers'][$DC]['Tests'][$Source]['Name']
                                                    $Data = $TestResults['Domains'][$Domain]['DomainControllers'][$DC]['Tests'][$Source]['Data']
                                                    $SourceCode = $TestResults['Domains'][$Domain]['DomainControllers'][$DC]['Tests'][$Source]['SourceCode']
                                                    $Results = $TestResults['Domains'][$Domain]['DomainControllers'][$DC]['Tests'][$Source]['Results'] #| Select-Object -Property DisplayName, Type, Category, Assessment, Importance, Action, Extended, Domain, DomainController
                                                    $WarningsAndErrors = $TestResults['Domains'][$Domain]['DomainControllers'][$DC]['Tests'][$Source]['WarningsAndErrors']
                                                    try {
                                                        Start-TestimoReportSection -Name $Name -Data $Data -Information $Information -SourceCode $SourceCode -Results $Results -WarningsAndErrors $WarningsAndErrors -TestResults $TestResults -Type 'DC' -AlwaysShowSteps:$AlwaysShowSteps.IsPresent
                                                    } catch {
                                                        Write-Warning -Message "Failed to generate report (6) for $Source in $Domain for $DC"
                                                    }
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
    $TimeEnd = Stop-TimeLog -Time $Time
    Out-Informative -OverrideTitle 'Testimo' -Text "HTML Report Saved to $FilePath" -Level 0 -Status $null -ExtendedValue $TimeEnd
}