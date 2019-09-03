Clear-Host
Import-Module "C:\Support\GitHub\PSPublishModule\PSPublishModule.psm1" -Force

$Configuration = @{
    Information = @{
        ModuleName        = 'Testimo'

        DirectoryProjects = 'C:\Support\GitHub'
        #DirectoryModules  = "C:\WINDOWS\system32\WindowsPowerShell\v1.0\Modules"
        DirectoryModules  = "$Env:USERPROFILE\Documents\WindowsPowerShell\Modules"

        FunctionsToExport = 'Public'
        AliasesToExport   = 'Public'

        Manifest          = @{
            Path                 = "C:\Support\GitHub\Testimo\Testimo.psd1"
            # Script module or binary module file associated with this manifest.
            RootModule           = 'Testimo.psm1'
            # Version number of this module.
            ModuleVersion        = '0.0.18'
            # Supported PSEditions
            CompatiblePSEditions = @('Desktop')
            # ID used to uniquely identify this module
            GUID                 = '0c1b99de-55ac-4410-8cb5-e689ff3be39b'
            # Author of this module
            Author               = 'Przemyslaw Klys'
            # Company or vendor of this module
            CompanyName          = 'Evotec'
            # Copyright statement for this module
            Copyright            = 'Przemyslaw Klys. All rights reserved.'
            # Description of the functionality provided by this module
            Description          = 'Testimo is Powershell module that tests Active Directory against specific set of tests.'
            # Minimum version of the Windows PowerShell engine required by this module
            PowerShellVersion    = '5.1'
            # Functions to export from this module, for best performance, do not use wildcards and do not delete the entry, use an empty array if there are no functions to export.
            FunctionsToExport    = @() #$FunctionToExport
            # Cmdlets to export from this module, for best performance, do not use wildcards and do not delete the entry, use an empty array if there are no cmdlets to export.
            CmdletsToExport      = @()
            # Variables to export from this module
            VariablesToExport    = @()
            # Aliases to export from this module, for best performance, do not use wildcards and do not delete the entry, use an empty array if there are no aliases to export.
            AliasesToExport      = @()
            # Private data to pass to the module specified in RootModule/ModuleToProcess. This may also contain a PSData hashtable with additional module metadata used by PowerShell.
            Tags                 = @('Windows', 'ActiveDirectory', 'AD', 'Infrastructure', 'Testing', 'Checks', 'Audits', 'Checklist', 'Validation')

            IconUri              = 'https://evotec.xyz/wp-content/uploads/2019/08/Testimo.png'

            ProjectUri           = 'https://github.com/EvotecIT/Testimo'

            RequiredModules      = @(
                @{ ModuleName = 'PSSharedGoods'; ModuleVersion = "0.0.93"; Guid = 'ee272aa8-baaa-4edf-9f45-b6d6f7d844fe' }
                @{ ModuleName = 'PSWinDocumentation.AD'; ModuleVersion = "0.1.14"; Guid = 'a46f9775-04d2-4423-9631-01cfda42b95d' }
                @{ ModuleName = 'PSWinDocumentation.DNS'; ModuleVersion = "0.0.8"; Guid = '462dd5e2-f32a-4263-bff5-22edf28882d0' }
                @{ ModuleName = 'ADEssentials'; ModuleVersion = "0.0.14"; Guid = '9fc9fd61-7f11-4f4b-a527-084086f1905f' }
                @{ ModuleName = 'PSEventViewer'; ModuleVersion = "1.0.6"; Guid = '5df72a79-cdf6-4add-b38d-bcacf26fb7bc' }
            )
        }
    }
    Options     = @{
        Merge             = @{
            Enabled        = $true
            Sort           = 'NONE'
            FormatCodePSM1 = @{
                Enabled           = $true
                RemoveComments    = $true
                FormatterSettings = @{
                    IncludeRules = @(
                        'PSPlaceOpenBrace',
                        'PSPlaceCloseBrace',
                        'PSUseConsistentWhitespace',
                        'PSUseConsistentIndentation',
                        'PSAlignAssignmentStatement',
                        'PSUseCorrectCasing'
                    )

                    Rules        = @{
                        PSPlaceOpenBrace           = @{
                            Enable             = $true
                            OnSameLine         = $true
                            NewLineAfter       = $true
                            IgnoreOneLineBlock = $true
                        }

                        PSPlaceCloseBrace          = @{
                            Enable             = $true
                            NewLineAfter       = $false
                            IgnoreOneLineBlock = $true
                            NoEmptyLineBefore  = $false
                        }

                        PSUseConsistentIndentation = @{
                            Enable              = $true
                            Kind                = 'space'
                            PipelineIndentation = 'IncreaseIndentationAfterEveryPipeline'
                            IndentationSize     = 4
                        }

                        PSUseConsistentWhitespace  = @{
                            Enable          = $true
                            CheckInnerBrace = $true
                            CheckOpenBrace  = $true
                            CheckOpenParen  = $true
                            CheckOperator   = $true
                            CheckPipe       = $true
                            CheckSeparator  = $true
                        }

                        #PSAlignAssignmentStatement = @{
                        #    Enable         = $true
                        #    CheckHashtable = $true
                        #}

                        PSUseCorrectCasing         = @{
                            Enable = $true
                        }
                    }
                }
            }
            FormatCodePSD1 = @{
                Enabled = $true
                #RemoveComments = $false
            }
        }
        Standard          = @{
            FormatCodePSM1 = @{

            }
            FormatCodePSD1 = @{
                Enabled = $true
                #RemoveComments = $true
            }
        }
        ImportModules     = @{
            Self            = $true
            RequiredModules = $false
        }
        PowerShellGallery = @{
            ApiKey   = 'C:\Support\Important\PowerShellGalleryAPI.txt'
            FromFile = $true
        }
        Documentation     = @{
            Path       = 'Docs'
            PathReadme = 'Docs\Readme.md'
        }
    }
    Steps       = @{
        BuildModule        = @{
            EnableDesktop = $true
            EnableCore    = $false
            Merge         = $true
        }
        BuildDocumentation = $false
        PublishModule      = @{
            Enabled      = $false
            Prerelease   = ''
            RequireForce = $false
        }
    }
}

New-PrepareModule -Configuration $Configuration -Verbose