$DomainDomainControllers = @{
    Enable   = $true
    Scope    = 'Domain'
    Source   = @{
        Name           = "Domain Controller Owners"
        Data           = {
            Get-WinADForestControllerInformation -Forest $ForestName -Domain $Domain
        }
        Requirements   = @{

        }
        Details        = [ordered] @{
            Area        = 'Configuration'
            Category    = 'Security'
            Severity    = ''
            RiskLevel   = 0
            Description = ""
            Resolution  = ''
            Resources   = @(

            )
        }
        ExpectedOutput = $true
    }
    Tests    = [ordered] @{
        Enabled            = @{
            Enable     = $true
            Name       = 'DC should be enabled'
            Parameters = @{
                ExpectedCount = 0
                OperationType = 'eq'
                WhereObject   = { $_.Enabled -ne $true }
            }
        }
        OwnerType          = @{
            Enable     = $true
            Name       = 'OwnerType should be Administrative'
            Parameters = @{
                #ExpectedValue = 'Administrative'
                #Property      = 'OwnerType'
                #OperationType = 'eq'
                ExpectedCount = 0
                OperationType = 'eq'
                WhereObject   = { $_.OwnerType -ne 'Administrative' }
            }
        }
        ManagedBy          = @{
            Enable     = $true
            Name       = 'ManagedBy should be empty'
            Parameters = @{
                ExpectedCount = 0
                OperationType = 'eq'
                WhereObject   = { $null -ne $_.ManagedBy }
            }
        }
        PasswordLastChange = @{
            Enable     = $true
            Name       = 'Password Change Less Than X days'
            Parameters = @{
                ExpectedCount = 0
                OperationType = 'eq'
                WhereObject   = { $_.PasswordLastChangedDays -ge 60 }
            }
        }
        LastLogonDays      = @{
            Enable     = $true
            Name       = 'Last Logon Less Than X days'
            Parameters = @{
                ExpectedCount = 0
                OperationType = 'eq'
                WhereObject   = { $_.LastLogonDays -ge 60 }
            }
        }
    }
    Solution = {
        New-HTMLSection -Name 'Steps to fix - Domain Controller Owners' {
            New-HTMLContainer {
                New-HTMLSpanStyle -FontSize 10pt {
                    New-HTMLText -Text 'Following steps will guide you how to fix permissions consistency'
                    New-HTMLWizard {
                        New-HTMLWizardStep -Name 'Prepare environment' {
                            New-HTMLText -Text "To be able to execute actions in automated way please install required modules. Those modules will be installed straight from Microsoft PowerShell Gallery."
                            New-HTMLCodeBlock -Code {
                                Install-Module GPOZaurr -Force
                                Import-Module GPOZaurr -Force
                            } -Style powershell
                            New-HTMLText -Text "Using force makes sure newest version is downloaded from PowerShellGallery regardless of what is currently installed. Once installed you're ready for next step."
                        }
                        New-HTMLWizardStep -Name 'Prepare report' {
                            New-HTMLText -Text "Depending when this report was run you may want to prepare new report before proceeding fixing permissions inconsistencies. To generate new report please use:"
                            New-HTMLCodeBlock -Code {
                                Invoke-GPOZaurr -FilePath $Env:UserProfile\Desktop\GPOZaurrPermissionsInconsistentBefore.html -Verbose -Type GPOConsistency
                            }
                            New-HTMLText -Text {
                                "When executed it will take a while to generate all data and provide you with new report depending on size of environment."
                                "Once confirmed that data is still showing issues and requires fixing please proceed with next step."
                            }
                            New-HTMLText -Text "Alternatively if you prefer working with console you can run: "
                            New-HTMLCodeBlock -Code {
                                $GPOOutput = Get-GPOZaurrPermissionConsistency
                                $GPOOutput | Format-Table # do your actions as desired
                            }
                            New-HTMLText -Text "It provides same data as you see in table above just doesn't prettify it for you."
                        }
                        New-HTMLWizardStep -Name 'Fix inconsistent permissions' {
                            New-HTMLText -Text "Following command when executed fixes inconsistent permissions."
                            New-HTMLText -Text "Make sure when running it for the first time to run it with ", "WhatIf", " parameter as shown below to prevent accidental removal." -FontWeight normal, bold, normal -Color Black, Red, Black
                            New-HTMLText -Text "Make sure to fill in TargetDomain to match your Domain Admin permission account"

                            New-HTMLCodeBlock -Code {
                                Repair-GPOZaurrPermissionConsistency -IncludeDomains "TargetDomain" -Verbose -WhatIf
                            }
                            New-HTMLText -TextBlock {
                                "After execution please make sure there are no errors, make sure to review provided output, and confirm that what is about to be deleted matches expected data. Once happy with results please follow with command: "
                            }
                            New-HTMLCodeBlock -Code {
                                Repair-GPOZaurrPermissionConsistency -LimitProcessing 2 -IncludeDomains "TargetDomain"
                            }
                            New-HTMLText -TextBlock {
                                "This command when executed repairs only first X inconsistent permissions. Use LimitProcessing parameter to prevent mass fixing and increase the counter when no errors occur. "
                                "Repeat step above as much as needed increasing LimitProcessing count till there's nothing left. In case of any issues please review and action accordingly. "
                            }
                            New-HTMLText -Text "If there's nothing else to be fixed, we can skip to next step step"
                        }
                        New-HTMLWizardStep -Name 'Fix inconsistent downlevel permissions' {
                            New-HTMLText -Text @(
                                "Unfortunetly this step is manual until automation is developed. "
                                "If there are inconsistent permissions found inside GPO one has to fix them manually by going into SYSVOL and making sure inheritance is enabled, and that permissions are consistent across all files."
                                "Please keep in mind that it's possible inconsistent downlevel permissions fix will not be required once the top level fix is applied. "
                                "Rerun report to find out if you've just fixed top-level permissions. "
                            )
                        }
                        New-HTMLWizardStep -Name 'Verification report' {
                            New-HTMLText -TextBlock {
                                "Once cleanup task was executed properly, we need to verify that report now shows no problems."
                            }
                            New-HTMLCodeBlock -Code {
                                Invoke-GPOZaurr -FilePath $Env:UserProfile\Desktop\GPOZaurrPermissionsInconsistentAfter.html -Verbose -Type GPOConsistency
                            }
                            New-HTMLText -Text "If everything is healthy in the report you're done! Enjoy rest of the day!" -Color BlueDiamond
                        }
                    } -RemoveDoneStepOnNavigateBack -Theme arrows -ToolbarButtonPosition center -EnableAllAnchors
                }
            }
        }
    }
}

