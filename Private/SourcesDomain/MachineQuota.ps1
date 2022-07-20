$MachineQuota = @{
    Name            = 'DomainMachineQuota'
    Enable          = $true
    Scope           = 'Domain'
    Source          = @{
        Name           = "Machine Quota: Gathering ms-DS-MachineAccountQuota"
        Data           = {
            Get-ADObject -Identity ((Get-ADDomain -Identity $Domain).distinguishedname) -Properties 'ms-DS-MachineAccountQuota' -Server $Domain | Select-Object DistinguishedName, Name, ObjectClass, ObjectGUID, ms-DS-MachineAccountQuota
        }
        Details        = [ordered] @{
            Category    = 'Security'
            Importance  = 0
            Description = "By default, In the Microsoft Active Directory, members of the authenticated user group can join up to 10 computer accounts in the domain. This value is defined in the attribute ms-DS-MachineAccountQuota on the domain-DNS object for a domain."
            Resources   = @(
                '[ms-DS-MachineAccountQuota](https://docs.microsoft.com/en-us/windows/win32/adschema/a-ms-ds-machineaccountquota)'
                "[MachineAccountQuota is USEFUL Sometimes: Exploiting One of Active Directory's Oddest Settings](https://www.netspi.com/blog/technical/network-penetration-testing/machineaccountquota-is-useful-sometimes/)"
                "[How to change the attribute ms-DS-MachineAccountQuota](https://www.jorgebernhardt.com/how-to-change-attribute-ms-ds-machineaccountquota/)"
                "[Default limit to number of workstations a user can join to the domain](https://docs.microsoft.com/pl-PL/troubleshoot/windows-server/identity/default-workstation-numbers-join-domain)"
            )
            Tags        = 'Security', 'Configuration'
            StatusTrue  = 0
            StatusFalse = 0
        }
        ExpectedOutput = $true
    }
    Tests           = [ordered] @{
        MachineQuotaIsZero = @{
            Enable     = $true
            Name       = 'Machine Quota: Should be set to 0'
            Parameters = @{
                ExpectedValue = 0
                Property      = 'ms-DS-MachineAccountQuota'
                OperationType = 'eq'
            }
            Details    = [ordered] @{
                Category    = 'Configuration'
                Importance  = 10
                ActionType  = 2
                StatusTrue  = 1
                StatusFalse = 5
            }
        }
    }
    DataDescription = {
        New-HTMLSpanStyle -FontSize 10pt {
            New-HTMLText -Text @(
                "By default, In the Microsoft Active Directory, members of the authenticated user group can join up to 10 computer accounts in the domain. "
                "This value is defined in the attribute "
                "ms-DS-MachineAccountQuota"
                " on the domain-DNS object for a domain. "
                "This value should always be ",
                "0"
                " and permissions to add computers to domain should be managed on Active Directory Delegation level."
            ) -FontWeight normal, normal, bold, normal
        }
    }
    DataHighlights  = {
        New-HTMLTableCondition -Name 'ms-DS-MachineAccountQuota' -ComparisonType number -BackgroundColor PaleGreen -Value 0 -Operator eq
        New-HTMLTableCondition -Name 'ms-DS-MachineAccountQuota' -ComparisonType number -BackgroundColor Salmon -Value 0 -Operator gt
    }
    Solution        = {
        New-HTMLContainer {
            New-HTMLSpanStyle -FontSize 10pt {
                New-HTMLWizard {
                    New-HTMLWizard {
                        New-HTMLWizardStep -Name 'Gather information about ms-DS-MachineAccountQuota' {
                            New-HTMLText -Text @(
                                "ms-DS-MachineAccountQuota "
                                "should always be set to 0 to prevent any users adding computers to domain. This is security risk and should be fixed for all domains in a forest!"
                                "To make sure you can easily revert this setting if something goes wrong you should first get this information before doing any changes."
                            ) -FontWeight bold, normal
                            New-HTMLCodeBlock {
                                Get-ADObject -Identity ((Get-ADDomain -Identity $Domain).distinguishedname) -Properties 'ms-DS-MachineAccountQuota' -Server $Domain
                            }
                        }
                    } -RemoveDoneStepOnNavigateBack -Theme arrows -ToolbarButtonPosition center -EnableAllAnchors
                    New-HTMLWizardStep -Name 'Fix ms-DS-MachineAccountQuota' {
                        New-HTMLText -Text @(
                            "ms-DS-MachineAccountQuota "
                            "should always be set to 0 to prevent any users adding computers to domain. This is security risk and should be fixed for all domains in a forest!"
                            "This can be done using following cmdlet. Please make sure to use WhatIf to verify what will change."
                        ) -FontWeight bold, normal
                        New-HTMLCodeBlock {
                            Set-ADDomain -Identity $Domain -Replace @{"ms-DS-MachineAccountQuota" = "0" } -WhatIf
                        }
                    }
                } -RemoveDoneStepOnNavigateBack -Theme arrows -ToolbarButtonPosition center -EnableAllAnchors
            }
        }
    }
}