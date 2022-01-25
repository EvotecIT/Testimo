$DomainLDAP = @{
    Name            = 'DomainLDAP'
    Enable          = $true
    Scope           = 'Domain'
    Source          = @{
        Name           = 'LDAP Connectivity'
        Data           = {
            Test-LDAP -Forest $ForestName -IncludeDomains $Domain -SkipRODC:$SkipRODC -WarningAction SilentlyContinue -VerifyCertificate
        }
        Details        = [ordered] @{
            Category    = 'Health'
            Description = 'Domain Controllers require certain ports to be open, and serving proper certificate for SSL connectivity. '
            Importance  = 0
            ActionType  = 0
            Resources   = @(
                "[Testing LDAP and LDAPS connectivity with PowerShell](https://evotec.xyz/testing-ldap-and-ldaps-connectivity-with-powershell/)"
                "[2020 LDAP channel binding and LDAP signing requirements for Windows](https://support.microsoft.com/en-us/topic/2020-ldap-channel-binding-and-ldap-signing-requirements-for-windows-ef185fb8-00f7-167d-744c-f299a66fc00a)"
            )
            StatusTrue  = 0
            StatusFalse = 0
        }
        ExpectedOutput = $true
    }
    Tests           = [ordered] @{
        PortLDAP                 = @{
            Enable     = $true
            Name       = 'LDAP Port is Available'
            Parameters = @{
                ExpectedCount = 0
                OperationType = 'eq'
                WhereObject   = { $_.LDAP -eq $false }
            }
            Details    = [ordered] @{
                Category    = 'Health'
                Importance  = 10
                ActionType  = 2
                StatusTrue  = 1
                StatusFalse = 3
            }
        }
        PortLDAPS                = @{
            Enable     = $true
            Name       = 'LDAP SSL Port is Available'
            Parameters = @{
                ExpectedCount = 0
                OperationType = 'eq'
                WhereObject   = { $_.LDAPS -eq $false }
            }
            Details    = [ordered] @{
                Category    = 'Health'
                Importance  = 10
                ActionType  = 2
                StatusTrue  = 1
                StatusFalse = 4
            }
        }
        PortLDAP_GC              = @{
            Enable     = $true
            Name       = 'LDAP GC Port is Available'
            Parameters = @{
                ExpectedCount = 0
                OperationType = 'eq'
                WhereObject   = { $_.GlobalCatalogLDAP -eq $false }
            }
            Details    = [ordered] @{
                Category    = 'Health'
                Importance  = 10
                ActionType  = 2
                StatusTrue  = 1
                StatusFalse = 4
            }
        }
        PortLDAPS_GC             = @{
            Enable     = $true
            Name       = 'LDAP SSL GC Port is Available'
            Parameters = @{
                ExpectedCount = 0
                OperationType = 'eq'
                WhereObject   = { $_.GlobalCatalogLDAPS -eq $false }
            }
            Details    = [ordered] @{
                Category    = 'Health'
                Importance  = 10
                ActionType  = 2
                StatusTrue  = 1
                StatusFalse = 4
            }
        }
        BindLDAPS                = @{
            Enable     = $true
            Name       = 'LDAP SSL Bind available'
            Parameters = @{
                ExpectedCount = 0
                OperationType = 'eq'
                WhereObject   = { $_.LDAPSBind -eq $false }
            }
            Details    = [ordered] @{
                Category    = 'Health'
                Importance  = 10
                ActionType  = 2
                StatusTrue  = 1
                StatusFalse = 4
            }
        }
        BindLDAPS_GC             = @{
            Enable     = $true
            Name       = 'LDAP SSL GC Bind is Available'
            Parameters = @{
                ExpectedCount = 0
                OperationType = 'eq'
                WhereObject   = { $_.GlobalCatalogLDAPSBind -eq $false }
            }
            Details    = [ordered] @{
                Category    = 'Health'
                Importance  = 10
                ActionType  = 2
                StatusTrue  = 1
                StatusFalse = 4
            }
        }
        X509NotBeforeDays        = @{
            Enable     = $true
            Name       = 'Not Before Days should be less/equal 0'
            Parameters = @{
                ExpectedCount = 0
                OperationType = 'eq'
                WhereObject   = { $_.X509NotBeforeDays -gt 0 }
            }
            Details    = [ordered] @{
                Category    = 'Health'
                Importance  = 10
                ActionType  = 2
                StatusTrue  = 1
                StatusFalse = 4
            }
        }
        X509NotAfterDaysWarning  = @{
            Enable     = $true
            Name       = 'Not After Days should be more than 10 days'
            Parameters = @{
                ExpectedCount = 0
                OperationType = 'eq'
                WhereObject   = { $_.X509NotAfterDays -lt 10 }
            }
            Details    = [ordered] @{
                Category    = 'Health'
                Importance  = 10
                ActionType  = 1
                StatusTrue  = 1
                StatusFalse = 4
            }
        }
        X509NotAfterDaysCritical = @{
            Enable     = $true
            Name       = 'Not After Days should be more than 0 days'
            Parameters = @{
                ExpectedCount = 0
                OperationType = 'eq'
                WhereObject   = { $_.X509NotAfterDays -lt 0 }
            }
            Details    = [ordered] @{
                Category    = 'Health'
                Importance  = 10
                ActionType  = 2
                StatusTrue  = 1
                StatusFalse = 4
            }
        }
    }
    DataDescription = {
        New-HTMLSpanStyle -FontSize 10pt {
            New-HTMLText -Text @(
                'Domain Controllers require certain ports for LDAP connectivity to be open, and serving proper certificate for SSL connectivity. '
                'Following ports are required to be available: '
            )
            New-HTMLList {
                New-HTMLListItem -Text 'LDAP port 389'
                New-HTMLListItem -Text 'LDAP SSL port 636'
                New-HTMLListItem -Text 'LDAP Global Catalog port 3268'
                New-HTMLListItem -Text 'LDAP Global Catalog SLL port 3269'
            }
            New-HTMLText -Text @(
                "If any/all of those ports are unavailable for any of the Domain Controllers "
                "it means that either DC is not available from location it's getting tested from ("
                "$Env:COMPUTERNAME"
                ") or those ports are down, or DC doesn't have a proper certificate installed. "
                "Please make sure to verify Domain Controllers that are reporting errors and talk to network team if required to make sure "
                "proper ports are open thru firewall. "
            ) -Color None, None, BilobaFlower, None, None, None
        }
    }
    DataHighlights  = {
        New-HTMLTableCondition -Name 'GlobalCatalogLDAP' -ComparisonType string -BackgroundColor PaleGreen -Value $true -Operator eq
        New-HTMLTableCondition -Name 'GlobalCatalogLDAP' -ComparisonType string -BackgroundColor Salmon -Value $false -Operator eq
        New-HTMLTableCondition -Name 'GlobalCatalogLDAPS' -ComparisonType string -BackgroundColor PaleGreen -Value $true -Operator eq
        New-HTMLTableCondition -Name 'GlobalCatalogLDAPS' -ComparisonType string -BackgroundColor Salmon -Value $false -Operator eq
        New-HTMLTableCondition -Name 'GlobalCatalogLDAPSBind' -ComparisonType string -BackgroundColor PaleGreen -Value $true -Operator eq
        New-HTMLTableCondition -Name 'GlobalCatalogLDAPSBind' -ComparisonType string -BackgroundColor Salmon -Value $false -Operator eq
        New-HTMLTableCondition -Name 'LDAP' -ComparisonType string -BackgroundColor PaleGreen -Value $true -Operator eq
        New-HTMLTableCondition -Name 'LDAP' -ComparisonType string -BackgroundColor Salmon -Value $false -Operator eq
        New-HTMLTableCondition -Name 'LDAPS' -ComparisonType string -BackgroundColor PaleGreen -Value $true -Operator eq
        New-HTMLTableCondition -Name 'LDAPS' -ComparisonType string -BackgroundColor Salmon -Value $false -Operator eq
        New-HTMLTableCondition -Name 'LDAPSBind' -ComparisonType string -BackgroundColor PaleGreen -Value $true -Operator eq
        New-HTMLTableCondition -Name 'LDAPSBind' -ComparisonType string -BackgroundColor Salmon -Value $false -Operator eq
        New-HTMLTableCondition -Name 'X509NotBeforeDays' -ComparisonType number -BackgroundColor PaleGreen -Value 0 -Operator le
        New-HTMLTableCondition -Name 'X509NotBeforeDays' -ComparisonType number -BackgroundColor Salmon -Value 0 -Operator gt
        New-HTMLTableCondition -Name 'X509NotAfterDays' -ComparisonType number -BackgroundColor PaleGreen -Value 0 -Operator gt
        New-HTMLTableCondition -Name 'X509NotAfterDays' -ComparisonType number -BackgroundColor Salmon -Value 0 -Operator lt
    }
}