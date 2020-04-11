@{
    AliasesToExport      = 'Test-ImoAD', 'Test-IMO'
    Author               = 'Przemyslaw Klys'
    CompanyName          = 'Evotec'
    CompatiblePSEditions = 'Desktop'
    Copyright            = '(c) 2011 - 2020 Przemyslaw Klys @ Evotec. All rights reserved.'
    Description          = 'Testimo is Powershell module that tests Active Directory against specific set of tests.'
    FunctionsToExport    = 'Get-TestimoConfiguration', 'Get-TestimoSources', 'Import-PrivateModule', 'Invoke-Testimo'
    GUID                 = '0c1b99de-55ac-4410-8cb5-e689ff3be39b'
    ModuleVersion        = '0.0.38'
    PowerShellVersion    = '5.1'
    PrivateData          = @{
        PSData = @{
            Tags                       = 'Windows', 'ActiveDirectory', 'AD', 'Infrastructure', 'Testing', 'Checks', 'Audits', 'Checklist', 'Validation'
            ProjectUri                 = 'https://github.com/EvotecIT/Testimo'
            ExternalModuleDependencies = 'ActiveDirectory', 'GroupPolicy', 'ServerManager'
            IconUri                    = 'https://evotec.xyz/wp-content/uploads/2019/08/Testimo.png'
        }
    }
    RequiredModules      = @{
        ModuleVersion = '0.0.134'
        ModuleName    = 'PSSharedGoods'
        Guid          = 'ee272aa8-baaa-4edf-9f45-b6d6f7d844fe'
    }, @{
        ModuleVersion = '0.1.17'
        ModuleName    = 'PSWinDocumentation.AD'
        Guid          = 'a46f9775-04d2-4423-9631-01cfda42b95d'
    }, @{
        ModuleVersion = '0.0.9'
        ModuleName    = 'PSWinDocumentation.DNS'
        Guid          = '462dd5e2-f32a-4263-bff5-22edf28882d0'
    }, @{
        ModuleVersion = '1.0.14'
        ModuleName    = 'PSEventViewer'
        Guid          = '5df72a79-cdf6-4add-b38d-bcacf26fb7bc'
    }, @{
        ModuleVersion = '0.0.79'
        ModuleName    = 'PSWriteHTML'
        Guid          = 'a7bdf640-f5cb-4acf-9de0-365b322d245c'
    }, @{
        ModuleVersion = '0.0.46'
        ModuleName    = 'ADEssentials'
        Guid          = '9fc9fd61-7f11-4f4b-a527-084086f1905f'
    }, 'ActiveDirectory', 'GroupPolicy', 'ServerManager'
    RootModule           = 'Testimo.psm1'
}