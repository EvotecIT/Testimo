BeforeAll {
    . "$PSScriptRoot\..\Private\Test-TestimoEventLogAllowRights.ps1"
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
