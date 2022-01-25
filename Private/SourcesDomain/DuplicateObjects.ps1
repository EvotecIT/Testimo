$DuplicateObjects = @{
    Name           = 'DomainDuplicateObjects'
    Enable         = $true
    Scope          = 'Domain'
    Source         = @{
        Name           = "Duplicate Objects: 0ACNF (Duplicate RDN)"
        <# Alternative: dsquery * forestroot -gc -attr distinguishedName -scope subtree -filter "(|(cn=*\0ACNF:*)(ou=*OACNF:*))" #>
        Data           = {
            Get-WinADDuplicateObject -IncludeDomains $Domain
        }
        Details        = [ordered] @{
            Category    = 'Cleanup'
            Description = "When two objects are created with the same Relative Distinguished Name (RDN) in the same parent Organizational Unit or container, the conflict is recognized by the system when one of the new objects replicates to another domain controller. When this happens, one of the objects is renamed. Some sources say the RDN is mangled to make it unique. The new RDN will be <Old RDN>\0ACNF:<objectGUID>"
            Importance  = 5
            ActionType  = 2
            Resources   = @(
                'https://social.technet.microsoft.com/wiki/contents/articles/15435.active-directory-duplicate-object-name-resolution.aspx'
                'https://ourwinblog.blogspot.com/2011/05/resolving-computer-object-replication.html'
                'https://kickthatcomputer.wordpress.com/2014/11/22/seek-and-destroy-duplicate-ad-objects-with-cnf-in-the-name/'
                'https://jorgequestforknowledge.wordpress.com/2014/09/17/finding-conflicting-objects-in-your-ad/'
                'https://social.technet.microsoft.com/Forums/en-US/e9327be6-922c-4b9f-8357-417c3ab6a1af/cnf-remove-from-ad?forum=winserverDS'
                'https://kickthatcomputer.wordpress.com/2014/11/22/seek-and-destroy-duplicate-ad-objects-with-cnf-in-the-name/'
                'https://community.spiceworks.com/topic/2113346-active-directory-replication-cnf-guid-entries'
            )
            StatusTrue  = 1
            StatusFalse = 2
        }
        ExpectedOutput = $false
    }
    DataHighlights = {

    }
    Solution       = {
        New-HTMLContainer {
            New-HTMLSpanStyle -FontSize 10pt {
                New-HTMLWizard {
                    New-HTMLWizardStep -Name 'Prepare environment' {
                        New-HTMLText -Text "To be able to execute actions in automated way please install required modules. Those modules will be installed straight from Microsoft PowerShell Gallery."
                        New-HTMLCodeBlock -Code {
                            Install-Module ADEssentials -Force
                            Import-Module ADEssentials -Force
                        } -Style powershell
                        New-HTMLText -Text "Using force makes sure newest version is downloaded from PowerShellGallery regardless of what is currently installed. Once installed you're ready for next step."
                    }
                    New-HTMLWizardStep -Name 'Prepare report' {
                        New-HTMLText -Text "Depending when this report was run you may want to prepare new report before proceeding fixing permissions inconsistencies. To generate new report please use:"
                        New-HTMLCodeBlock -Code {
                            Invoke-Testimo -FilePath $Env:UserProfile\Desktop\TestimoBefore.DomainDuplicateObjects.html -Type DomainDuplicateObjects
                        }
                        New-HTMLText -Text @(
                            "When executed it will take a while to generate all data and provide you with new report depending on size of environment."
                            "Once confirmed that data is still showing issues and requires fixing please proceed with next step."
                        )
                        New-HTMLText -Text "Alternatively if you prefer working with console you can run: "
                        New-HTMLCodeBlock -Code {
                            $Output = Get-WinADDuplicateObject -IncludeDomains 'TargetDomain'
                            $Output | Format-Table # do your actions as desired
                        }
                        New-HTMLText -Text "It provides same data as you see in table above just doesn't prettify it for you."
                    }
                    New-HTMLWizardStep -Name 'Remove Domain Duplicate Objects' {
                        New-HTMLText -Text @(
                            "CNF objects, Conflict objects or Duplicate Objects are created in Active Directory when there is simultaneous creation of an AD object under the same container "
                            "on two separate Domain Controllers near about the same time or before the replication occurs. "
                            "This results in a conflict and the same is exhibited by a CNF (Duplicate) object. "
                            "While it doesn't nessecary has a huge impact on Active Directory it's important to keep Active Directory in proper, healthy state. "
                        ) -FontWeight normal, normal, normal, normal, normal, normal, normal, bold, normal -Color Black, Black, Black, Black, Black, Black, Black, Red, Black
                        New-HTMLText -Text "Make sure to fill in TargetDomain to match your Domain Admin permission account"

                        New-HTMLCodeBlock -Code {
                            Remove-WinADDuplicateObject -Verbose -LimitProcessing 1 -IncludeDomains "TargetDomain" -WhatIf
                        }
                        New-HTMLText -TextBlock {
                            "After execution please make sure there are no errors, make sure to review provided output, and confirm that what is about to be fixed matches expected data. Once happy with results please follow with command: "
                        }
                        New-HTMLCodeBlock -Code {
                            Remove-WinADDuplicateObject -Verbose -LimitProcessing 1 -IncludeDomains "TargetDomain"
                        }
                        New-HTMLText -TextBlock {
                            "This command when executed removes only first X duplicate/CNF objects. Use LimitProcessing parameter to prevent mass remove and increase the counter when no errors occur. "
                            "Repeat step above as much as needed increasing LimitProcessing count till there's nothing left. In case of any issues please review and action accordingly. "
                        }
                    }
                    New-HTMLWizardStep -Name 'Verification report' {
                        New-HTMLText -TextBlock {
                            "Once cleanup task was executed properly, we need to verify that report now shows no problems."
                        }
                        New-HTMLCodeBlock -Code {
                            Invoke-Testimo -FilePath $Env:UserProfile\Desktop\TestimoAfter.DomainDuplicateObjects.html -Type DomainDuplicateObjects
                        }
                        New-HTMLText -Text "If everything is healthy in the report you're done! Enjoy rest of the day!" -Color BlueDiamond
                    }
                } -RemoveDoneStepOnNavigateBack -Theme arrows -ToolbarButtonPosition center -EnableAllAnchors
            }
        }
    }
}