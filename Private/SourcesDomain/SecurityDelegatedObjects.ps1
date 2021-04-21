$DomainSecurityDelegatedObjects = @{
    Enable          = $true
    Scope           = 'Domain'
    Source          = @{
        Name           = "Security: Delegated Objects"
        Data           = {
            Get-WinADDelegatedAccounts -Forest $ForestName -IncludeDomains $Domain
        }
        Details        = [ordered] @{
            Category    = 'Security', 'Cleanup'
            Importance  = 0
            ActionType  = 0
            Description = ''
            Resources   = @(
                '[What is KERBEROS DELEGATION? An overview of kerberos delegation](https://stealthbits.com/blog/what-is-kerberos-delegation-an-overview-of-kerberos-delegation/)'
            )
            StatusTrue  = 1
            StatusFalse = 0
        }
        ExpectedOutput = $false
    }
    Tests           = [ordered] @{
        FullDelegation = @{
            Enable      = $true
            Name        = 'There should be no full delegation'
            Parameters  = @{
                WhereObject    = { $_.FullDelegation -eq $true -and $_.IsDC -eq $false }
                ExpectedCount  = 0
                OperationType  = 'eq'
                ExpectedOutput = $false
            }
            Details     = [ordered] @{
                Category    = 'Security'
                Importance  = 9
                ActionType  = 2
                StatusTrue  = 1
                StatusFalse = 5
            }
            Description = ""
        }
    }
    DataDescription = {
        New-HTMLSpanStyle -FontSize 10pt {
            New-HTMLText -Text @(
                "There are a few flavors of Kerberos delegation since it has evolved over the years. The original implementation is unconstrained delegation, this was what existed in Windows Server 2000. Since then, more strict versions of delegation have come along. Constrained delegation, which was available in Windows Server 2003, and Resource-Based Constrained delegation which was made available in 2012, both have improved the security and implementation of Kerberos delegation. "
                "Those settings are: "
            )
            New-HTMLList {
                New-HTMLListItem -Text "Unconstrained (Full) delegation ", " is most When a privileged account authenticates to a host with unconstrained delegation configured, you now can access any configured service within the domain as that privileged user. " -FontWeight bold, normal
                New-HTMLListItem -Text "Constrained delegation ", " takes it a step further by allowing you to configure which services an account can be delegated to. This, in theory, would limit the potential exposure if a compromise occurred." -FontWeight bold, normal
                New-HTMLListItem -Text "Resource-Based Constrained Delegation ", " changes how you can configure constrained delegation, and it will work across a trust. Instead of specifying which object can delegate to which service, the resource hosting the service specifies which objects can delegate to it. From an administrative standpoint, this allows the resource owner to control who can access it. " -FontWeight bold, normal
            }
            New-HTMLText -Text @(
                "It's important that there are no objects with unconstrained delegation anywhere else than on Domain Controller objects."
            )
        }
    }
    DataHighlights  = {
        New-HTMLTableConditionGroup {
            New-HTMLTableCondition -Name 'IsDC' -ComparisonType string -Value $true -Operator eq
            New-HTMLTableCondition -Name 'FullDelegation' -ComparisonType string -Value $true -Operator eq
        } -BackgroundColor PaleGreen -HighlightHeaders IsDC, FullDelegation
        New-HTMLTableConditionGroup {
            New-HTMLTableCondition -Name 'IsDC' -ComparisonType string -Value $false -Operator eq
            New-HTMLTableCondition -Name 'FullDelegation' -ComparisonType string -Value $true -Operator eq
        } -BackgroundColor Salmon -HighlightHeaders IsDC, FullDelegation

        New-HTMLTableConditionGroup {
            New-HTMLTableCondition -Name 'IsDC' -ComparisonType string -Value $false -Operator eq
            New-HTMLTableCondition -Name 'FullDelegation' -ComparisonType string -Value $false -Operator eq
        } -BackgroundColor PaleGreen -HighlightHeaders IsDC, FullDelegation

        New-HTMLTableCondition -Name 'Enabled' -ComparisonType string -BackgroundColor PaleGreen -Value $true -Operator eq -FailBackgroundColor Salmon
        New-HTMLTableCondition -Name 'PasswordLastSet' -ComparisonType date -BackgroundColor PaleGreen -Value (Get-Date).AddDays(-180) -Operator gt -FailBackgroundColor Salmon -DateTimeFormat 'DD.MM.YYYY HH:mm:ss'
        New-HTMLTableCondition -Name 'LastLogonDate' -ComparisonType date -BackgroundColor PaleGreen -Value (Get-Date).AddDays(-180) -Operator gt -FailBackgroundColor Salmon -DateTimeFormat 'DD.MM.YYYY HH:mm:ss'
    }
    DataInformation = {

    }
}