$ForestDHCP = @{
    Enable          = $true
    Scope           = 'Forest'
    Source          = @{
        Name           = 'Forest DHCP'
        Data           = {
            Get-WinADDHCP
        }
        Details        = [ordered] @{
            Category    = 'Configuration'
            Description = 'DHCP is important part of any network. Having DHCP registered in AD makes sure that all computers properly register themselves in DNS automatically. However, while tempting to put DHCP on the very same server with AD and DNS it should be hosted separately. The DHCP Server service performs TCP/IP configuration for DHCP clients, including dynamic assignments of IP addresses, specification of DNS servers, and connection-specific DNS names. Domain controllers do not require the DHCP Server service to operate and for higher security and server hardening it is recommended not to install the DHCP Server role on domain controllers.'
            Importance  = 0
            ActionType  = 0
            Resources   = @(
                "[Disable or remove the DHCP Server service installed on any domain controllers](https://docs.microsoft.com/en-us/services-hub/health/remediation-steps-ad/disable-or-remove-the-dhcp-server-service-installed-on-any-domain-controllers)"
            )
            Tags        = 'DHCP', 'Configuration'
            StatusTrue  = 0
            StatusFalse = 0
        }
        ExpectedOutput = $false
    }
    Tests           = [ordered] @{
        DHCPonDC          = @{
            Enable     = $true
            Name       = 'DHCP on Domain Controller'
            Parameters = @{
                WhereObject   = { $_.IsDC -eq $true }
                ExpectedCount = 0
            }
            Details    = [ordered] @{
                Category    = 'Configuration'
                Importance  = 10
                ActionType  = 2
                StatusTrue  = 1
                StatusFalse = 5
            }
        }
        DHCPResolvesInDNS = @{
            Enable     = $true
            Name       = 'DHCP Resolves in DNS'
            Parameters = @{
                WhereObject   = { $_.IsInDNS -eq $false }
                ExpectedCount = 0
            }
            Details    = [ordered] @{
                Category    = 'Configuration'
                Importance  = 10
                ActionType  = 2
                StatusTrue  = 1
                StatusFalse = 5
            }
        }
    }
    DataDescription = {
        New-HTMLSpanStyle -FontSize 10pt {
            New-HTMLText -Text @(
                'DHCP is important part of any network. Having DHCP registered in AD makes sure that all computers properly register themselves in DNS automatically. '
                'However, while tempting to put DHCP on the very same server with AD and DNS it should be hosted separately. '
                "The DHCP Server service performs TCP/IP configuration for DHCP clients, including dynamic assignments of IP addresses, "
                "specification of DNS servers, and connection-specific DNS names. "
                "Domain controllers do not require the DHCP Server service to operate and for higher security and server hardening it is recommended not to install the DHCP Server role on domain controllers."
            )
            New-HTMLText -LineBreak
            New-HTMLText -Text @(
                'This test verifies that DHCP registed servers are registred in DNS (aka NOT DEAD) and that DHCP is not hosted on a Domain Controller.'
            )
        }
    }
    DataHighlights  = {
        New-HTMLTableCondition -Name 'IsInDNS' -ComparisonType bool -BackgroundColor PaleGreen -Value $true -Operator eq -FailBackgroundColor Salmon
        New-HTMLTableCondition -Name 'IsDC' -ComparisonType bool -BackgroundColor PaleGreen -Value $false -Operator eq -FailBackgroundColor Salmon
    }
    Solution        = {
        New-HTMLContainer {
            New-HTMLSpanStyle -FontSize 10pt {
                New-HTMLWizard {
                    New-HTMLWizardStep -Name 'Prepare DHCP service removal' {
                        New-HTMLText -Text @(
                            "The DHCP Server service performs TCP/IP configuration for DHCP clients, including dynamic assignments of IP addresses, "
                            "specification of DNS servers, and connection-specific DNS names. "
                            "Domain controllers do not require the DHCP Server service to operate and for higher security and server hardening it is recommended not to install the DHCP Server role on domain controllers."
                        )
                        New-HTMLText -LineBreak
                        New-HTMLText -Text "Prepare & send communication about DHCP removal."
                    }
                    New-HTMLWizardStep -Name 'Move DHCP service' {
                        New-HTMLText -Text @(
                            "Please make sure before removing DHCP service that you first take care of moving DHCP service to a different server/device. "
                            "Please use proper SOP that's approved for your environment!"
                        )
                    }
                    New-HTMLWizardStep -Name 'Remove DHCP service from Domain Controller' {
                        New-HTMLText -Text "Following steps give a brief overview on steps required to disable and remove DHCP service. Please make sure you follow proper SOP as depending on Windows version and environment the steps may be different."

                        New-HTMLList {
                            New-HTMLListItem -Text 'Stop the DHCP Server service and disable it'
                            New-HTMLListItem -Text 'Click Start, type Run, type services.msc, and then click OK.'
                            New-HTMLListItem -Text 'In the list of services, look for a service titled DHCP Server.'
                            New-HTMLListItem -Text 'If it exists, double-click DHCP Server.'
                            New-HTMLListItem -Text 'On the General tab, under Startup type, select Disabled.'
                            New-HTMLListItem -Text "If the Service status says ‘Running’, click Stop."
                            New-HTMLListItem -Text 'Click OK.'
                        }

                        New-HTMLText -Text 'If there are no issues after disabling DHCP - remove DHCP Service in the Server Manager.'

                        New-HTMLList {
                            New-HTMLListItem -Text 'In the Server Manager, click Manage, and then click Remove Roles and Features.'
                            New-HTMLListItem -Text 'Click Next.'
                            New-HTMLListItem -Text 'Select the local server, and click Next.'
                            New-HTMLListItem -Text 'On the Remove server roles page, uncheck the checkbox for DHCP Server.'
                            New-HTMLListItem -Text 'Click Remove Features, then click Next.'
                            New-HTMLListItem -Text 'On the Remove features page, click Next.'
                            New-HTMLListItem -Text 'Click Remove.'
                            New-HTMLListItem -Text 'When the removal is complete, click Close.'
                        }

                        New-HTMLText -Text 'Repeat these steps for all affected domain controllers.'
                    }
                } -RemoveDoneStepOnNavigateBack -Theme arrows -ToolbarButtonPosition center -EnableAllAnchors
            }
        }
    }
}