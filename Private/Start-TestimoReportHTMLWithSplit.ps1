function Start-TestimoReportHTMLWithSplit {
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

    $DateName = $(Get-Date -f yyyy-MM-dd_HHmmss)
    $FileName = [io.path]::GetFileNameWithoutExtension($FilePath)
    $DirectoryName = [io.path]::GetDirectoryName($FilePath)

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

    foreach ($Scope in $Scopes) {
        if ($TestResults[$Scope]['Tests'].Count -gt 0) {
            foreach ($Source in $TestResults[$Scope]['Tests'].Keys) {
                $Time = Start-TimeLog
                $NewFileName = $FileName + '_' + $Source + "_" + $DateName + '.html'
                $FilePath = [io.path]::Combine($DirectoryName, $NewFileName)
                Out-Informative -OverrideTitle 'Testimo' -Text "HTML Report for $Source Generation Started" -Level 0 -Status $null #-ExtendedValue $Script:Reporting['Version']
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
                } -ShowHTML:$ShowHTML.IsPresent
                $TimeEnd = Stop-TimeLog -Time $Time
                Out-Informative -OverrideTitle 'Testimo' -Text "HTML Report for $Source Saved to $FilePath" -Level 0 -Status $null -ExtendedValue $TimeEnd
            }
        }
    }
    if ($TestResults['Forest']['Tests'].Count -gt 0) {
        # there's just one forest test, and only 1 forest test in total so we don't need tabs
        foreach ($Source in $TestResults['Forest']['Tests'].Keys) {
            $Time = Start-TimeLog
            $NewFileName = $FileName + '_' + $Source + "_" + $DateName + '.html'
            $FilePath = [io.path]::Combine($DirectoryName, $NewFileName)
            Out-Informative -OverrideTitle 'Testimo' -Text "HTML Report for $Source Generation Started" -Level 0 -Status $null #-ExtendedValue $Script:Reporting['Version']
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
            } -ShowHTML:$ShowHTML.IsPresent
            $TimeEnd = Stop-TimeLog -Time $Time
            Out-Informative -OverrideTitle 'Testimo' -Text "HTML Report for $Source Saved to $FilePath" -Level 0 -Status $null -ExtendedValue $TimeEnd
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
        # Establish the sources we have for Domains
        $DomainSources = foreach ($Domain in $TestResults['Domains'].Keys) {
            foreach ($Source in $TestResults['Domains'][$Domain]['Tests'].Keys) {
                $Source
            }
        }
        foreach ($Source in $DomainSources | Sort-Object -Unique) {
            $Time = Start-TimeLog
            $NewFileName = $FileName + '_' + $Source + "_" + $DateName + '.html'
            $FilePath = [io.path]::Combine($DirectoryName, $NewFileName)
            Out-Informative -OverrideTitle 'Testimo' -Text "HTML Report for $Source Generation Started" -Level 0 -Status $null #-ExtendedValue $Script:Reporting['Version']
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

                foreach ($Domain in $TestResults['Domains'].Keys) {
                    if ($TestResults['Domains'][$Domain]['Tests'].Count -gt 0 -or $TestResults['Domains'][$Domain]['DomainControllers'].Count -gt 0) {

                        $Information = $TestResults['Domains'][$Domain]['Tests'][$Source]['Information']
                        $Name = $TestResults['Domains'][$Domain]['Tests'][$Source]['Name']
                        $Data = $TestResults['Domains'][$Domain]['Tests'][$Source]['Data']
                        $SourceCode = $TestResults['Domains'][$Domain]['Tests'][$Source]['SourceCode']
                        $Results = $TestResults['Domains'][$Domain]['Tests'][$Source]['Results'] #| Select-Object -Property DisplayName, Type, Category, Assessment, Importance, Action, Extended, Domain
                        $WarningsAndErrors = $TestResults['Domains'][$Domain]['Tests'][$Source]['WarningsAndErrors']

                        if ($Results.Status -notcontains $False) {
                            $Title = "$Domain 💚"
                        } else {
                            $Title = "$Domain 📛"
                        }

                        New-HTMLTab -Name "Domain $Title" -IconBrands deskpro {
                            try {
                                Start-TestimoReportSection -Name $Name -Data $Data -Information $Information -SourceCode $SourceCode -Results $Results -WarningsAndErrors $WarningsAndErrors -HideSteps:$HideSteps -TestResults $TestResults -Type 'Domain' -AlwaysShowSteps:$AlwaysShowSteps.IsPresent
                            } catch {
                                Write-Warning -Message "Failed to generate report (5) for $Source in domain $Domain"
                            }

                        }
                    }
                }
                # }
            } -ShowHTML:$ShowHTML.IsPresent
            $TimeEnd = Stop-TimeLog -Time $Time
            Out-Informative -OverrideTitle 'Testimo' -Text "HTML Report for $Source Saved to $FilePath" -Level 0 -Status $null -ExtendedValue $TimeEnd
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
            # Establish the sources we have for Domain Controllers
            $DCSources = foreach ($Domain in $TestResults['Domains'].Keys) {
                foreach ($DC in $TestResults['Domains'][$Domain]['DomainControllers'].Keys) {
                    foreach ($Source in $TestResults['Domains'][$Domain]['DomainControllers'][$DC]['Tests'].Keys) {
                        $Source
                    }
                }
            }
            foreach ($Source in $DCSources | Sort-Object -Unique) {
                $Time = Start-TimeLog
                $NewFileName = $FileName + '_' + $Source + "_" + $DateName + '.html'
                $FilePath = [io.path]::Combine($DirectoryName, $NewFileName)
                Out-Informative -OverrideTitle 'Testimo' -Text "HTML Report for $Source Generation Started" -Level 0 -Status $null #-ExtendedValue $Script:Reporting['Version']
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

                    foreach ($Domain in $TestResults['Domains'].Keys) {
                        if ($TestResults['Domains'][$Domain]['Tests'].Count -gt 0 -or $TestResults['Domains'][$Domain]['DomainControllers'].Count -gt 0) {
                            if ($TestResults['Domains'][$Domain]['DomainControllers'].Count -gt 0) {
                                foreach ($DC in $TestResults['Domains'][$Domain]['DomainControllers'].Keys) {
                                    $Information = $TestResults['Domains'][$Domain]['DomainControllers'][$DC]['Tests'][$Source]['Information']
                                    $Name = $TestResults['Domains'][$Domain]['DomainControllers'][$DC]['Tests'][$Source]['Name']
                                    $Data = $TestResults['Domains'][$Domain]['DomainControllers'][$DC]['Tests'][$Source]['Data']
                                    $SourceCode = $TestResults['Domains'][$Domain]['DomainControllers'][$DC]['Tests'][$Source]['SourceCode']
                                    $Results = $TestResults['Domains'][$Domain]['DomainControllers'][$DC]['Tests'][$Source]['Results'] #| Select-Object -Property DisplayName, Type, Category, Assessment, Importance, Action, Extended, Domain, DomainController
                                    $WarningsAndErrors = $TestResults['Domains'][$Domain]['DomainControllers'][$DC]['Tests'][$Source]['WarningsAndErrors']

                                    if ($Results.Status -notcontains $False) {
                                        $Title = "$DC 💚"
                                    } else {
                                        $Title = "$DC 📛"
                                    }

                                    New-HTMLTab -TabName $Title -TextColor DarkSlateGray {
                                        New-HTMLContainer {
                                            try {
                                                Start-TestimoReportSection -Name $Name -Data $Data -Information $Information -SourceCode $SourceCode -Results $Results -WarningsAndErrors $WarningsAndErrors -TestResults $TestResults -Type 'DC' -AlwaysShowSteps:$AlwaysShowSteps.IsPresent
                                            } catch {
                                                Write-Warning -Message "Failed to generate report (6) for $Source in $Domain for $DC"
                                            }

                                        }
                                    }

                                }
                            }

                        }
                    }

                } -ShowHTML:$ShowHTML.IsPresent
                $TimeEnd = Stop-TimeLog -Time $Time
                Out-Informative -OverrideTitle 'Testimo' -Text "HTML Report for $Source Saved to $FilePath" -Level 0 -Status $null -ExtendedValue $TimeEnd
            }
        }
    }
}