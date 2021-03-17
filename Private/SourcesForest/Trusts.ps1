$Trusts = @{
    Enable = $true
    Scope  = 'Forest'
    Source = @{
        Name           = "Trust Availability"
        Data           = {
            Get-WinADTrust -Forest $ForestName
        }
        Details        = [ordered] @{
            Category    = 'Health', 'Configuration'
            Importance  = 4
            ActionType  = 0
            Description = 'Verifies if trusts are available and tests for trust unconstrained TGTDelegation'
            Resolution  = ''
            Resources   = @(
                '[Changes to Ticket-Granting Ticket (TGT) Delegation Across Trusts in Windows Server (CIS edition)](https://techcommunity.microsoft.com/t5/core-infrastructure-and-security/changes-to-ticket-granting-ticket-tgt-delegation-across-trusts/ba-p/440261)'
                "[Visually display Active Directory Trusts using PowerShell](https://evotec.xyz/visually-display-active-directory-trusts-using-powershell/)"
            )
            StatusTrue  = 0
            StatusFalse = 3
        }
        ExpectedOutput = $null
    }
    Tests  = [ordered] @{
        TrustsConnectivity            = @{
            Enable     = $true
            Name       = 'Trust status'
            Parameters = @{
                OverwriteName = { "Trust status | Source $($_.'TrustSource'), Target $($_.'TrustTarget'), Direction $($_.'TrustDirection')" }
                Property      = 'TrustStatus'
                ExpectedValue = 'OK'
                OperationType = 'eq'
            }
            Details    = [ordered] @{
                Category    = 'Configuration'
                Importance  = 5
                ActionType  = 2
                StatusTrue  = 1
                StatusFalse = 0
            }
        }
        TrustsQueryStatus             = @{
            Enable     = $true
            Name       = 'Trust Query Status'
            Parameters = @{
                OverwriteName = { "Trust query | Source $($_.'TrustSource'), Target $($_.'TrustTarget'), Direction $($_.'TrustDirection')" }
                Property      = 'QueryStatus'
                ExpectedValue = 'OK'
                OperationType = 'eq'
            }
            Details    = [ordered] @{
                Category    = 'Configuration'
                Importance  = 5
                ActionType  = 2
                StatusTrue  = 1
                StatusFalse = 5
            }
        }
        TrustsUnconstrainedDelegation = @{
            Enable     = $true
            Name       = 'Trust unconstrained TGTDelegation'
            Parameters = @{
                # TGTDelegation should be set to $True (contrary to name)
                OverwriteName = { "Trust unconstrained TGTDelegation | Source $($_.'TrustSource'), Target $($_.'TrustTarget'), Direction $($_.'TrustDirection')" }
                WhereObject   = { ($_.'TrustAttributes' -ne 'Within Forest') -and ($_.'TrustDirection' -eq 'BiDirectional' -or $_.'TrustDirection' -eq 'InBound') }
                Property      = 'IsTGTDelegationEnabled'
                ExpectedValue = $false
                OperationType = 'eq'
            }
            Details    = [ordered] @{
                Category    = 'Configuration'
                Importance  = 5
                ActionType  = 2
                StatusTrue  = 1
                StatusFalse = 5
            }
        }
    }
}