function Get-TestimoConfiguration {
    param(

    )
    $NewConfig = [ordered] @{ }

    $Scopes = 'Forest', 'Domain', 'DomainControllers'
    foreach ($Scope in $Scopes) {
        $NewConfig[$Scope] = [ordered] @{ }
        foreach ($Source in ($Script:TestimoConfiguration[$Scope]).Keys) {
            $NewConfig[$Scope][$Source] = [ordered] @{ }
            $NewConfig[$Scope][$Source]['Enable'] = $Script:TestimoConfiguration[$Scope][$Source]['Enable']

            if ($null -ne $Script:TestimoConfiguration[$Scope][$Source]['Source']['ExpectedOutput']) {
                $NewConfig[$Scope][$Source]['Source'] = [ordered] @{}
                $NewConfig[$Scope][$Source]['Source']['ExpectedOutput'] = $Script:TestimoConfiguration[$Scope][$Source]['Source']['ExpectedOutput']
            }

            $NewConfig[$Scope][$Source]['Tests'] = [ordered] @{ }
            foreach ($Test in $Script:TestimoConfiguration[$Scope][$Source]['Tests'].Keys) {
                $NewConfig[$Scope][$Source]['Tests'][$Test] = [ordered] @{ }
                $NewConfig[$Scope][$Source]['Tests'][$Test]['Enable'] = $Script:TestimoConfiguration[$Scope][$Source]['Tests'][$Test]['Enable']
                $NewConfig[$Scope][$Source]['Tests'][$Test]['Parameters'] = [ordered] @{ }

                if ($null -ne $Script:TestimoConfiguration[$Scope][$Source]['Tests'][$Test]['Parameters']['Property']) {

                    if ($null -ne $Script:TestimoConfiguration[$Scope][$Source]['Tests'][$Test]['Parameters']['Property']) {
                        $NewConfig[$Scope][$Source]['Tests'][$Test]['Parameters']['Property'] = $Script:TestimoConfiguration[$Scope][$Source]['Tests'][$Test]['Parameters']['Property']
                    }
                    if ($null -ne $Script:TestimoConfiguration[$Scope][$Source]['Tests'][$Test]['Parameters']['ExpectedValue']) {
                        $NewConfig[$Scope][$Source]['Tests'][$Test]['Parameters']['ExpectedValue'] = $Script:TestimoConfiguration[$Scope][$Source]['Tests'][$Test]['Parameters']['ExpectedValue']
                    }
                    if ($null -ne $Script:TestimoConfiguration[$Scope][$Source]['Tests'][$Test]['Parameters']['ExpectedCount']) {
                        $NewConfig[$Scope][$Source]['Tests'][$Test]['Parameters']['ExpectedCount'] = $Script:TestimoConfiguration[$Scope][$Source]['Tests'][$Test]['Parameters']['ExpectedCount']
                    }
                    if ($null -ne $Script:TestimoConfiguration[$Scope][$Source]['Tests'][$Test]['Parameters']['OperationType']) {
                        $NewConfig[$Scope][$Source]['Tests'][$Test]['Parameters']['OperationType'] = $Script:TestimoConfiguration[$Scope][$Source]['Tests'][$Test]['Parameters']['OperationType']
                    }
                    #if ($nulle -ne $Script:TestimoConfiguration[$Scope][$Source]['Tests'][$Test]['Parameters']['PropertyExtendedValue']) {
                    #    $NewConfig[$Scope][$Source]['Tests'][$Test]['Parameters']['PropertyExtendedValue'] = $Script:TestimoConfiguration[$Scope][$Source]['Tests'][$Test]['Parameters']['PropertyExtendedValue']
                    #}
                }
            }
        }
    }
    $NewConfig
}