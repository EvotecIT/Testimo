function Get-RequestedSources {
    [CmdletBinding()]
    param(
        $Sources,
        $ExcludeSources
    )
    $NonWorking = [System.Collections.Generic.List[String]]::new()
    $Working = [System.Collections.Generic.List[String]]::new()
    $NonWorkingExclusions = [System.Collections.Generic.List[String]]::new()
    $WorkingExclusions = [System.Collections.Generic.List[String]]::new()
    foreach ($Source in $Sources) {
        $Found = $false
        foreach ($Key in $Script:TestimoConfiguration.Keys) {
            if ($Key -notin 'Types', 'Exclusions', 'Inclusions', 'Debug') {
                if ($Source -in $Script:TestimoConfiguration[$Key].Keys) {
                    $Found = $true
                    break
                }
            }
        }
        if ($Found) {
            $Working.Add($Source)
        } else {
            $NonWorking.Add($Source)
        }
    }
    foreach ($Source in $ExcludeSources) {
        $Found = $false
        foreach ($Key in $Script:TestimoConfiguration.Keys) {
            if ($Key -notin 'Types', 'Exclusions', 'Inclusions', 'Debug') {
                if ($Source -in $Script:TestimoConfiguration[$Key].Keys) {
                    $Found = $true
                    break
                }
            }
        }
        if ($Found) {
            $WorkingExclusions.Add($Source)
        } else {
            $NonWorkingExclusions.Add($Source)
        }
    }
    if ($Working.Count -gt 0) {
        Out-Informative -Text 'Following sources will be used' -Level 0 -Status $true -ExtendedValue ($Working -join ', ') -OverrideTextStatus "Valid Sources"
    }
    if ($NonWorking.Count -gt 0) {
        Out-Informative -Text 'Following sources were provided incorrectly (skipping)' -Level 0 -Status $false -ExtendedValue ($NonWorking -join ', ') -OverrideTextStatus "Failed Sources"
    }
    if ($WorkingExclusions.Count -gt 0) {
        Out-Informative -Text 'Following sources will be excluded' -Level 0 -Status $true -ExtendedValue ($WorkingExclusions -join ', ') -OverrideTextStatus "Valid Sources"
    }
    if ($NonWorkingExclusions.Count -gt 0) {
        Out-Informative -Text 'Following sources for exclusions were provided incorrectly (skipping)' -Level 0 -Status $false -ExtendedValue ($NonWorkingExclusions -join ', ') -OverrideTextStatus "Failed Sources"
    }
}