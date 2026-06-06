$SecurityPreAuth = @{
    Name            = 'DomainSecurityPreAuth'
    Enable          = $true
    Scope           = 'Domain'
    Source          = @{
        Name           = "Security: Kerberos Pre-Authentication disabled (AS-REP Roasting)"
        Data           = {
            Get-ADUser -Filter "DoesNotRequirePreAuth -eq `$true" -Properties Name, Enabled, DoesNotRequirePreAuth, Created, Modified, LastLogonDate, PasswordLastSet -Server $Domain | Select-Object Name, Enabled, DoesNotRequirePreAuth, Created, Modified, LastLogonDate, PasswordLastSet
        }
        Details        = [ordered] @{
            Category    = 'Security'
            Importance  = 10
            ActionType  = 1
            Description = 'Accounts that do not require Kerberos Pre-Authentication are vulnerable to AS-REP Roasting. An attacker can request a Ticket Granting Ticket (TGT) for these accounts and capture their encrypted password hash, which can then be cracked offline.'
            Resources   = @(
                '[Kerberos Pre-Authentication - Why It Should Not Be Disabled](https://stealthbits.com/blog/kerberos-pre-authentication-why-it-should-not-be-disabled/)'
                '[AS-REP Roasting - Attacking Active Directory](https://adsecurity.org/?p=3458)'
                '[Mitigating AS-REP Roasting Attacks](https://www.netwrix.com/how_to_detect_and_prevent_as_rep_roasting.html)'
            )
            StatusTrue  = 0
            StatusFalse = 0
        }
        ExpectedOutput = $true
    }
    Tests           = [ordered] @{
        NoAccountsWithoutPreAuth = @{
            Enable      = $true
            Name        = 'No active accounts should have Kerberos Pre-Authentication disabled'
            Parameters  = @{
                WhereObject   = { $_.Enabled -eq $true }
                ExpectedCount = 0
                OperationType = 'eq'
            }
            Details     = [ordered] @{
                Category    = 'Security'
                Importance  = 10
                ActionType  = 2
                StatusTrue  = 1
                StatusFalse = 5
            }
            Description = 'There should be exactly 0 active accounts with Kerberos Pre-Authentication disabled.'
        }
    }
    DataInformation = {
        New-HTMLText -Text 'Explanation of findings:' -FontSize 10pt
        New-HTMLList {
            New-HTMLListItem -FontWeight bold, normal -Text "DoesNotRequirePreAuth", " - Indicates whether the UserAccountControl flag DONT_REQUIRE_PREAUTH is set."
            New-HTMLListItem -FontWeight bold, normal -Text "AS-REP Roasting", " - If enabled, these users are exposed to offline password cracking."
        } -FontSize 10pt
    }
    DataHighlights  = {
        New-HTMLTableCondition -Name 'Enabled' -ComparisonType string -BackgroundColor PaleGreen -Value $false -Operator eq -FailBackgroundColor Salmon
    }
}
