Import-Module .\Testimo.psd1 -Force

$Object3 = [PSCustomObject] @{
    "Name"    = "Przemyslaw Klys"
    "Age"     = "30"
    "Address" = @{
        "Street"  = "Kwiatowa"
        "City"    = "Warszawa"

        "Country" = [ordered] @{
            "Name" = "Poland"
        }
        List      = @(
            [PSCustomObject] @{
                "Name" = "Adam Klys"
                "Age"  = "32"
            }
            [PSCustomObject] @{
                "Name" = "Justyna Klys"
                "Age"  = "33"
            }
        )
    }
    ListTest  = @(
        [PSCustomObject] @{
            "Name" = "Justyna Klys"
            "Age"  = "33"
        }
    )
}

$Object4 = [PSCustomObject] @{
    "Name"    = "Przemyslaw Klys"
    "Age"     = "30"
    "Address" = @{
        "Street"  = "Kwiatowa"
        "City"    = "Warszawa"
        "Country" = [ordered] @{
            "Name" = "Gruzja"
        }
        List      = @(
            [PSCustomObject] @{
                "Name" = "Adam Klys"
                "Age"  = "32"
            }
            [PSCustomObject] @{
                "Name" = "Pankracy Klys"
                "Age"  = "33"
            }
            [PSCustomObject] @{
                "Name" = "Justyna Klys"
                "Age"  = 30
            }
            [PSCustomObject] @{
                "Name" = "Justyna Klys"
                "Age"  = $null
            }
        )
    }
    ListTest  = @(
        [PSCustomObject] @{
            "Name" = "Sława Klys"
            "Age"  = "33"
        }
    )
    MoreProperties = $true
}

Invoke-Testimo -Sources 'DSC','CSEnrollMentRestrictions' {
    Compare-Testimo -Name 'CSEnrollMentRestrictions' -Scope 'Intune' -BaseLineSourcePath "C:\Users\przemyslaw.klys\OneDrive - Evotec\Desktop\Comparison of Intune configuration\Enrollment restrictions\CS_Enrollment_Restrictions.json" -BaseLineTargetPath "C:\Users\przemyslaw.klys\OneDrive - Evotec\Desktop\Comparison of Intune configuration\Enrollment restrictions\CS_Enrollment_Restrictions (1).json"
    Compare-Testimo -Name 'DSC' -Scope 'O365' -BaseLineSourcePath "C:\Users\przemyslaw.klys\OneDrive - Evotec\Desktop\Comparison of Intune configuration\Enrollment restrictions\CS_Enrollment_Restrictions.json" -BaseLineTargetPath "C:\Support\GitHub\Testimo\Ignore\m365\M365TenantConfig.ps1"

    #Compare-Testimo -Name 'IntuneBaseLine' -Scope 'Intune' -BaseLineSource $Object3 -BaseLineTarget $Object4
}