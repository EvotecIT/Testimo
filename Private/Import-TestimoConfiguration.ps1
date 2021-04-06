function Import-TestimoConfiguration {
    [CmdletBinding()]
    param(
        [Object] $Configuration
    )

    if ($Configuration) {
        if ($Configuration -is [System.Collections.IDictionary]) {
            $Option = 'Hashtable'
            $LoadedConfiguration = $Configuration
        } elseif ($Configuration -is [string]) {
            if (Test-Path -LiteralPath $Configuration) {
                $Option = 'File'
                $FileContent = Get-Content -LiteralPath $Configuration
            } else {
                $Option = 'JSON'
                $FileContent = $Configuration
            }
            try {
                $LoadedConfiguration = $FileContent | ConvertFrom-Json
            } catch {
                Out-Informative -OverrideTitle 'Testimo' -Text "Loading configuration from JSON failed. Skipping." -Level 0 -Status $null -Domain $Domain -DomainController $DomainController -ExtendedValue ("Not JSON or syntax is incorrect.")
                return
            }
        } else {
            Out-Informative -OverrideTitle 'Testimo' -Text "Loading configuratio failed. Skipping." -Level 0 -Status $null -Domain $Domain -DomainController $DomainController -ExtendedValue ("Not JSON/Hashtable or syntax is incorrect.")
        }
        Out-Informative -OverrideTitle 'Testimo' -Text "Using configuration provided by user" -Level 0 -Start

        if ($LoadedConfiguration -is [System.Collections.IDictionary]) {
            foreach ($Key in ($LoadedConfiguration).Keys) {
                $Script:TestimoConfiguration['ActiveDirectory'][$Key]['Enable'] = $LoadedConfiguration.$Key.Enable

                if ($null -ne $LoadedConfiguration[$Key]['Source']) {
                    if ($null -ne $LoadedConfiguration[$Key]['Source']['ExpectedOutput']) {
                        $Script:TestimoConfiguration['ActiveDirectory'][$Key]['Source']['ExpectedOutput'] = $LoadedConfiguration.$Key['Source']['ExpectedOutput']
                    }
                    if ($null -ne $LoadedConfiguration[$Key]['Source']['Parameters']) {
                        foreach ($Parameter in [string] $LoadedConfiguration[$Key]['Source']['Parameters'].Keys) {
                            $Script:TestimoConfiguration['ActiveDirectory'][$Key]['Source']['Parameters'][$Parameter] = $LoadedConfiguration[$Key]['Source']['Parameters'][$Parameter]
                        }
                    }
                }
                foreach ($Test in $LoadedConfiguration.$Key.Tests.Keys) {
                    $Script:TestimoConfiguration['ActiveDirectory'][$Key]['Tests'][$Test]['Enable'] = $LoadedConfiguration.$Key.Tests.$Test.Enable

                    if ($null -ne $LoadedConfiguration.$Key.Tests.$Test.Parameters.ExpectedValue) {
                        $Script:TestimoConfiguration['ActiveDirectory'][$Key]['Tests'][$Test]['Parameters']['ExpectedValue'] = $LoadedConfiguration.$Key.Tests.$Test.Parameters.ExpectedValue
                    }
                    if ($null -ne $LoadedConfiguration.$Key.Tests.$Test.Parameters.ExpectedCount) {
                        $Script:TestimoConfiguration['ActiveDirectory'][$Key]['Tests'][$Test]['Parameters']['ExpectedCount'] = $LoadedConfiguration.$Key.Tests.$Test.Parameters.ExpectedCount
                    }
                    if ($null -ne $LoadedConfiguration.$Key.Tests.$Test.Parameters.Property) {
                        $Script:TestimoConfiguration['ActiveDirectory'][$Key]['Tests'][$Test]['Parameters']['Property'] = $LoadedConfiguration.$Key.Tests.$Test.Parameters.Property
                    }
                    if ($null -ne $LoadedConfiguration.$Key.Tests.$Test.Parameters.OperationType) {
                        $Script:TestimoConfiguration['ActiveDirectory'][$Key]['Tests'][$Test]['Parameters']['OperationType'] = $LoadedConfiguration.$Key.Tests.$Test.Parameters.OperationType
                    }
                }
            }
        } else {
            foreach ($Key in ($LoadedConfiguration).PSObject.Properties.Name) {
                $Script:TestimoConfiguration['ActiveDirectory'][$Key]['Enable'] = $LoadedConfiguration.$Key.Enable

                if ($null -ne $LoadedConfiguration.$Key.'Source') {
                    if ($null -ne $LoadedConfiguration.$Key.'Source'.'ExpectedOutput') {
                        $Script:TestimoConfiguration['ActiveDirectory'][$Key]['Source']['ExpectedOutput'] = $LoadedConfiguration.$Key.'Source'.'ExpectedOutput'
                    }
                    if ($null -ne $LoadedConfiguration.$Key.'Source'.'Parameters') {
                        foreach ($Parameter in $LoadedConfiguration.$Key.'Source'.'Parameters'.PSObject.Properties.Name) {
                            $Script:TestimoConfiguration['ActiveDirectory'][$Key]['Source']['Parameters'][$Parameter] = $LoadedConfiguration.$Key.'Source'.'Parameters'.$Parameter
                        }
                    }
                }

                foreach ($Test in $LoadedConfiguration.$Key.Tests.PSObject.Properties.Name) {
                    $Script:TestimoConfiguration['ActiveDirectory'][$Key]['Tests'][$Test]['Enable'] = $LoadedConfiguration.$Key.Tests.$Test.Enable

                    if ($null -ne $LoadedConfiguration.$Key.Tests.$Test.Parameters.ExpectedValue) {
                        $Script:TestimoConfiguration['ActiveDirectory'][$Key]['Tests'][$Test]['Parameters']['ExpectedValue'] = $LoadedConfiguration.$Key.Tests.$Test.Parameters.ExpectedValue
                    }
                    if ($null -ne $LoadedConfiguration.$Key.Tests.$Test.Parameters.ExpectedCount) {
                        $Script:TestimoConfiguration['ActiveDirectory'][$Key]['Tests'][$Test]['Parameters']['ExpectedCount'] = $LoadedConfiguration.$Key.Tests.$Test.Parameters.ExpectedCount
                    }
                    if ($null -ne $LoadedConfiguration.$Key.Tests.$Test.Parameters.Property) {
                        $Script:TestimoConfiguration['ActiveDirectory'][$Key]['Tests'][$Test]['Parameters']['Property'] = $LoadedConfiguration.$Key.Tests.$Test.Parameters.Property
                    }
                    if ($null -ne $LoadedConfiguration.$Key.Tests.$Test.Parameters.OperationType) {
                        $Script:TestimoConfiguration['ActiveDirectory'][$Key]['Tests'][$Test]['Parameters']['OperationType'] = $LoadedConfiguration.$Key.Tests.$Test.Parameters.OperationType
                    }
                }
            }
        }
        Out-Informative -OverrideTitle 'Testimo' -Status $null -Domain $Domain -DomainController $DomainController -ExtendedValue ("Configuration loaded from $Option") -End

    } else {
        Out-Informative -OverrideTitle 'Testimo' -Text "Using configuration defaults" -Level 0 -Status $null -ExtendedValue ("No configuration provided by user")
    }
}

