function Set-TestsStatus {
    <#
    .SYNOPSIS
    Sets the status of tests based on provided parameters.

    .DESCRIPTION
    This function sets the status of tests based on the specified sources, tags, and exclusion criteria.

    .PARAMETER Sources
    Specifies an array of sources to include for test status setting.

    .PARAMETER ExcludeSources
    Specifies an array of sources to exclude for test status setting.

    .PARAMETER IncludeTags
    Specifies an array of tags to include for test status setting.

    .PARAMETER ExcludeTags
    Specifies an array of tags to exclude for test status setting.

    .EXAMPLE
    Set-TestsStatus -Sources Source1, Source2 -IncludeTags Tag1, Tag2

    Description:
    Sets the status of tests for Source1 and Source2 with tags Tag1 and Tag2 enabled.

    .EXAMPLE
    Set-TestsStatus -Sources Source3 -ExcludeSources Source4 -ExcludeTags Tag3

    Description:
    Sets the status of tests for Source3 with Source4 excluded and Tag3 disabled.

    #>
    [CmdletBinding()]
    param(
        [string[]] $Sources,
        [string[]] $ExcludeSources,
        [string[]] $IncludeTags,
        [string[]] $ExcludeTags
    )
    # we first disable all sources to make sure it's a clean start
    foreach ($Key in $Script:TestimoConfiguration.Keys) {
        if ($Key -notin 'Types', 'Exclusions', 'Inclusions', 'Debug') {
            foreach ($Source in $Script:TestimoConfiguration.$Key.Keys) {
                if ($Script:TestimoConfiguration[$Key][$Source]) {
                    $Script:TestimoConfiguration[$Key][$Source]['Enable'] = $false
                    $Script:TestimoConfiguration.Types[$Key] = $false
                }
            }
        }
    }
    # then we go thru the sources and enable them
    foreach ($Key in $Script:TestimoConfiguration.Keys) {
        if ($Key -notin 'Types', 'Exclusions', 'Inclusions', 'Debug') {
            foreach ($Tag in $IncludeTags) {
                if ($Script:TestimoConfiguration[$Key]) {
                    foreach ($Source in $Script:TestimoConfiguration[$Key].Keys) {
                        if ($Tag -in $Script:TestimoConfiguration[$Key][$Source]['Source']['Details'].Tags) {
                            $Script:TestimoConfiguration[$Key][$Source]['Enable'] = $true
                            $Script:TestimoConfiguration.Types[$Key] = $true
                        }
                    }
                }
            }
            foreach ($Source in $Sources) {
                if ($Script:TestimoConfiguration[$Key][$Source]) {
                    $Script:TestimoConfiguration[$Key][$Source]['Enable'] = $true
                    $Script:TestimoConfiguration.Types[$Key] = $true
                }
            }
            foreach ($Source in $ExcludeSources) {
                if ($Script:TestimoConfiguration[$Key][$Source]) {
                    $Script:TestimoConfiguration[$Key][$Source]['Enable'] = $false
                }
            }
            foreach ($Tag in $ExcludeTags) {
                if ($Script:TestimoConfiguration[$Key]) {
                    foreach ($Source in $Script:TestimoConfiguration[$Key].Keys) {
                        if ($Tag -in $Script:TestimoConfiguration[$Key][$Source]['Source']['Details'].Tags) {
                            $Script:TestimoConfiguration[$Key][$Source]['Enable'] = $false
                        }
                    }
                }
            }
        }
    }
}