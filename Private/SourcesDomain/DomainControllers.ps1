$DomainDomainControllers = @{
    Enable          = $true
    Scope           = 'Domain'
    Source          = @{
        Name           = "Domain Controller Owners"
        Data           = {
            Get-WinADForestControllerInformation -Forest $ForestName -Domain $Domain
        }
        Requirements   = @{}
        Details        = [ordered] @{
            Area        = 'Configuration'
            Category    = 'Security'
            Severity    = ''
            Importance   = 0
            Description = "Following test verifies Domain Controller status in Active Directory. It verifies critical aspects of Domain Controler such as Domain Controller Owner and Domain Controller Manager. It also checks if Domain Controller is enabled, ip address matches dns ip address, verifies whether LastLogonDate and LastPasswordDate are within thresholds. Those additional checks are there to find dead or offline DCs that could potentially impact Active Directory functionality. "
            Resolution  = ''
            Resources   = @(
                '[Domain member: Maximum machine account password age](https://docs.microsoft.com/en-us/windows/security/threat-protection/security-policy-settings/domain-member-maximum-machine-account-password-age)'
                '[Machine Account Password Process](https://techcommunity.microsoft.com/t5/ask-the-directory-services-team/machine-account-password-process/ba-p/396026)'
                '[How to Configure DNS on a Domain Controller with Two IP Addresses](https://petri.com/configure-dns-on-domain-controller-two-ip-addresses)'
            )
        }
        ExpectedOutput = $true
    }
    Tests           = [ordered] @{
        Enabled            = @{
            Enable     = $true
            Name       = 'DC should be enabled'
            Parameters = @{
                ExpectedCount = 0
                OperationType = 'eq'
                WhereObject   = { $_.Enabled -ne $true }
            }
            Details    = [ordered] @{
                Category  = 'Cleanup'
                Importance = 0
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
            Details    = [ordered] @{
                Category  = 'Security'
                Importance = 10
            }
        }
        ManagedBy          = @{
            Enable     = $true
            Name       = 'ManagedBy should be empty'
            Parameters = @{
                ExpectedCount = 0
                OperationType = 'eq'
                WhereObject   = { $_.ManagerNotSet -ne $true }
            }
            Details    = [ordered] @{
                Category  = 'Security'
                Importance = 10
            }
        }
        DNSStatus          = @{
            Enable     = $true
            Name       = 'DNS should return IP Address for DC'
            Parameters = @{
                ExpectedCount = 0
                OperationType = 'eq'
                WhereObject   = { $_.DNSStatus -ne $true }
            }
            Details    = [ordered] @{
                Category  = 'Cleanup'
                Importance = 0
            }
        }
        IPAddressStatusV4  = @{
            Enable     = $true
            Name       = 'DNS returned IPAddressV4 should match AD'
            Parameters = @{
                ExpectedCount = 0
                OperationType = 'eq'
                WhereObject   = { $_.IPAddressStatusV4 -ne $true }
            }
            Details    = [ordered] @{
                Category  = 'Cleanup'
                Importance = 0
            }
        }
        IPAddressStatusV6  = @{
            Enable     = $true
            Name       = 'DNS returned IPAddressV6 should match AD'
            Parameters = @{
                ExpectedCount = 0
                OperationType = 'eq'
                WhereObject   = { $_.IPAddressStatusV6 -ne $true }
            }
            Details    = [ordered] @{
                Category  = 'Cleanup'
                Importance = 0
            }
        }
        IPAddressSingleV4  = @{
            Enable     = $true
            Name       = 'There should be single IPv4 address set'
            Parameters = @{
                ExpectedCount = 0
                OperationType = 'eq'
                WhereObject   = { $_.IPAddressHasOneIpV4 -ne $true }
            }
            Details    = [ordered] @{
                Category  = 'Cleanup'
                Importance = 0
            }
        }
        IPAddressSingleV6  = @{
            Enable     = $true
            Name       = 'There should be single IPv6 address set'
            Parameters = @{
                ExpectedCount = 0
                OperationType = 'eq'
                WhereObject   = { $_.IPAddressHasOneipV6 -ne $true }
            }
            Details    = [ordered] @{
                Category  = 'Cleanup'
                Importance = 0
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
            Details    = [ordered] @{
                Category  = 'Cleanup'
                Importance = 0
            }
        }
        LastLogonDays      = @{
            Enable     = $true
            Name       = 'Last Logon Less Than X days'
            Parameters = @{
                ExpectedCount = 0
                OperationType = 'eq'
                WhereObject   = { $_.LastLogonDays -ge 15 }
            }
            Details    = [ordered] @{
                Category  = 'Cleanup'
                Importance = 0
            }
        }
    }
    DataInformation = {
        New-HTMLText -Text 'Explanation to table columns:' -FontSize 10pt
        New-HTMLList {
            New-HTMLListItem -FontWeight bold, normal -Text "Enabled", " - means Domain Controller is enabled. If it's disabled it should be removed using proper cleanup method and according to company operation procedures. "
            New-HTMLListItem -FontWeight bold, normal -Text "DNSStatus", " - means Domain Controller IP address is available in DNS. If it's not registrered this means DC may not be functioning properly. "
            New-HTMLListItem -FontWeight bold, normal -Text "IPAddressStatusV4", " - means Domain Controller IP matches the one returned by DNS for IPV4. "
            New-HTMLListItem -FontWeight bold, normal -Text "IPAddressStatusV6", " - means Domain Controller IP matches the one returned by DNS for IPV6. "
            New-HTMLListItem -FontWeight bold, normal -Text "IPAddressHasOneIpV4", " - means Domain Controller has only one 1 IPV4 ipaddress (or not set at all). If it has more than 1 it's bad. "
            New-HTMLListItem -FontWeight bold, normal -Text "IPAddressHasOneipV6", " - means Domain Controller has only one 1 IPV6 ipaddress (or not set at all). If it has more than 1 it's bad. "
            New-HTMLListItem -FontWeight bold, normal -Text "ManagerNotSet", " - means ManagedBy property is not set (as required). If it's set it's bad. "
            New-HTMLListItem -FontWeight bold, normal -Text "OwnerType", " - means Domain Controller Owner is of certain type. Required type is Administrative. If it's different that means there's security risk involved. "
            New-HTMLListItem -FontWeight bold, normal -Text "PasswordLastChangedDays", " - displays last password change by Domain Controller. If it's more than 60 days it usually means DC is down or otherwise affected. "
            New-HTMLListItem -FontWeight bold, normal -Text "LastLogonDays", " - display last logon days of DC. If it's more than 15 days it usually means DC is down or otherwise affected. "
        } -FontSize 10pt
    }
    DataHighlights  = {
        New-HTMLTableCondition -Name 'Enabled' -ComparisonType string -BackgroundColor Salmon -Value $false
        New-HTMLTableCondition -Name 'Enabled' -ComparisonType string -BackgroundColor PaleGreen -Value $true
        New-HTMLTableCondition -Name 'DNSStatus' -ComparisonType string -BackgroundColor Salmon -Value $false
        New-HTMLTableCondition -Name 'DNSStatus' -ComparisonType string -BackgroundColor PaleGreen -Value $true
        New-HTMLTableCondition -Name 'ManagerNotSet' -ComparisonType string -BackgroundColor Salmon -Value $false
        New-HTMLTableCondition -Name 'ManagerNotSet' -ComparisonType string -BackgroundColor PaleGreen -Value $true
        New-HTMLTableCondition -Name 'IPAddressStatusV4' -ComparisonType string -BackgroundColor Salmon -Value $false
        New-HTMLTableCondition -Name 'IPAddressStatusV4' -ComparisonType string -BackgroundColor PaleGreen -Value $true
        New-HTMLTableCondition -Name 'IPAddressStatusV6' -ComparisonType string -BackgroundColor Salmon -Value $false
        New-HTMLTableCondition -Name 'IPAddressStatusV6' -ComparisonType string -BackgroundColor PaleGreen -Value $true
        New-HTMLTableCondition -Name 'IPAddressHasOneIpV4' -ComparisonType string -BackgroundColor Salmon -Value $false
        New-HTMLTableCondition -Name 'IPAddressHasOneIpV4' -ComparisonType string -BackgroundColor PaleGreen -Value $true
        New-HTMLTableCondition -Name 'IPAddressHasOneipV6' -ComparisonType string -BackgroundColor Salmon -Value $false
        New-HTMLTableCondition -Name 'IPAddressHasOneipV6' -ComparisonType string -BackgroundColor PaleGreen -Value $true
        New-HTMLTableCondition -Name 'OwnerType' -ComparisonType string -BackgroundColor Salmon -Value 'Administrative' -Operator ne
        New-HTMLTableCondition -Name 'OwnerType' -ComparisonType string -BackgroundColor PaleGreen -Value 'Administrative' -Operator eq
        New-HTMLTableCondition -Name 'ManagedBy' -ComparisonType string -Color Salmon -Value '' -Operator ne
        New-HTMLTableCondition -Name 'PasswordLastChangedDays' -ComparisonType number -BackgroundColor PaleGreen -Value 40 -Operator le
        New-HTMLTableCondition -Name 'PasswordLastChangedDays' -ComparisonType number -BackgroundColor OrangePeel -Value 41 -Operator ge
        New-HTMLTableCondition -Name 'PasswordLastChangedDays' -ComparisonType number -BackgroundColor Crimson -Value 60 -Operator ge
        New-HTMLTableCondition -Name 'LastLogonDays' -ComparisonType number -BackgroundColor PaleGreen -Value 15 -Operator lt
        New-HTMLTableCondition -Name 'LastLogonDays' -ComparisonType number -BackgroundColor OrangePeel -Value 15 -Operator ge
        New-HTMLTableCondition -Name 'LastLogonDays' -ComparisonType number -BackgroundColor Crimson -Value 30 -Operator ge
    }
    Solution        = {
        New-HTMLContainer {
            New-HTMLSpanStyle -FontSize 10pt {
                #New-HTMLText -Text 'Following steps will guide you how to fix permissions consistency'
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
                            Invoke-Testimo -FilePath $Env:UserProfile\Desktop\TestimoBefore.DomainDomainControllers.html -Type DomainDomainControllers
                        }
                        New-HTMLText -Text @(
                            "When executed it will take a while to generate all data and provide you with new report depending on size of environment."
                            "Once confirmed that data is still showing issues and requires fixing please proceed with next step."
                        )
                        New-HTMLText -Text "Alternatively if you prefer working with console you can run: "
                        New-HTMLCodeBlock -Code {
                            $Output = Get-WinADForestControllerInformation -IncludeDomains 'TargetDomain'
                            $Output | Format-Table # do your actions as desired
                        }
                        New-HTMLText -Text "It provides same data as you see in table above just doesn't prettify it for you."
                    }
                    New-HTMLWizardStep -Name 'Fix Domain Controller Owner' {
                        New-HTMLText -Text @(
                            "Domain Controller Owner should always be set to Domain Admins. "
                            "When non Domain Admin adds computer to domain that later on gets promoted to Domain Controller that person becomes the owner of the AD object. "
                            "This is very dangerous and requires fixing. "
                            "Following command when executed fixes domain controller owner. "
                            "It makes sure each DC is owned by Domain Admins. "
                            "If it's owned by Domain Admins already it will be skipped. "
                            "Make sure when running it for the first time to run it with ", "WhatIf", " parameter as shown below to prevent accidental overwrite."
                        ) -FontWeight normal, normal, normal, normal, normal, normal, normal, bold, normal -Color Black, Black, Black, Black, Black, Black, Black, Red, Black
                        New-HTMLText -Text "Make sure to fill in TargetDomain to match your Domain Admin permission account"

                        New-HTMLCodeBlock -Code {
                            Repair-WinADForestControllerInformation -Verbose -LimitProcessing 3 -Type Owner -IncludeDomains "TargetDomain" -WhatIf
                        }
                        New-HTMLText -TextBlock {
                            "After execution please make sure there are no errors, make sure to review provided output, and confirm that what is about to be fixed matches expected data. Once happy with results please follow with command: "
                        }
                        New-HTMLCodeBlock -Code {
                            Repair-WinADForestControllerInformation -Verbose -LimitProcessing 3 -Type Owner -IncludeDomains "TargetDomain"
                        }
                        New-HTMLText -TextBlock {
                            "This command when executed repairs only first X domain controller owners. Use LimitProcessing parameter to prevent mass fixing and increase the counter when no errors occur. "
                            "Repeat step above as much as needed increasing LimitProcessing count till there's nothing left. In case of any issues please review and action accordingly. "
                        }
                    }
                    New-HTMLWizardStep -Name 'Fix Domain Controller Manager' {
                        New-HTMLText -Text @(
                            "Domain Controller Manager should not be set. "
                            "There's no reason for anyone outside of Domain Admins group to be manager of Domain Controller object. "
                            "Since Domain Admins are by design Owners of Domain Controller object ManagedBy field should not be set. "
                            "Following command fixes this by clearing ManagedBy field. "
                        )
                        New-HTMLCodeBlock -Code {
                            Repair-WinADForestControllerInformation -Verbose -LimitProcessing 3 -Type Manager -IncludeDomains "TargetDomain" -WhatIf
                        }
                        New-HTMLText -TextBlock {
                            "After execution please make sure there are no errors, make sure to review provided output, and confirm that what is about to be fixed matches expected data. Once happy with results please follow with command: "
                        }
                        New-HTMLCodeBlock -Code {
                            Repair-WinADForestControllerInformation -Verbose -LimitProcessing 3 -Type Manager -IncludeDomains "TargetDomain"
                        }
                        New-HTMLText -TextBlock {
                            "This command when executed repairs only first X domain controller managers. Use LimitProcessing parameter to prevent mass fixing and increase the counter when no errors occur. "
                            "Repeat step above as much as needed increasing LimitProcessing count till there's nothing left. In case of any issues please review and action accordingly. "
                        }
                    }
                    New-HTMLWizardStep -Name 'Remaining Problems' {
                        New-HTMLText -Text @(
                            "If there are any Domain Controllers that are disabled, or last logon date or last password set are above thresholds those should be investigated if those are still up and running. "
                            "In Active Directory–based domains, each device has an account and password. "
                            "By default, the domain members submit a password change every 30 days. "
                            "If last password change is above threshold that means DC may already be offline. "
                            "If last logon date is above threshold that also means DC may already be offline. "
                            "Bringing back DC to life after longer downtime period can cause serious issues when done improperly. "
                            "Please investigate and decide with other Domain Admins how to deal with dead/offline DC. "
                        )
                        New-HTMLText -LineBreak
                        New-HTMLText -Text @(
                            "Additionally DNS should return IP Address of DC when asked, and it should be the same IP Address as the one stored in Active Directory. "
                            "If those do not match or IP Address is not set/returned it needs investigation why is it so. "
                            "It's possible the DC is down/dead and should be safely removed from Active Directory to prevent potential issues. "
                            "Alternatively it's possible there are some network issues with it. "
                        )
                    }
                    New-HTMLWizardStep -Name 'Verification report' {
                        New-HTMLText -TextBlock {
                            "Once cleanup task was executed properly, we need to verify that report now shows no problems."
                        }
                        New-HTMLCodeBlock -Code {
                            Invoke-Testimo -FilePath $Env:UserProfile\Desktop\TestimoAfter.DomainDomainControllers.html -Type DomainDomainControllers
                        }
                        New-HTMLText -Text "If everything is healthy in the report you're done! Enjoy rest of the day!" -Color BlueDiamond
                    }
                } -RemoveDoneStepOnNavigateBack -Theme arrows -ToolbarButtonPosition center -EnableAllAnchors
            }
        }
    }
}