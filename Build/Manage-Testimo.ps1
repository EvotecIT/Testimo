param(
    [ValidateSet('Manifest', 'Build', 'Publish')]
    [string] $RunMode = 'Build',
    [bool] $SignModule = $false,
    [switch] $SkipInstall,
    [string] $PowerShellGalleryApiKeyPath = 'C:\Support\Important\PowerShellGalleryAPI.txt',
    [string] $GitHubApiKeyPath = 'C:\Support\Important\GitHubAPI.txt'
)

Import-Module PSPublishModule -Force -ErrorAction Stop

Build-Module -ModuleName 'Testimo' -RunMode $RunMode -SkipInstall:$SkipInstall -ExitCode {
    # Usual defaults as per standard module
    $Manifest = [ordered] @{
        # Version number of this module.
        ModuleVersion        = '0.0.X'
        # Supported PSEditions
        CompatiblePSEditions = @('Desktop')
        # ID used to uniquely identify this module
        GUID                 = '0c1b99de-55ac-4410-8cb5-e689ff3be39b'
        # Author of this module
        Author               = 'Przemyslaw Klys'
        # Company or vendor of this module
        CompanyName          = 'Evotec'
        # Copyright statement for this module
        Copyright            = "(c) 2011 - $((Get-Date).Year) Przemyslaw Klys @ Evotec. All rights reserved."
        # Description of the functionality provided by this module
        Description          = 'Testimo is Powershell module that tests Active Directory against specific set of tests.'
        # Minimum version of the Windows PowerShell engine required by this module
        PowerShellVersion    = '5.1'
        # Private data to pass to the module specified in RootModule/ModuleToProcess. This may also contain a PSData hashtable with additional module metadata used by PowerShell.
        Tags                 = @('Windows', 'ActiveDirectory', 'AD', 'Infrastructure', 'Testing', 'Checks', 'Audits', 'Checklist', 'Validation')

        IconUri              = 'https://evotec.xyz/wp-content/uploads/2019/08/Testimo.png'

        ProjectUri           = 'https://github.com/EvotecIT/Testimo'
    }
    New-ConfigurationManifest @Manifest

    New-ConfigurationModule -Type RequiredModule -Name 'PSSharedGoods' -MinimumVersion '0.0.303' -Guid 'ee272aa8-baaa-4edf-9f45-b6d6f7d844fe'
    New-ConfigurationModule -Type RequiredModule -Name 'PSEventViewer' -MinimumVersion '4.0.0' -Guid '5df72a79-cdf6-4add-b38d-bcacf26fb7bc'
    New-ConfigurationModule -Type RequiredModule -Name 'PSWriteHTML' -MinimumVersion '1.28.0' -Guid 'a7bdf640-f5cb-4acf-9de0-365b322d245c'
    New-ConfigurationModule -Type RequiredModule -Name 'GPOZaurr' -MinimumVersion '1.1.9' -Guid 'f7d4c9e4-0298-4f51-ad77-e8e3febebbde'
    New-ConfigurationModule -Type RequiredModule -Name 'PSWriteColor' -MinimumVersion '1.0.3' -Guid '0b0ba5c5-ec85-4c2b-a718-874e55a8bc3f'
    New-ConfigurationModule -Type RequiredModule -Name 'ADEssentials' -MinimumVersion '0.0.230' -Guid '9fc9fd61-7f11-4f4b-a527-084086f1905f'
    New-ConfigurationModule -Type ApprovedModule -Name 'PSWriteColor', 'Connectimo', 'PSUnifi', 'PSWebToolbox', 'PSMyPassword'
    #New-ConfigurationModule -Type ExternalModule -Name 'ActiveDirectory', 'GroupPolicy', 'ServerManager'
    New-ConfigurationModuleSkip -IgnoreFunctionName @(
        'ConvertTo-DSCObject'
        'Compare-TwoArrays'
        'Select-Unique'
        # ADEssentials exports these only when the optional DnsServer module is available.
        'Get-WinADDnsServerForwarder'
        'Get-WinADDnsServerScavenging'
        'Get-WinDnsServerZones'
        'Test-DNSNameServers'
    ) -IgnoreModuleName @(
        'ServerManager'
        'Kds'
        'ActiveDirectory', 'GroupPolicy', 'ServerManager'
        'NetConnection', 'NetSecurity', 'NetTCPIP', 'powershellget'
        'DnsClient'
        'Microsoft.PowerShell.Management', 'Microsoft.PowerShell.Utility', 'Microsoft.WSMan.Management'
        'SmbShare', 'Dism'
    )

    $ConfigurationFormat = [ordered] @{
        RemoveComments                              = $false

        PlaceOpenBraceEnable                        = $true
        PlaceOpenBraceOnSameLine                    = $true
        PlaceOpenBraceNewLineAfter                  = $true
        PlaceOpenBraceIgnoreOneLineBlock            = $false

        PlaceCloseBraceEnable                       = $true
        PlaceCloseBraceNewLineAfter                 = $true
        PlaceCloseBraceIgnoreOneLineBlock           = $false
        PlaceCloseBraceNoEmptyLineBefore            = $true

        UseConsistentIndentationEnable              = $true
        UseConsistentIndentationKind                = 'space'
        UseConsistentIndentationPipelineIndentation = 'IncreaseIndentationAfterEveryPipeline'
        UseConsistentIndentationIndentationSize     = 4

        UseConsistentWhitespaceEnable               = $true
        UseConsistentWhitespaceCheckInnerBrace      = $true
        UseConsistentWhitespaceCheckOpenBrace       = $true
        UseConsistentWhitespaceCheckOpenParen       = $true
        UseConsistentWhitespaceCheckOperator        = $true
        UseConsistentWhitespaceCheckPipe            = $true
        UseConsistentWhitespaceCheckSeparator       = $true

        AlignAssignmentStatementEnable              = $true
        AlignAssignmentStatementCheckHashtable      = $true

        UseCorrectCasingEnable                      = $true
    }
    # format PSD1 and PSM1 files when merging into a single file
    # enable formatting is not required as Configuration is provided
    #New-ConfigurationFormat -ApplyTo 'OnMergePSM1', 'OnMergePSD1' -Sort None @ConfigurationFormat
    New-ConfigurationFormat -ApplyTo 'OnMergePSD1' -Sort None @ConfigurationFormat
    # format PSD1 and PSM1 files within the module
    # enable formatting is required to make sure that formatting is applied (with default settings)
    New-ConfigurationFormat -ApplyTo 'DefaultPSD1', 'DefaultPSM1' -EnableFormatting -Sort None
    # when creating PSD1 use special style without comments and with only required parameters
    New-ConfigurationFormat -ApplyTo 'DefaultPSD1', 'OnMergePSD1' -PSD1Style 'Minimal'
    # configuration for documentation, at the same time it enables documentation processing
    New-ConfigurationDocumentation -Enable:$false -StartClean -UpdateWhenNew -PathReadme 'Docs\Readme.md' -Path 'Docs'

    New-ConfigurationImportModule -ImportSelf

    New-ConfigurationBuild -Enable:$true -SignModule:$SignModule -MergeModuleOnBuild -MergeFunctionsFromApprovedModules -CertificateThumbprint '92E95FB58EFFA6A4A75E77A33CDD6BFE6DD30F1A'

    $newConfigurationArtefactSplat = @{
        Type                = 'Unpacked'
        Enable              = $true
        Path                = "$PSScriptRoot\..\Artefacts\Unpacked"
        ModulesPath         = "$PSScriptRoot\..\Artefacts\Unpacked\Modules"
        RequiredModulesPath = "$PSScriptRoot\..\Artefacts\Unpacked\Modules"
        AddRequiredModules  = $true
        RequiredModulesSource     = 'Download'
        RequiredModulesTool       = 'PowerShellGet'
        RequiredModulesRepository = 'PSGallery'
        CopyFiles           = @{
            #"Examples\PublishingExample\Example-ExchangeEssentials.ps1" = "RunMe.ps1"
        }
    }
    New-ConfigurationArtefact @newConfigurationArtefactSplat -CopyFilesRelative
    $newConfigurationArtefactSplat = @{
        Type                = 'Packed'
        Enable              = $true
        Path                = "$PSScriptRoot\..\Artefacts\Packed"
        ModulesPath         = "$PSScriptRoot\..\Artefacts\Packed\Modules"
        RequiredModulesPath = "$PSScriptRoot\..\Artefacts\Packed\Modules"
        AddRequiredModules  = $true
        RequiredModulesSource     = 'Download'
        RequiredModulesTool       = 'PowerShellGet'
        RequiredModulesRepository = 'PSGallery'
        CopyFiles           = @{
            #"Examples\PublishingExample\Example-ExchangeEssentials.ps1" = "RunMe.ps1"
        }
        ArtefactName        = '<ModuleName>.v<ModuleVersion>.zip'
    }
    New-ConfigurationArtefact @newConfigurationArtefactSplat -CopyFilesRelative

    New-ConfigurationPublish -Type PowerShellGallery -FilePath $PowerShellGalleryApiKeyPath -Enabled:$true
    New-ConfigurationPublish -Type GitHub -FilePath $GitHubApiKeyPath -UserName 'EvotecIT' -RepositoryName 'Testimo' -GenerateReleaseNotes -Enabled:$true
}
