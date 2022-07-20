$VulnerableSchemaClass = @{
    Name            = "ForestVulnerableSchemaClass"
    Enable          = $true
    Scope           = 'Forest'
    Source          = @{
        Name           = 'Vurnerable Schema Class'
        Data           = {
            Test-WinADVulnerableSchemaClass
        }
        Details        = [ordered] @{
            Category    = 'Security'
            Description = 'Environments running supported versions of Exchange Server should address CVE-2021-34470 by applying the CU and/or SU for the respective versions of Exchange, as described in Released: July 2021 Exchange Server Security Updates. Environments where the latest version of Exchange Server is any version before Exchange 2013, or environments where all Exchange servers have been removed, one can use a script to address the vulnerability.'
            Resolution  = ''
            Importance  = 5
            ActionType  = 1
            StatusTrue  = 1
            StatusFalse = 5
            Resources   = @(
                "[Test-CVE-2021-34470](https://microsoft.github.io/CSS-Exchange/Security/Test-CVE-2021-34470/)"
                "[July 2021 Exchange Server Security Updates](https://techcommunity.microsoft.com/t5/exchange-team-blog/released-july-2021-exchange-server-security-updates/ba-p/2523421)"
            )
        }
        ExpectedOutput = $true
    }
    Tests           = [ordered] @{
        VurnerableSchemaClass = @{
            Enable     = $true
            Name       = 'Schema Class should not be vulnerable'
            Parameters = @{
                Property      = 'Vulnerable'
                ExpectedValue = $false
                OperationType = 'eq'
            }
            Details    = @{
                Category    = 'Security'
                Importance  = 5
                ActionType  = 2
                StatusTrue  = 1
                StatusFalse = 5
            }
        }
    }
    DataDescription = {
        New-HTMLSpanStyle -FontSize 10pt {
            New-HTMLText -Text @(
                'Environments running supported versions of Exchange Server should address CVE-2021-34470 by applying the CU and/or SU for the respective versions of Exchange, as described in Released: July 2021 Exchange Server Security Updates.               '
            )
            New-HTMLText -Text @(
                'Environments where the latest version of Exchange Server is any version before Exchange 2013, or environments where all Exchange servers have been removed, can use this script to address the vulnerability.'
            )
        }
    }
    DataHighlights  = {
        New-HTMLTableCondition -Name 'Vulnerable' -ComparisonType string -BackgroundColor PaleGreen -Value $false -Operator eq
        New-HTMLTableCondition -Name 'Vulnerable' -ComparisonType string -BackgroundColor Salmon -Value $true -Operator eq
    }
    Solution        = {
        New-HTMLContainer {
            New-HTMLSpanStyle -FontSize 10pt {
                New-HTMLWizard {
                    New-HTMLWizardStep -Name 'Vulnerable Schema Class' {
                        New-HTMLText -Text @(
                            "Depending whether there is still an Exchange Server present or not there are two ways to address the vulnerability."
                        ) -FontWeight normal, normal, normal, normal, normal, normal, bold, normal -Color Black, Black, Black, Black, Black, Black, Red, Black
                    }
                    New-HTMLWizardStep -Name 'Exchange Server is still in use' {
                        New-HTMLText -Text @(
                            "If the Exchange Server is still present, you can apply the CU "
                            "for the respective version of Exchange along with preparing the schema which will fix the vulnerability."
                            "More details can be found on [July 2021 Exchange Server Security Updates](https://techcommunity.microsoft.com/t5/exchange-team-blog/released-july-2021-exchange-server-security-updates/ba-p/2523421)"
                        )
                    }
                    New-HTMLWizardStep -Name 'Exchange Server is not in use anymore or older version' {
                        New-HTMLText -Text "Without explicit action by a schema admin in your organization, you might be vulnerable to CVE-2021-34470 if:"
                        New-HTMLList {
                            New-HTMLListItem -Text "You ran Exchange Server in the past, but you have since uninstalled all Exchange servers."
                            New-HTMLListItem -Text "You still run Exchange Server, but only versions older than Exchange 2013 (namely,Exchange 2003, Exchange 2007 and/or Exchange 2010)."
                        }
                        New-HTMLText -Text "If your organization is in one of these scenarios, we recommend the following to update your Active Directory schema to address the vulnerability in CVE-2021-34470:"
                        New-HTMLText -Text "Download the script [Test-CVE-2021-34470](https://microsoft.github.io/CSS-Exchange/Security/Test-CVE-2021-34470/) from GitHub and use it to apply the needed schema update; please note the script requirements on the GitHub page."
                    }
                } -RemoveDoneStepOnNavigateBack -Theme arrows -ToolbarButtonPosition center -EnableAllAnchors
            }
        }
    }
}
