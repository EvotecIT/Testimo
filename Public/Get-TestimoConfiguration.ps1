function Get-TestimoConfiguration {
    [CmdletBinding()]
    param(
        [switch] $AsJson,
        [string] $FilePath
    )
    $NewConfig = [ordered] @{ }
    foreach ($Source in ($Script:TestimoConfiguration.ActiveDirectory).Keys) {
        if (-not $Script:TestimoConfiguration['ActiveDirectory'][$Source]) {
            Out-Informative -Text "Configuration for $Source is not available. Skipping source $Source" -Level 0 -Status $null -ExtendedValue $null
            continue
        }
        $NewConfig[$Source] = [ordered] @{ }
        $NewConfig[$Source]['Enable'] = $Script:TestimoConfiguration['ActiveDirectory'][$Source]['Enable']
        if ($null -ne $Script:TestimoConfiguration['ActiveDirectory'][$Source]['Source']['ExpectedOutput']) {
            $NewConfig[$Source]['Source'] = [ordered] @{ }
            $NewConfig[$Source]['Source']['ExpectedOutput'] = $Script:TestimoConfiguration['ActiveDirectory'][$Source]['Source']['ExpectedOutput']
        }

        if ($null -ne $Script:TestimoConfiguration['ActiveDirectory'][$Source]['Source']['Parameters']) {
            $NewConfig[$Source]['Source'] = [ordered] @{ }
            $NewConfig[$Source]['Source']['Parameters'] = $Script:TestimoConfiguration['ActiveDirectory'][$Source]['Source']['Parameters']
        }
        $NewConfig[$Source]['Tests'] = [ordered] @{ }
        foreach ($Test in $Script:TestimoConfiguration['ActiveDirectory'][$Source]['Tests'].Keys) {
            $NewConfig[$Source]['Tests'][$Test] = [ordered] @{ }
            $NewConfig[$Source]['Tests'][$Test]['Enable'] = $Script:TestimoConfiguration['ActiveDirectory'][$Source]['Tests'][$Test]['Enable']
            $NewConfig[$Source]['Tests'][$Test]['Parameters'] = [ordered] @{ }

            if ($null -ne $Script:TestimoConfiguration['ActiveDirectory'][$Source]['Tests'][$Test]['Parameters']) {
                if ($null -ne $Script:TestimoConfiguration['ActiveDirectory'][$Source]['Tests'][$Test]['Parameters']['Property']) {

                    if ($null -ne $Script:TestimoConfiguration['ActiveDirectory'][$Source]['Tests'][$Test]['Parameters']['Property']) {
                        $NewConfig[$Source]['Tests'][$Test]['Parameters']['Property'] = $Script:TestimoConfiguration['ActiveDirectory'][$Source]['Tests'][$Test]['Parameters']['Property']
                    }
                    if ($null -ne $Script:TestimoConfiguration['ActiveDirectory'][$Source]['Tests'][$Test]['Parameters']['ExpectedValue']) {
                        $NewConfig[$Source]['Tests'][$Test]['Parameters']['ExpectedValue'] = $Script:TestimoConfiguration['ActiveDirectory'][$Source]['Tests'][$Test]['Parameters']['ExpectedValue']
                    }
                    if ($null -ne $Script:TestimoConfiguration['ActiveDirectory'][$Source]['Tests'][$Test]['Parameters']['ExpectedCount']) {
                        $NewConfig[$Source]['Tests'][$Test]['Parameters']['ExpectedCount'] = $Script:TestimoConfiguration['ActiveDirectory'][$Source]['Tests'][$Test]['Parameters']['ExpectedCount']
                    }
                    if ($null -ne $Script:TestimoConfiguration['ActiveDirectory'][$Source]['Tests'][$Test]['Parameters']['OperationType']) {
                        $NewConfig[$Source]['Tests'][$Test]['Parameters']['OperationType'] = $Script:TestimoConfiguration['ActiveDirectory'][$Source]['Tests'][$Test]['Parameters']['OperationType']
                    }
                    #if ($nulle -ne $Script:TestimoConfiguration['ActiveDirectory'][$Source]['Tests'][$Test]['Parameters']['PropertyExtendedValue']) {
                    #    $NewConfig[$Source]['Tests'][$Test]['Parameters']['PropertyExtendedValue'] = $Script:TestimoConfiguration['ActiveDirectory'][$Source]['Tests'][$Test]['Parameters']['PropertyExtendedValue']
                    #}
                }
            }
        }
    }
    if ($FilePath) {
        $NewConfig | ConvertTo-Json -Depth 10 | Set-Content -LiteralPath $FilePath
        return
    }
    if ($AsJSON) {
        return $NewConfig | ConvertTo-Json -Depth 10
    }
    return $NewConfig
}