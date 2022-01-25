$OrphanedForeignSecurityPrincipals = @{
    Name     = 'DomainOrphanedForeignSecurityPrincipals'
    Enable   = $true
    Scope    = 'Domain'
    Source   = @{
        Name           = "Orphaned Foreign Security Principals"
        Data           = {
            $AllFSP = Get-WinADUsersForeignSecurityPrincipalList -Domain $Domain
            $OrphanedObjects = $AllFSP | Where-Object { $_.TranslatedName -eq $null }
            $OrphanedObjects
        }
        Details        = [ordered] @{
            Category    = 'Cleanup'
            Importance  = 0
            ActionType  = 0
            Description = 'An FSP is an Active Directory (AD) security principal that points to a security principal (a user, computer, or group) from a domain of another forest. AD automatically and transparently creates them in a domain the first time after adding a security principal from another forest to a group from that domain. AD creates FSPs in a domain the first time after adding a security principal of a domain from another forest to a group. And when someone removes the security principal the FSP is pointing to, the FSP becomes an orphan because it points to a non-existent security principal.'
            Resolution  = ''
            Resources   = @(
                '[Clean up orphaned Foreign Security Principals](https://4sysops.com/archives/clean-up-orphaned-foreign-security-principals/)'
                '[Foreign Security Principals and Well-Known SIDS, a.k.a. the curly red arrow problem](https://docs.microsoft.com/en-us/archive/blogs/389thoughts/foreign-security-principals-and-well-known-sids-a-k-a-the-curly-red-arrow-problem)'
                '[Active Directory: Foreign Security Principals and Special Identities](https://social.technet.microsoft.com/wiki/contents/articles/51367.active-directory-foreign-security-principals-and-special-identities.aspx)'
                '[Find orphaned foreign security principals and remove them from groups](https://serverfault.com/questions/320840/find-orphaned-foreign-security-principals-and-remove-them-from-groups)'
            )
            StatusTrue  = 1
            StatusFalse = 3
        }
        ExpectedOutput = $false
    }
    Solution = {
        New-HTMLContainer {
            New-HTMLSpanStyle -FontSize 10pt {
                #New-HTMLText -Text 'Following steps will guide you how to fix permissions consistency'
                New-HTMLWizard {
                    <#
                    New-HTMLWizardStep -Name 'Prepare environment' {
                        New-HTMLText -Text "To be able to execute actions in automated way please install required modules. Those modules will be installed straight from Microsoft PowerShell Gallery."
                        New-HTMLCodeBlock -Code {
                            Install-Module ADEssentials -Force
                            Import-Module ADEssentials -Force
                        } -Style powershell
                        New-HTMLText -Text "Using force makes sure newest version is downloaded from PowerShellGallery regardless of what is currently installed. Once installed you're ready for next step."
                    }
                    #>
                    New-HTMLWizardStep -Name 'Prepare report' {
                        New-HTMLText -Text "Depending when this report was run you may want to prepare new report before proceeding fixing permissions inconsistencies. To generate new report please use:"
                        New-HTMLCodeBlock -Code {
                            Invoke-Testimo -FilePath $Env:UserProfile\Desktop\TestimoBefore.DomainOrphanedForeignSecurityPrincipals.html -Type DomainOrphanedForeignSecurityPrincipals
                        }
                        New-HTMLText -Text @(
                            "When executed it will take a while to generate all data and provide you with new report depending on size of environment."
                            "Once confirmed that data is still showing issues and requires fixing please proceed with next step."
                        )
                        New-HTMLText -Text "Alternatively if you prefer working with console you can run: "
                        New-HTMLCodeBlock -Code {
                            $Output = Get-WinADUsersForeignSecurityPrincipalList -IncludeDomains 'TargetDomain'
                            $Output | Where-Object { $_.TranslatedName -eq $null } | Format-Table
                        }
                        New-HTMLText -Text "It provides same data as you see in table above just doesn't prettify it for you."
                    }
                    New-HTMLWizardStep -Name 'Verify Trusts' {
                        New-HTMLText -Text @(
                            "It's important before deleting any FSP that all trusts are working correctly. "
                            "If trusts are down, translation FSP objects doesn't happen and therefore it would look like that FSP or orphaned. "
                            "Please run following command "
                        )
                        New-HTMLCodeBlock -Code {
                            Show-WinADTrust -Online -Recursive -Verbose
                        }
                        New-HTMLText -Text @(
                            "Zero level trusts are required to be functional and responding. "
                            "First level and above are optional, but should be verified if that's expected before removing FSP objects. "
                        )
                    }
                    New-HTMLWizardStep -Name 'Remove Orphaned FSP Objects (manual)' {
                        New-HTMLText -Text @(
                            "You can find all FSPs in the Active Directory Users and Computers (ADUC) console in a container named ForeignSecurityPrincipals. "
                            "However, you must first enable Advanced Features in the console. Otherwise the container won't show anything."
                            "You can recognize orphan FSPs by empty readable names in the ADUC console. "
                            ""
                            "However, there is a potential issue you need to be aware of. If, at the same time you are looking for orphaned FSPs, "
                            "there is a network connectivity issue between domain controllers and domain controllers from other trusted forests, "
                            "you won't be able to see the readable names. Thus the script and you will incorrectly deduce that they are orphans."
                            "When cleaning up, please consult other Domain Admins and confirm the trusts with other domains are working as required before proceeding."
                        ) -FontWeight normal, normal, normal, normal, normal, normal, normal, bold, normal -Color Black, Black, Black, Black, Black, Black, Black, Red, Black
                    }
                    New-HTMLWizardStep -Name 'Restore FSP object' {
                        New-HTMLText -Text @(
                            "If you've deleted FSP object by accident it's possible to restore such object from Active Directory Recycle Bin."
                        )
                    }
                    New-HTMLWizardStep -Name 'Verification report' {
                        New-HTMLText -TextBlock {
                            "Once cleanup task was executed properly, we need to verify that report now shows no problems."
                        }
                        New-HTMLCodeBlock -Code {
                            Invoke-Testimo -FilePath $Env:UserProfile\Desktop\TestimoAfter.DomainOrphanedForeignSecurityPrincipals.html -Type DomainOrphanedForeignSecurityPrincipals
                        }
                        New-HTMLText -Text "If everything is healthy in the report you're done! Enjoy rest of the day!" -Color BlueDiamond
                    }
                } -RemoveDoneStepOnNavigateBack -Theme arrows -ToolbarButtonPosition center -EnableAllAnchors
            }
        }
    }
}