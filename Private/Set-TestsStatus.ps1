function Set-TestsStatus {
    [CmdletBinding()]
    param(
        [string[]] $Sources,
        [string[]] $ExcludeSources
    )
    $Script:TestimoConfiguration.Types['ActiveDirectory'] = $false
    $Script:TestimoConfiguration.Types['Office365'] = $false


    foreach ($Key in $Script:TestimoConfiguration.Keys) {
        if ($Key -notin 'Types', 'Exclusions', 'Inclusions', 'Debug') {
            foreach ($Source in $Script:TestimoConfiguration.$Key.Keys) {
                if ($Script:TestimoConfiguration[$Key][$Source]) {
                    $Script:TestimoConfiguration[$Key][$Source]['Enable'] = $false
                }
            }
        }
    }
    foreach ($Key in $Script:TestimoConfiguration.Keys) {
        if ($Key -notin 'Types', 'Exclusions', 'Inclusions', 'Debug') {
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
        }
    }


    # foreach ($Source in $Script:TestimoConfiguration.ActiveDirectory.Keys) {
    #     if ($Script:TestimoConfiguration.ActiveDirectory[$Source]) {
    #         $Script:TestimoConfiguration.ActiveDirectory[$Source]['Enable'] = $false
    #     }
    # }
    # foreach ($Source in $Script:TestimoConfiguration.Office365.Keys) {
    #     if ($Script:TestimoConfiguration.Office365[$Source]) {
    #         $Script:TestimoConfiguration.Office365[$Source]['Enable'] = $false
    #     }
    # }
    # foreach ($Source in $Sources) {
    #     if ( $Script:TestimoConfiguration.ActiveDirectory[$Source]) {
    #         $Script:TestimoConfiguration.ActiveDirectory[$Source]['Enable'] = $true
    #         $Script:TestimoConfiguration.Types['ActiveDirectory'] = $true
    #     } elseif ( $Script:TestimoConfiguration.Office365[$Source]) {
    #         $Script:TestimoConfiguration.Types['Office365'] = $true
    #         $Script:TestimoConfiguration.Office365[$Source]['Enable'] = $true
    #     }
    # }
    # foreach ($Source in $ExcludeSources) {
    #     if ($Script:TestimoConfiguration.ActiveDirectory[$Source]) {
    #         $Script:TestimoConfiguration.ActiveDirectory[$Source]['Enable'] = $false
    #     } elseif ($Script:TestimoConfiguration.Office365[$Source]) {
    #         $Script:TestimoConfiguration.Office365[$Source]['Enable'] = $false
    #     }
    # }
}