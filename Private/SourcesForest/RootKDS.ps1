$RootKDS = @{
    Name            = "ForestRootKDS"
    Enable          = $true
    Scope           = 'Forest'
    Source          = @{
        Name           = 'Forest Root KDS Key'
        Data           = {
            Get-KdsRootKey
        }
        Details        = [ordered] @{
            Category    = 'Configuration'
            Description = 'Active Directory KDS Root Key is required to create GMSA accounts'
            Importance  = 6
            ActionType  = 1
            Resources   = @(
                '[ConfigMgr – SQL and Active Directory gMSA](https://configmgr.com/tag/root-key/)'
                '[Create the Key Distribution Services KDS Root Key](https://docs.microsoft.com/en-us/windows-server/security/group-managed-service-accounts/create-the-key-distribution-services-kds-root-key)'
            )
            Tags        = 'Configuration', 'GMSA'
            StatusTrue  = 1
            StatusFalse = 3
        }
        ExpectedOutput = $true
    }
    DataDescription = {
        New-HTMLSpanStyle -FontSize 10pt {
            New-HTMLText -Text @(
                "Domain Controllers (DC) require a root key to begin generating gMSA passwords. "
                "The domain controllers will wait up to 10 hours from time of creation to allow all domain controllers to converge their AD replication before allowing the creation of a gMSA. "
                "The 10 hours is a safety measure to prevent password generation from occurring before all DCs in the environment are capable of answering gMSA requests. "
                "If you try to use a gMSA too soon the key might not have been replicated to all domain controllers and therefore password retrieval might fail when the gMSA host attempts to retrieve the password. "
                "gMSA password retrieval failures can also occur when using DCs with limited replication schedules or if there is a replication issue."
            )
        }
    }
    DataHighlights  = {

    }
    Solution        = {
        New-HTMLContainer {
            New-HTMLSpanStyle -FontSize 10pt {
                New-HTMLWizard {
                    New-HTMLWizardStep -Name 'Setting up KDS Root Key' {
                        New-HTMLText -Text @(
                            "On the Windows Server 2012 or later domain controller, run the Windows PowerShell from the Taskbar. "
                            "To create the KDS root key using the Add-KdsRootKey cmdlet, run the following command: "
                        )
                        New-HTMLCodeBlock {
                            Add-KdsRootKey -EffectiveImmediately
                        }
                        New-HTMLText -Text "The 10 hours is a safety measure to prevent password generation from occurring before all DCs in the environment are capable of answering gMSA requests."
                        New-HTMLText -LineBreak
                        New-HTMLText -Text @(
                            "The Effective time parameter can be used to give time for keys to be propagated to all DCs before use. "
                            "Using Add-KdsRootKey -EffectiveImmediately will add a root key to the target DC which will be used by the KDS service immediately. "
                            "However, other domain controllers will not be able to use the root key until replication is successful."
                            "For test environments with only one DC, you can create a KDS root key and set the start time in the past to avoid the interval wait for key generation by using the following procedure. "
                            "Validate that a 4004 event has been logged in the kds event log."
                        )
                        New-HTMLText -Text "To create the ", "KDS root key ", "using the ", "Add-KdsRootKey", " cmdlet" -Color None, Tangerine, None, Tangerine, None
                        New-HTMLCodeBlock {
                            Add-KdsRootKey -EffectiveTime ((Get-Date).AddHours(-10))
                        }
                    }
                } -RemoveDoneStepOnNavigateBack -Theme arrows -ToolbarButtonPosition center -EnableAllAnchors
            }
        }
    }
}