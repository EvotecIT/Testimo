$DuplicateSPN = @{
    Name            = 'ForestDuplicateSPN'
    Enable          = $true
    Scope           = 'Forest'
    Source          = @{
        Name           = 'Duplicate SPN'
        Data           = {
            Get-WinADDuplicateSPN -Forest $ForestName
        }
        Details        = [ordered] @{
            Category    = 'Security'
            Description = "SPNs must be unique, so if an SPN already exists for a service on a server then you must delete the SPN that is is already registered to one account and recreate the SPN registered to the correct account."
            Importance  = 5
            ActionType  = 1
            Resources   = @(
                "[Duplicate SPN found - Troubleshooting Duplicate SPNs](https://support.squaredup.com/hc/en-us/articles/4406616176657-Duplicate-SPN-found-Troubleshooting-Duplicate-SPNs)"
                "[SPN and UPN uniqueness](https://docs.microsoft.com/en-us/windows-server/identity/ad-ds/manage/component-updates/spn-and-upn-uniqueness)"
                "[Name Formats for Unique SPNs](https://docs.microsoft.com/en-us/windows/win32/ad/name-formats-for-unique-spns)"
                "[Kerberos - duplicate SPNs](https://itworldjd.wordpress.com/2017/02/15/kerberos-duplicate-spns/)"
            )
            StatusTrue  = 0
            StatusFalse = 5
        }
        ExpectedOutput = $false
    }
    DataDescription = {
        New-HTMLSpanStyle -FontSize 10pt {
            New-HTMLText -Text @(
                'Services use service publication in the Active Directory directory service to provide information about themselves in the directory for easy discovery by client applications and other services. '
                'Service publication occurs when the installation program for a service publishes information about the service, including binding and keyword data, to the directory. '
                'Service publication happens by creating service objects (also called connection point objects) in Active Directory. '
            )
            New-HTMLText -Text @(
                'In addition, Active Directory supports service principal names (SPNs) as a means by which client applications can identify '
                'and authenticate the services that they use. Service authentication happens through Kerberos authentication of SPNs. '
                'Kerberos uses SPNs extensively. When a Kerberos client uses its TGT to request a service ticket for a specific service, the service uses SPN to identify it. '
                'The KDC will grant the client a service ticket that is encrypted in part with a shared secret '
                'that the service account identified by the AD account matches the SPN has (basically the account password). '
            )
            New-HTMLText -Text @(
                'In the case of a duplicate SPN, what can happen is that the KDC will generate a service ticket that may base its shared secret on the wrong account. '
                'Then, when the client provides that ticket to the service during authentication, the service itself cannot decrypt it, and the authentication fails. '
                'The server will typically log an "AP Modified" error, and the client will see a "wrong principal" error code.'
            )
        }
    }
    DataInformation = {
        New-HTMLText -Text 'Explanation to table columns:' -FontSize 10pt
        New-HTMLList {
            New-HTMLListItem -FontWeight bold, normal -Text "IsOrphaned", " - means object contains AdminCount set to 1, while not being a critical object or direct or indirect member of any critical system groups. "
            New-HTMLListItem -FontWeight bold, normal -Text "IsMember", " - means object is memberof (direct or indirect) of critical system groups. "
            New-HTMLListItem -FontWeight bold, normal -Text "IsCriticalSystemObject", " - means object is critical system object. "
        } -FontSize 10pt
    }
    DataHighlights  = {
        # New-HTMLTableCondition -Name 'IsOrphaned' -ComparisonType string -BackgroundColor Salmon -Value $true
        # New-HTMLTableCondition -Name 'IsOrphaned' -ComparisonType string -BackgroundColor PaleGreen -Value $false
        # New-HTMLTableCondition -Name 'IsCriticalSystemObject' -ComparisonType string -BackgroundColor PaleGreen -Value $true
        # New-HTMLTableCondition -Name 'IsCriticalSystemObject' -ComparisonType string -BackgroundColor TangerineYellow -Value $false
    }
}