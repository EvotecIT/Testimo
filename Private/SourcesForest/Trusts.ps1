$Trusts = @{
    Enable = $true
    Scope  = 'Forest'
    Source = @{
        Name           = "Trust Availability"
        Data           = {
            Get-WinADTrust -Forest $ForestName
        }
        Details        = [ordered] @{
            Area        = 'Health', 'Configuration'
            Category    = 'Trusts'
            Severity    = ''
            RiskLevel   = 0
            Description = 'Verifies if trusts are available and tests for trust unconstrained TGTDelegation'
            Resolution  = ''
            Resources   = @(
                'https://blogs.technet.microsoft.com/askpfeplat/2019/04/11/changes-to-ticket-granting-ticket-tgt-delegation-across-trusts-in-windows-server-askpfeplat-edition/'
            )
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
        }
    }
}