$ForestConfigurationPartitionOwners = @{
    Enable         = $true
    Scope          = 'Forest'
    Source         = @{
        Name           = "Configuration Partitions: Owners"
        Data           = {
            Get-WinADACLConfiguration -Forest $ForestName -Owner -ObjectType site, subnet, siteLink
        }
        Details        = [ordered] @{
            Category    = 'Security'
            Severity    = ''
            Importance  = 5
            Description = "The configuration partition contains replication topology and other configuration data that must be replicated throughout the forest. Every domain controller in the forest has a replica of the same configuration partition. Just like schema partition, there is just one master configuration partition per forest and a second one on all DCs in a forest. It contains the forest-wide active directory topology including DCs, sites, services, subnets and sitelinks. It is replicated to all DCs in a forest. Owners of Active Directory Configuration Partition, and more specifically Sites, Subnets and Sitelinks should always be set to Administrative (Domain Admins / Enterprise Admins). Being an owner of a site, subnet or sitelink is potentially dangerous and can lead to domain compromise. In comparison to ForestConfigurationPartitionOwnersContainers this test focuses only on chosen object types and nothing else. If there are issues reported in this test you may consider running Testimo with ForestConfigurationPartitionOwnersContainers check to verify if everything is as required.
            "
            Resources   = @(
                '[Escalating privileges with ACLs in Active Directory](https://blog.fox-it.com/2018/04/26/escalating-privileges-with-acls-in-active-directory/)'
            )
        }
        ExpectedOutput = $true
    }
    Tests          = [ordered] @{
        SiteOwners     = @{
            Enable     = $true
            Name       = 'Site Owners should be Administrative'
            Parameters = @{
                ExpectedCount = 0
                OperationType = 'eq'
                WhereObject   = { $_.ObjectType -eq 'Site' -and $_.OwnerType -ne 'Administrative' }
            }
            Details    = [ordered] @{
                Category   = 'Security'
                Importance = 5
            }
        }
        SubnetOwners   = @{
            Enable     = $true
            Name       = 'Subnet Owners should be Administrative'
            Parameters = @{
                ExpectedCount = 0
                OperationType = 'eq'
                WhereObject   = { $_.ObjectType -eq 'Subnet' -and $_.OwnerType -ne 'Administrative' }
            }
            Details    = [ordered] @{
                Category   = 'Security'
                Importance = 5
            }
        }
        SiteLinkOwners = @{
            Enable     = $true
            Name       = 'SiteLink Owners should be Administrative'
            Parameters = @{
                ExpectedCount = 0
                OperationType = 'eq'
                WhereObject   = { $_.ObjectType -eq 'SiteLink' -and $_.OwnerType -ne 'Administrative' }
            }
            Details    = [ordered] @{
                Category   = 'Security'
                Importance = 5
            }
        }
    }
    DataHighlights = {
        New-HTMLTableCondition -Name 'OwnerType' -ComparisonType string -BackgroundColor Salmon -Value 'Administrative' -Operator ne -Row
        New-HTMLTableCondition -Name 'OwnerType' -ComparisonType string -BackgroundColor PaleGreen -Value 'Administrative' -Operator eq -Row
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
                        New-HTMLText -Text "Depending when this report was run you may want to prepare new report before proceeding fixing owners. To generate new report please use:"
                        New-HTMLCodeBlock -Code {
                            Invoke-Testimo -FilePath $Env:UserProfile\Desktop\TestimoBefore.ForestConfigurationPartitionOwners.html -Type ForestConfigurationPartitionOwners
                        }
                        New-HTMLText -Text @(
                            "When executed it will take a while to generate all data and provide you with new report depending on size of environment."
                            "Once confirmed that data is still showing issues and requires fixing please proceed with next step."
                        )
                        New-HTMLText -Text "Alternatively if you prefer working with console you can run: "
                        New-HTMLCodeBlock -Code {
                            $Output = Get-WinADACLConfiguration -ObjectType site, subnet, siteLink -Owner -Verbose
                            $Output | Format-Table # do your actions as desired
                        }
                        New-HTMLText -Text "It provides same data as you see in table above just doesn't prettify it for you."
                    }
                    New-HTMLWizardStep -Name 'Fix AD Partition Configuration Owners' {
                        New-HTMLText -Text @(
                            "Configuration partition contains important AD Objects. Those are among other objects Subnets, Sites and SiteLinks. "
                            "Those objects should have proper owners which usually means being owned by Domain Admins/Enterprise Admins or at some cases by NT AUTHORITY\SYSTEM account. "
                            "Following command when executed fixes owners of those types. "
                            "If the object has proper owner, the owner change is skipped. "
                            "It makes sure each critical AD Object is owned Administrative or WellKnownAdministrative account. "
                            "Make sure when running it for the first time to run it with ",
                            "WhatIf",
                            " parameter as shown below to prevent accidental overwrite."
                        ) -FontWeight normal, normal, normal, normal, normal, normal, bold, normal -Color Black, Black, Black, Black, Black, Black, Red, Black
                        New-HTMLCodeBlock -Code {
                            Repair-WinADACLConfigurationOwner -ObjectType site, siteLink, subnet -Verbose -WhatIf -LimitProcessing 2
                        }
                        New-HTMLText -TextBlock {
                            "After execution please make sure there are no errors, make sure to review provided output, and confirm that what is about to be fixed matches expected data. Once happy with results please follow with command: "
                        }
                        New-HTMLCodeBlock -Code {
                            Repair-WinADACLConfigurationOwner -ObjectType site, siteLink, subnet -Verbose -WhatIf
                        }
                        New-HTMLText -TextBlock {
                            "This command when executed repairs only first X object owners. Use LimitProcessing parameter to prevent mass fixing and increase the counter when no errors occur. "
                            "Repeat step above as much as needed increasing LimitProcessing count till there's nothing left. In case of any issues please review and action accordingly. "
                        }
                    }
                    New-HTMLWizardStep -Name 'Verification report' {
                        New-HTMLText -TextBlock {
                            "Once cleanup task was executed properly, we need to verify that report now shows no problems."
                        }
                        New-HTMLCodeBlock -Code {
                            Invoke-Testimo -FilePath $Env:UserProfile\Desktop\TestimoAfter.ForestConfigurationPartitionOwners.html -Type ForestConfigurationPartitionOwners
                        }
                        New-HTMLText -TextBlock {
                            "If there were issues reported by this test you may consider running additional test "
                            "ForestConfigurationPartitionOwnersContainers "
                            "which focuses on whole containers rather than just specific objects. "
                            "This is to make sure most of configuration partition is as expected when it comes to object owners."
                        } -FontWeight normal, bold, normal, normal -Color Black, Amaranth, Black, Black
                        New-HTMLCodeBlock -Code {
                            Invoke-Testimo -FilePath $Env:UserProfile\Desktop\TestimoAfter.ForestConfigurationPartitionOwnersContainers.html -Type ForestConfigurationPartitionOwnersContainers
                        }
                        New-HTMLText -Text "If everything is healthy in the report you're done! Enjoy rest of the day!" -Color BlueDiamond
                    }
                } -RemoveDoneStepOnNavigateBack -Theme arrows -ToolbarButtonPosition center -EnableAllAnchors
            }
        }
    }
}