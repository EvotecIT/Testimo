$OptionalFeatures = [ordered] @{
    Enable = $true
    Scope  = 'Forest'
    Source = [ordered] @{
        Name           = 'Optional Features'
        Data           = {
            Get-WinADForestOptionalFeatures
        }
        Details        = [ordered] @{
            Category    = 'Configuration'
            Description = "Optional features verify availability of Recycle Bin, LAPS and PAM in the Active Directory Forest."
            Resolution  = 'Enable RecycleBin, implement LAPS, consider PAM.'
            Importance  = 5
            Severity    = 'Medium'
            Resources   = @(

            )
        }
        ExpectedOutput = $true
    }
    Tests  = [ordered] @{
        RecycleBinEnabled    = @{
            Enable     = $true
            Name       = 'Recycle Bin Enabled'
            Parameters = @{
                Property      = 'Recycle Bin Enabled'
                ExpectedValue = $true
                OperationType = 'eq'
            }
            Details    = [ordered] @{
                Area        = 'Configuration'
                Description = "The AD Recycle bin allows you to quickly restore deleted objects without the need of a system state or 3rd party backup. The recycle bin feature preserves all link valued and non link valued attributes. This means that a restored object will retain all it's settings when restored."
                Resolution  = 'Enable AD Recycle bin for the whole forest.'
                Importance  = 5
                Resources   = @(
                    'https://activedirectorypro.com/enable-active-directory-recycle-bin-server-2016/'
                )
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
                Resolution  = 'Introduce LAPS for the whole forest.'
                Importance  = 5
                Resources   = @(
                    'https://blog.stealthbits.com/running-laps-in-the-race-to-security/'
                    'https://github.com/lithnet/laps-web'
                    'https://evotec.xyz/getting-bitlocker-and-laps-summary-report-with-powershell/'
                    'https://evotec.xyz/backing-up-bitlocker-keys-and-laps-passwords-from-active-directory/'
                )
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
                Description = "Privileged Access Management (PAM) is a solution that helps organizations restrict privileged access within an existing Active Directory environment."
                Resolution  = 'Consider introducing PAM to your environment.'
                Severity    = 'Recommendation'
                Importance  = 5
                Resources   = @(
                    'https://docs.microsoft.com/en-us/microsoft-identity-manager/pam/privileged-identity-management-for-active-directory-domain-services'
                )
            }
        }
    }
}