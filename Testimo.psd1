@{
    AliasesToExport      = @('Test-ImoAD', 'Test-IMO')
    Author               = 'Przemyslaw Klys'
    CmdletsToExport      = @()
    CompanyName          = 'Evotec'
    CompatiblePSEditions = @('Desktop')
    Copyright            = '(c) 2011 - 2022 Przemyslaw Klys @ Evotec. All rights reserved.'
    Description          = 'Testimo is Powershell module that tests Active Directory against specific set of tests.'
    FunctionsToExport    = @('Compare-Testimo', 'Get-TestimoConfiguration', 'Get-TestimoSources', 'Import-PrivateModule', 'Invoke-Testimo')
    GUID                 = '0c1b99de-55ac-4410-8cb5-e689ff3be39b'
    ModuleVersion        = '0.0.79'
    PowerShellVersion    = '5.1'
    PrivateData          = @{
        PSData = @{
            Tags                       = @('Windows', 'ActiveDirectory', 'AD', 'Infrastructure', 'Testing', 'Checks', 'Audits', 'Checklist', 'Validation')
            ProjectUri                 = 'https://github.com/EvotecIT/Testimo'
            IconUri                    = 'https://evotec.xyz/wp-content/uploads/2019/08/Testimo.png'
            ExternalModuleDependencies = @('ActiveDirectory', 'GroupPolicy', 'ServerManager')
        }
    }
    RequiredModules      = @(@{
            ModuleVersion = '0.0.228'
            ModuleName    = 'PSSharedGoods'
            Guid          = 'ee272aa8-baaa-4edf-9f45-b6d6f7d844fe'
        }, @{
            ModuleVersion = '0.0.10'
            ModuleName    = 'PSWinDocumentation.DNS'
            Guid          = '462dd5e2-f32a-4263-bff5-22edf28882d0'
        }, @{
            ModuleVersion = '1.0.22'
            ModuleName    = 'PSEventViewer'
            Guid          = '5df72a79-cdf6-4add-b38d-bcacf26fb7bc'
        }, @{
            ModuleVersion = '0.0.174'
            ModuleName    = 'PSWriteHTML'
            Guid          = 'a7bdf640-f5cb-4acf-9de0-365b322d245c'
        }, @{
            ModuleVersion = '0.0.141'
            ModuleName    = 'ADEssentials'
            Guid          = '9fc9fd61-7f11-4f4b-a527-084086f1905f'
        }, @{
            ModuleVersion = '0.0.150'
            ModuleName    = 'GPOZaurr'
            Guid          = 'f7d4c9e4-0298-4f51-ad77-e8e3febebbde'
        }, @{
            ModuleVersion = '0.87.3'
            ModuleName    = 'PSWriteColor'
            Guid          = '0b0ba5c5-ec85-4c2b-a718-874e55a8bc3f'
        }, 'ActiveDirectory', 'GroupPolicy', 'ServerManager')
    RootModule           = 'Testimo.psm1'
}