function Compare-Testimo {
    [cmdletbinding(DefaultParameterSetName = 'JSON')]
    param(
        [parameter(Mandatory, ParameterSetName = 'Object')]
        [parameter(Mandatory, ParameterSetName = 'JSON')]
        [string] $Name,

        [parameter(ParameterSetName = 'Object')]
        [parameter(ParameterSetName = 'JSON')]
        [parameter()][string] $DisplayName,

        [parameter(Mandatory, ParameterSetName = 'Object')]
        [parameter(Mandatory, ParameterSetName = 'JSON')]
        [string] $Scope,

        [parameter(ParameterSetName = 'Object')]
        [parameter(ParameterSetName = 'JSON')]
        [string] $Category = 'Baseline',

        [parameter(Mandatory, ParameterSetName = 'Object')][Object] $BaseLineSource,
        [parameter(Mandatory, ParameterSetName = 'Object')][Object] $BaseLineTarget,
        [parameter(Mandatory, ParameterSetName = 'JSON')][Object] $BaseLineSourcePath,
        [parameter(Mandatory, ParameterSetName = 'JSON')][Object] $BaseLineTargetPath,

        [parameter(ParameterSetName = 'Object')]
        [parameter(ParameterSetName = 'JSON')]
        [string[]] $ExcludeProperty
    )

    $IsDsc = $false
    if ($PSBoundParameters.ContainsKey("BaseLineSourcePath")) {
        $SourcePath = Get-Item -LiteralPath $BaseLineSourcePath -ErrorAction SilentlyContinue
        $TargetPath = Get-Item -LiteralPath $BaseLineTargetPath -ErrorAction SilentlyContinue
        if (-not $SourcePath -or -not $TargetPath) {
            Out-Informative -Text "Could not find baseline source or target. Invalid path. Skipping source $Name" -Level 0 -Status $null -ExtendedValue $null
            return
        }
        if ($SourcePath.Extension -eq '.json' -and $TargetPath.Extension -eq '.json') {
            $BaseLineSource = Get-Content -LiteralPath $BaseLineSourcePath -Raw | ConvertFrom-Json
            $BaseLineTarget = Get-Content -LiteralPath $BaseLineTargetPath -Raw | ConvertFrom-Json
            @{
                Name            = $Name
                DisplayName     = if ($DisplayName) { $DisplayName } else { $Name }
                Scope           = $Scope
                Category        = $Category
                BaseLineSource  = $BaseLineSource
                BaseLineTarget  = $BaseLineTarget
                ExcludeProperty = $ExcludeProperty
            }
        } elseif ($SourcePath.Extension -eq '.ps1' -and $TargetPath.Extension -eq '.ps1') {
            $IsDsc = $true
            $CommandExists = Get-Command -Name 'ConvertTo-DSCObject' -ErrorAction SilentlyContinue
            if ($CommandExists) {
                $DSCGroups = [ordered] @{}
                $DSCGroupsTarget = [ordered] @{}

                [Array] $BaseLineSource = ConvertTo-DSCObject -Path $BaseLineSourcePath
                [Array] $BaseLineTarget = ConvertTo-DSCObject -Path $BaseLineTargetPath

                foreach ($DSC in $BaseLineSource) {
                    if ($DSC.Keys -notcontains 'ResourceName') {
                        Out-Informative -Text "Reading DSC Source failed. Probably missing DSC module. File $BaseLineSourcePath" -Level 0 -Status $false -ExtendedValue $null
                        continue
                    }
                    if (-not $DSCGroups[$DSC.ResourceName]) {
                        $DSCGroups[$DSC.ResourceName] = [System.Collections.Generic.List[PSCustomObject]]::new()
                    }
                    try {
                        $DSCGroups[$DSC.ResourceName].Add([PSCustomObject] $DSC)
                    } catch {
                        Out-Informative -Text "Reading DSC Source failed. Probably missing DSC module. File $BaseLineSourcePath" -Level 0 -Status $false -ExtendedValue $null
                        continue
                    }
                }
                foreach ($DSC in $BaseLineTarget) {
                    if ($DSC.Keys -notcontains 'ResourceName') {
                        Out-Informative -Text "Reading DSC Target failed. Probably missing DSC module. File $BaseLineTargetPath" -Level 0 -Status $false -ExtendedValue $null
                        continue
                    }
                    if (-not $DSCGroupsTarget[$DSC.ResourceName]) {
                        $DSCGroupsTarget[$DSC.ResourceName] = [System.Collections.Generic.List[PSCustomObject]]::new()
                    }
                    $DSCGroupsTarget[$DSC.ResourceName].Add([PSCustomObject] $DSC)
                }

                foreach ($Source in $DSCGroups.Keys) {
                    if ($DSCGroups[$Source].Count -gt 1 -or $DSCGroupsTarget[$Source].Count -gt 1) {
                        # This is to handle arrays within objects like: AADConditionalAccessPolicy
                        # By default its hard to compare array to array because the usual way is to do it by index.
                        # So we're forcing an array to become single object with it's property
                        $NewSourceObject = [ordered] @{}
                        foreach ($DSC in $DSCGroups[$Source]) {
                            if ($DSC.DisplayName) {
                                $NewSourceObject[$DSC.DisplayName] = $DSC
                            } elseif ($DSC.Name) {
                                $NewSourceObject[$DSC.Name] = $DSC
                            } elseif ($DSC.Identity) {
                                $NewSourceObject[$DSC.Identity] = $DSC
                            } else {
                                $NewSourceObject[$DSC.ResourceName] = $DSC
                            }
                        }
                        $SourceObject = [PSCustomObject] $NewSourceObject

                        $NewTargetObject = [ordered] @{}
                        foreach ($DSC in $DSCGroupsTarget[$Source]) {
                            if ($DSC.DisplayName) {
                                $NewTargetObject[$DSC.DisplayName] = $DSC
                            } elseif ($DSC.Name) {
                                $NewTargetObject[$DSC.Name] = $DSC
                            } elseif ($DSC.Identity) {
                                $NewTargetObject[$DSC.Identity] = $DSC
                            } else {
                                $NewTargetObject[$DSC.ResourceName] = $DSC
                            }
                        }
                        $TargetObject = [PSCustomObject] $NewTargetObject

                        if ($TargetObject) {
                            @{
                                Name            = $Source
                                DisplayName     = $Source
                                Scope           = $Scope
                                Category        = $Category
                                BaseLineSource  = $SourceObject
                                BaseLineTarget  = $TargetObject
                                ExcludeProperty = $ExcludeProperty
                            }
                        } else {
                            @{
                                Name            = $Source
                                DisplayName     = $Source
                                Scope           = $Scope
                                Category        = $Category
                                BaseLineSource  = $SourceObject
                                BaseLineTarget  = $null
                                ExcludeProperty = $ExcludeProperty
                            }
                        }
                    } else {
                        # This is standard DSC comparison
                        if ($DSCGroupsTarget[$Source]) {
                            @{
                                Name            = $Source
                                DisplayName     = $Source
                                Scope           = $Scope
                                Category        = $Category
                                BaseLineSource  = if ($DSCGroups[$Source].Count -eq 1) { $DSCGroups[$Source][0] } else { $DSCGroups[$Source] }
                                BaseLineTarget  = if ($DSCGroupsTarget[$Source].Count -eq 1) { $DSCGroupsTarget[$Source][0] } else { $DSCGroupsTarget[$Source] }
                                ExcludeProperty = $ExcludeProperty
                            }
                        } else {
                            @{
                                Name            = $Source
                                DisplayName     = $Source
                                Scope           = $Scope
                                Category        = $Category
                                BaseLineSource  = if ($DSCGroups[$Source].Count -eq 1) { $DSCGroups[$Source][0] } else { $DSCGroups[$Source] }
                                BaseLineTarget  = $null
                                ExcludeProperty = $ExcludeProperty
                            }
                        }
                    }
                }
            } else {
                Out-Informative -Text "DSCParser is not available. Skipping source $Name" -Level 0 -Status $null -ExtendedValue $null
            }
        } else {
            Out-Informative -Text "Only PS1 (DSC) and JSON files are supported. Skipping source $Name" -Level 0 -Status $null -ExtendedValue $null
            return
        }
        if (-not $BaseLineSource -or -not $BaseLineTarget) {
            Out-Informative -Text "Loading BaseLineSource or BaseLineTarget didn't work. Skipping source $Name" -Level 0 -Status $null -ExtendedValue $null
            return
        }
    }
}