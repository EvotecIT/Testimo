BeforeAll {
    . "$PSScriptRoot\..\Private\Test-TestimoEventLogAllowRights.ps1"
    . "$PSScriptRoot\..\Private\Get-TestimoEventLogDetails.ps1"
    function Get-EVXLog { }
}

Describe 'Testimo event-log access policy' {
    It 'recognizes an explicit read-and-clear allow ACE by SID and native rights' {
        $rules = @(
            [pscustomobject]@{ TrusteeSid = 'S-1-5-18'; IsAllow = $true; AccessMask = 0xf0005 }
        )

        Test-TestimoEventLogAllowRights -AccessRules $rules -TrusteeSid 'S-1-5-18' -RequiredRights 5 |
            Should -BeTrue
    }

    It 'combines separate allow entries for the same trustee' {
        $rules = @(
            [pscustomobject]@{ TrusteeSid = 'S-1-5-18'; IsAllow = $true; AccessMask = 1 }
            [pscustomobject]@{ TrusteeSid = 'S-1-5-18'; IsAllow = $true; AccessMask = 4 }
        )

        Test-TestimoEventLogAllowRights -AccessRules $rules -TrusteeSid 'S-1-5-18' -RequiredRights 5 |
            Should -BeTrue
    }

    It 'does not treat a deny ACE or a different trustee as an explicit allow' {
        $rules = @(
            [pscustomobject]@{ TrusteeSid = 'S-1-5-18'; IsAllow = $false; AccessMask = 5 }
            [pscustomobject]@{ TrusteeSid = 'S-1-5-32-544'; IsAllow = $true; AccessMask = 5 }
        )

        Test-TestimoEventLogAllowRights -AccessRules $rules -TrusteeSid 'S-1-5-18' -RequiredRights 5 |
            Should -BeFalse
    }

    It 'does not report a partial mask or unavailable ACL as passing' {
        $rules = @([pscustomobject]@{ TrusteeSid = 'S-1-5-18'; IsAllow = $true; AccessMask = 1 })

        Test-TestimoEventLogAllowRights -AccessRules $rules -TrusteeSid 'S-1-5-18' -RequiredRights 5 |
            Should -BeFalse
        Test-TestimoEventLogAllowRights -AccessRules $null -TrusteeSid 'S-1-5-18' -RequiredRights 5 |
            Should -BeFalse
    }
}

Describe 'Testimo event-log result handling' {
    It 'returns complete details without changing their values' {
        Mock Get-EVXLog {
            [pscustomobject]@{
                Status            = 'Success'
                Details           = [pscustomobject]@{ LogName = 'Security'; FileSizeCurrentMB = 12 }
                DiagnosticMessage = ''
            }
        }

        $details = @(Get-TestimoEventLogDetails -MachineName 'dc.example.test')
        $details.Count | Should -Be 1
        $details[0].FileSizeCurrentMB | Should -Be 12
    }

    It 'does not turn incomplete FileSize evidence into a healthy zero' {
        Mock Get-EVXLog {
            [pscustomobject]@{
                Status            = 'LogInformationUnavailable'
                Details           = [pscustomobject]@{ LogName = 'Security'; FileSizeCurrentMB = 0 }
                DiagnosticMessage = 'FileSize could not be read'
            }
        }

        $warnings = $null
        $details = @(Get-TestimoEventLogDetails -MachineName 'dc.example.test' -WarningAction SilentlyContinue -WarningVariable warnings)
        $details.Count | Should -Be 0
        $warnings[0].ToString() | Should -BeLike '*FileSize could not be read*'
    }
}

Describe 'Saved event-log configuration compatibility' {
    BeforeAll {
        . "$PSScriptRoot\..\Private\SourcesDomainControllers\EventLogs.ps1"
        . "$PSScriptRoot\..\Private\Import-TestimoConfiguration.ps1"
        function Out-Informative { }
    }

    It 'retains the pre-v4 ACL rule IDs for saved configurations' {
        $legacyIds = @(
            'SecurityPermissionsDefaultNetworkService',
            'SecurityPermissionsDefaultSYSTEM',
            'SecurityPermissionsNDefaultBuiltinAdministrators',
            'SecurityPermissionsDefaultBuiltinEventLogReaders'
        )
        foreach ($id in $legacyIds) {
            $EventLogs.Tests.Contains($id) | Should -BeTrue
        }
    }

    It 'applies a saved ACL rule override to the migrated policy' {
        $Script:TestimoConfiguration = @{
            ActiveDirectory = @{ DCEventLogs = $EventLogs }
            Office365       = @{}
        }
        $saved = @{
            DCEventLogs = @{
                Enable = $true
                Tests  = @{
                    SecurityPermissionsDefaultNetworkService = @{
                        Enable = $true
                        Parameters = @{ ExpectedCount = 2 }
                    }
                }
            }
        }

        { Import-TestimoConfiguration -Configuration $saved } | Should -Not -Throw
        $Script:TestimoConfiguration.ActiveDirectory.DCEventLogs.Tests.SecurityPermissionsDefaultNetworkService.Enable | Should -BeTrue
        $Script:TestimoConfiguration.ActiveDirectory.DCEventLogs.Tests.SecurityPermissionsDefaultNetworkService.Parameters.ExpectedCount | Should -Be 2
    }

    It 'applies the same legacy ACL rule from an exported JSON configuration' {
        $Script:TestimoConfiguration = @{
            ActiveDirectory = @{ DCEventLogs = $EventLogs }
            Office365       = @{}
        }
        $savedJson = '{"DCEventLogs":{"Enable":true,"Tests":{"SecurityPermissionsDefaultSYSTEM":{"Enable":false}}}}'

        { Import-TestimoConfiguration -Configuration $savedJson } | Should -Not -Throw
        $Script:TestimoConfiguration.ActiveDirectory.DCEventLogs.Tests.SecurityPermissionsDefaultSYSTEM.Enable | Should -BeFalse
    }
}
