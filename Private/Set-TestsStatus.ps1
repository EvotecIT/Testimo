function Set-TestsStatus {
    [CmdletBinding()]
    param(
        [string[]] $Sources,
        [string[]] $ExcludeSources
    )
    if ($Sources) {
        $Scopes = @('Forest', 'Domain', 'DomainControllers')
        foreach ($Scope in $Scopes) {
            foreach ($Test in $Script:TestimoConfiguration.$Scope.Keys) {
                $Script:TestimoConfiguration.$Scope[$Test]['Enable'] = $false
            }
        }
        foreach ($Source in $Sources) {
            if ($Source.StartsWith('Forest')) {
                $ProperSource = $Source -replace '^Forest'
                $Script:TestimoConfiguration['Forest'][$ProperSource]['Enable'] = $true
            } elseif ($Source.StartsWith('Domain')) {
                $ProperSource = $Source -replace '^Domain'
                $Script:TestimoConfiguration['Domain'][$ProperSource]['Enable'] = $true
            } elseif ($Source.StartsWith('DC')) {
                $ProperSource = $Source -replace '^DC'
                $Script:TestimoConfiguration['DomainControllers'][$ProperSource]['Enable'] = $true
            }
        }

    }
    foreach ($Source in $ExcludeSources) {
        if ($Source.StartsWith('Forest')) {
            $ProperSource = $Source -replace '^Forest'
            $Script:TestimoConfiguration['Forest'][$ProperSource]['Enable'] = $false
        } elseif ($Source.StartsWith('Domain')) {
            $ProperSource = $Source -replace '^Domain'
            $Script:TestimoConfiguration['Domain'][$ProperSource]['Enable'] = $false
        } elseif ($Source.StartsWith('DC')) {
            $ProperSource = $Source -replace '^DC'
            $Script:TestimoConfiguration['DomainControllers'][$ProperSource]['Enable'] = $false
        }
    }
}