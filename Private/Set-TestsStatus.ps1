function Set-TestsStatus {
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