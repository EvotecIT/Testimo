$OptionalFeatures = [ordered] @{
    Name            = "ForestOptionalFeatures"
    Enable          = $true
    Scope           = 'Forest'
    Source          = [ordered] @{
        Name           = 'Optional Features'
        Data           = {
            Get-WinADForestOptionalFeatures
        }
        Details        = [ordered] @{
            Category    = 'Configuration'
            Description = "Verifies availability of Recycle Bin, LAPS and PAM in the Active Directory Forest."
            Importance  = 0
            ActionType  = 0
            Resources   = @(

            )
            StatusTrue  = 0
            StatusFalse = 5
        }
        ExpectedOutput = $true
    }
    Tests           = [ordered] @{
        RecycleBinEnabled    = @{
            Enable     = $true
            Name       = 'Recycle Bin Enabled'
            Parameters = @{
                Property      = 'Recycle Bin Enabled'
                ExpectedValue = $true
                OperationType = 'eq'
            }
            Details    = [ordered] @{
                Category    = 'Configuration'
                Description = "The AD Recycle bin allows you to quickly restore deleted objects without the need of a system state or 3rd party backup. The recycle bin feature preserves all link valued and non link valued attributes. This means that a restored object will retain all it's settings when restored."
                Importance  = 5
                ActionType  = 2
                Resources   = @(
                    '[How to Enable Active Directory Recycle Bin (Server 2016)](https://activedirectorypro.com/enable-active-directory-recycle-bin-server-2016/)'
                )
                StatusTrue  = 1
                StatusFalse = 4
            }
        }
        LapsAvailable        = @{
            Enable     = $true
            Name       = 'LAPS Schema Extended'
            Parameters = @{
                Property      = 'Laps Enabled'
                ExpectedValue = $true
                OperationType = 'eq'
            }
            Details    = [ordered] @{
                Category    = 'Configuration'
                Description = "Microsoft Local Administrator Password Solution (LAPS) is a password manager that utilizes Active Directory to manage and rotate passwords for local Administrator accounts across all of your Windows endpoints. LAPS is a great mitigation tool against lateral movement and privilege escalation, by forcing all local Administrator accounts to have unique, complex passwords, so an attacker compromising one local Administrator account can’t move laterally to other endpoints and accounts that may share that same password."
                Importance  = 10
                ActionType  = 2
                Resources   = @(
                    '[Running LAPS in the race to security](https://blog.stealthbits.com/running-laps-in-the-race-to-security/)'
                    '[Lithnet LAPS Web App](https://github.com/lithnet/laps-web)'
                    '[Lithnet Access Manager](https://github.com/lithnet/access-manager)'
                    '[Getting Bitlocker and LAPS summary report with PowerShell](https://evotec.xyz/getting-bitlocker-and-laps-summary-report-with-powershell/)'
                    '[Backing up Bitlocker Keys and LAPS passwords from Active Directory](https://evotec.xyz/backing-up-bitlocker-keys-and-laps-passwords-from-active-directory/)'
                )
                StatusTrue  = 1
                StatusFalse = 4
            }
        }
        PrivAccessManagement = @{
            Enable     = $true
            Name       = 'Privileged Access Management Enabled'
            Parameters = @{
                Property      = 'Privileged Access Management Feature Enabled'
                ExpectedValue = $true
                OperationType = 'eq'
            }
            Details    = [ordered] @{
                Category    = 'Configuration'
                Description = "Privileged Access Management (PAM) is a solution that helps organizations restrict privileged access within an existing Active Directory environment. Consider introducing PAM to your environment."
                Importance  = 5
                ActionType  = 0
                Resources   = @(
                    '[Privileged Access Management for Active Directory Domain Services](https://docs.microsoft.com/en-us/microsoft-identity-manager/pam/privileged-identity-management-for-active-directory-domain-services)'
                )
                StatusTrue  = 1
                StatusFalse = 0
            }
        }
    }
    DataDescription = {
        New-HTMLSpanStyle -FontSize 10pt {
            New-HTMLText -Text @(
                "Following test verifies availability of Recycle Bin, LAPS and PAM in the Active Directory Forest. "
                "While LAPS and RecycleBin are quite critical for properly functioning Active Directory, PAM is just a recommendation and is not so easy to implement. "
                "Therefore only 2 out of 3 tests are considered critical. PAM test is optional. "
            )
        }
    }
    DataHighlights  = {
        New-HTMLTableCondition -Name 'Value' -ComparisonType string -BackgroundColor PaleGreen -Value $true -Operator eq
        New-HTMLTableCondition -Name 'Value' -ComparisonType string -BackgroundColor Salmon -Value $false -Operator eq
    }
}