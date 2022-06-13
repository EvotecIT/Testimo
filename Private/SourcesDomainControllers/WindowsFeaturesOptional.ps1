$WindowsFeaturesOptional = @{
    Name     = 'DCWindowsFeaturesOptional'
    Enable   = $true
    Scope    = 'DC'
    Source   = @{
        Name           = "Windows Features Optional"
        Data           = {
            $Output = Invoke-Command -ComputerName $DomainController -ErrorAction Stop {
                Get-WindowsOptionalFeature -Online -FeatureName MicrosoftWindowsPowerShellV2
            }
            $Output | Select-Object -Property DisplayName, Description, RestartRequired, FeatureName, State
        }
        Details        = [ordered] @{
            Category    = 'Configuration'
            Description = 'Windows optional features'
            Importance  = 0
            ActionType  = 0
            Resources   = @(
                "[The Windows PowerShell 2.0 feature must be disabled on the system](https://www.stigviewer.com/stig/windows_10/2017-04-28/finding/V-70637)"
            )
            Tags        = 'Features', 'Configuration'
            StatusTrue  = 0
            StatusFalse = 0
        }
        ExpectedOutput = $true
    }
    Tests    = [ordered] @{
        # WindowsPowerShellRoot = @{
        #     Enable     = $true
        #     Name       = 'Windows PowerShell Root should be disabled'
        #     Parameters = @{
        #         WhereObject   = { $_.FeatureName -eq 'MicrosoftWindowsPowerShellRoot' }
        #         Property      = 'State'
        #         ExpectedValue = 'Disabled'
        #         OperationType = 'eq'
        #     }
        #     Details    = @{
        #         Description = "Windows PowerShell 2.0 Engine includes the core components from Windows PowerShell 2.0 for backward compatibility with existing Windows PowerShell host applications. Windows PowerShell 5.0 added advanced logging features which can provide additional detail when malware has been run on a system. Disabling the Windows PowerShell 2.0 mitigates against a downgrade attack that evades the Windows PowerShell 5.0 script block logging feature."
        #         Tags        = 'Backup', 'Configuration'
        #         StatusTrue  = 1
        #         StatusFalse = 4
        #     }
        # }
        WindowsPowerShell2 = @{
            Enable     = $true
            Name       = 'Windows PowerShell 2.0 should be disabled'
            Parameters = @{
                WhereObject   = { $_.FeatureName -eq 'MicrosoftWindowsPowerShellV2' }
                Property      = 'State'
                ExpectedValue = 'Disabled'
                OperationType = 'eq'
            }
            Details    = @{
                Category    = 'Configuration'
                Importance  = 8
                ActionType  = 2
                Description = "Windows PowerShell 2.0 Engine includes the core components from Windows PowerShell 2.0 for backward compatibility with existing Windows PowerShell host applications. Windows PowerShell 5.0 added advanced logging features which can provide additional detail when malware has been run on a system. Disabling the Windows PowerShell 2.0 mitigates against a downgrade attack that evades the Windows PowerShell 5.0 script block logging feature."
                Tags        = 'Backup', 'Configuration'
                StatusTrue  = 1
                StatusFalse = 4
            }
        }
    }
    Solution = {
        New-HTMLContainer {
            New-HTMLSpanStyle -FontSize 10pt {
                New-HTMLWizard {
                    New-HTMLWizardStep -Name 'Disabling Windows PowerShell 2.0' {
                        New-HTMLText -Text @(
                            "Windows PowerShell 5.0 added advanced logging features which can provide additional detail when malware has been run on a system. Disabling the Windows PowerShell 2.0 mitigates against a downgrade attack that evades the Windows PowerShell 5.0 script block logging feature."
                        )
                        New-HTMLText -Text @(
                            "Run 'Windows PowerShell' with elevated privileges (run as administrator)."
                        )
                        New-HTMLCodeBlock -Style powershell {
                            Disable-WindowsOptionalFeature -Online -FeatureName MicrosoftWindowsPowerShellV2
                        }

                        New-HTMLText -Text @(
                            "In some cases it may be required to disable MicrosoftWindowsPowerShellRoot. "
                            "Run 'Windows PowerShell' with elevated privileges (run as administrator)."
                        )
                        New-HTMLCodeBlock -Style powershell {
                            Disable-WindowsOptionalFeature -Online -FeatureName MicrosoftWindowsPowerShellRoot
                        }
                    }
                } -RemoveDoneStepOnNavigateBack -Theme arrows -ToolbarButtonPosition center -EnableAllAnchors
            }
        }
    }
}
