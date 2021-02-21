Clear-Host
Import-Module "C:\Support\GitHub\PSPublishModule\PSPublishModule.psm1" -Force

$Configuration = @{
    Information = @{
        ModuleName        = 'Testimo'
        DirectoryProjects = 'C:\Support\GitHub'
        Manifest          = @{
            # Version number of this module.
            ModuleVersion              = '0.0.X'
            # Supported PSEditions
            CompatiblePSEditions       = @('Desktop')
            # ID used to uniquely identify this module
            GUID                       = '0c1b99de-55ac-4410-8cb5-e689ff3be39b'
            # Author of this module
            Author                     = 'Przemyslaw Klys'
            # Company or vendor of this module
            CompanyName                = 'Evotec'
            # Copyright statement for this module
            Copyright                  = "(c) 2011 - $((Get-Date).Year) Przemyslaw Klys @ Evotec. All rights reserved."
            # Description of the functionality provided by this module
            Description                = 'Testimo is Powershell module that tests Active Directory against specific set of tests.'
            # Minimum version of the Windows PowerShell engine required by this module
            PowerShellVersion          = '5.1'
            # Private data to pass to the module specified in RootModule/ModuleToProcess. This may also contain a PSData hashtable with additional module metadata used by PowerShell.
            Tags                       = @('Windows', 'ActiveDirectory', 'AD', 'Infrastructure', 'Testing', 'Checks', 'Audits', 'Checklist', 'Validation')

            IconUri                    = 'https://evotec.xyz/wp-content/uploads/2019/08/Testimo.png'

            ProjectUri                 = 'https://github.com/EvotecIT/Testimo'

            RequiredModules            = @(
                @{ ModuleName = 'PSSharedGoods'; ModuleVersion = "Latest"; Guid = 'ee272aa8-baaa-4edf-9f45-b6d6f7d844fe' }
                @{ ModuleName = 'PSWinDocumentation.DNS'; ModuleVersion = "Latest"; Guid = '462dd5e2-f32a-4263-bff5-22edf28882d0' }
                @{ ModuleName = 'PSEventViewer'; ModuleVersion = "Latest"; Guid = '5df72a79-cdf6-4add-b38d-bcacf26fb7bc' }
                @{ ModuleName = 'PSWriteHTML'; ModuleVersion = "0.0.130"; Guid = 'a7bdf640-f5cb-4acf-9de0-365b322d245c' }
                @{ ModuleName = 'ADEssentials'; ModuleVersion = "Latest"; Guid = '9fc9fd61-7f11-4f4b-a527-084086f1905f' }
                @{ ModuleName = 'GPOZaurr'; ModuleVersion = "Latest"; Guid = 'f7d4c9e4-0298-4f51-ad77-e8e3febebbde' }
            )
            ExternalModuleDependencies = @(
                "ActiveDirectory"
                "GroupPolicy"
                "ServerManager"
            )
        }
    }
    Options     = @{
        Merge             = @{
            Sort           = 'None'
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

                        PSAlignAssignmentStatement = @{
                            Enable         = $true
                            CheckHashtable = $true
                        }

                        PSUseCorrectCasing         = @{
                            Enable = $true
                        }
                    }
                }
            }
            FormatCodePSD1 = @{
                Enabled        = $true
                RemoveComments = $false
            }
            Integrate      = @{
                #ApprovedModules = @('PSSharedGoods', 'PSWriteColor', 'Connectimo', 'PSUnifi', 'PSWebToolbox', 'PSMyPassword')
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
        PowerShellGallery = @{
            ApiKey   = 'C:\Support\Important\PowerShellGalleryAPI.txt'
            FromFile = $true
        }
        GitHub            = @{
            ApiKey   = 'C:\Support\Important\GithubAPI.txt'
            FromFile = $true
            UserName = 'EvotecIT'
            #RepositoryName = 'PSWriteHTML'
        }
        Documentation     = @{
            Path       = 'Docs'
            PathReadme = 'Docs\Readme.md'
        }
    }
    Steps       = @{
        BuildModule        = @{  # requires Enable to be on to process all of that
            Enable           = $true
            DeleteBefore     = $false
            Merge            = $true
            MergeMissing     = $true
            SignMerged       = $true
            Releases         = $true
            ReleasesUnpacked = $false
            RefreshPSD1Only  = $false
        }
        BuildDocumentation = $false
        ImportModules      = @{
            Self            = $true
            RequiredModules = $false
            Verbose         = $false
        }
        PublishModule      = @{  # requires Enable to be on to process all of that
            Enabled      = $true
            Prerelease   = ''
            RequireForce = $false
            GitHub       = $true
        }
    }
}

New-PrepareModule -Configuration $Configuration #-Verbose