$Trusts = @{
    Enable = $true
    Source = @{
        Name = "Trust Availability"
        Data = {
            $ADModule = Import-Module PSWinDocumentation.AD -PassThru
            & $ADModule {
                param($Domain);
                Get-WinADDomainTrusts -Domain $Domain
            } -Domain $Domain
        }
        Details = [ordered] @{
            Area             = ''
            Explanation      = ''
            Recommendation   = ''
            RiskLevel        = 10
            RecommendedLinks = @(

            )
        }
    }
    Tests  = [ordered] @{
        TrustsConnectivity            = @{
            Enable     = $true
            Name       = 'Trust status verification'
            Parameters = @{
                OverwriteName = { "Trust status verification | Source $Domain, Target $($_.'Trust Target'), Direction $($_.'Trust Direction')" }
                Property      = 'Trust Status'
                ExpectedValue = 'OK'
                OperationType = 'eq'
            }
        }
        TrustsUnconstrainedDelegation = @{
            Enable     = $true
            Name       = 'Trust unconstrained TGTDelegation'
            Parameters = @{
                OverwriteName = { "Trust unconstrained TGTDelegation | Source $Domain, Target $($_.'Trust Target'), Direction $($_.'Trust Direction')" }
                WhereObject   = { $($_.'Trust Direction' -eq 'BiDirectional' -or $_.'Trust Direction' -eq 'InBound') }
                Property      = 'TGTDelegation'
                ExpectedValue = $True
                OperationType = 'eq'
            }
        }
    }
}

# TGTDelegation as per https://blogs.technet.microsoft.com/askpfeplat/2019/04/11/changes-to-ticket-granting-ticket-tgt-delegation-across-trusts-in-windows-server-askpfeplat-edition/
# TGTDelegation should be set to $True (contrary to name)