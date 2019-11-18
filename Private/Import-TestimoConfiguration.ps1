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
                #Out-Begin -Text "Loading configuration from JSON failed. Skipping."  -Level 0
                #Out-Status -Status $null -Domain $Domain -DomainController $DomainController -ExtendedValue ("Not JSON or syntax is incorrect.")

                Out-Informative -OverrideTitle 'Testimo' -Text "Loading configuration from JSON failed. Skipping." -Level 0 -Status $null -Domain $Domain -DomainController $DomainController -ExtendedValue ("Not JSON or syntax is incorrect.")
                return
            }
        } else {
            #Out-Begin -Text "Loading configuratio failed. Skipping."  -Level 0
            #Out-Status -Status $null -Domain $Domain -DomainController $DomainController -ExtendedValue ("Not JSON/Hashtable or syntax is incorrect.")


            Out-Informative -OverrideTitle 'Testimo' -Text "Loading configuratio failed. Skipping."  -Level 0 -Status $null -Domain $Domain -DomainController $DomainController -ExtendedValue ("Not JSON/Hashtable or syntax is incorrect.")
        }
        #Out-Begin -Text "Using configuration provided by user" -Level 0
        Out-Informative -OverrideTitle 'Testimo' -Text  "Using configuration provided by user" -Level 0 -Start
        $Scopes = 'Forest', 'Domain', 'DomainControllers'
        foreach ($Scope in $Scopes) {

            if ($LoadedConfiguration -is [System.Collections.IDictionary]) {
                foreach ($Key in ($LoadedConfiguration.$Scope).Keys) {
                    $Script:TestimoConfiguration[$Scope][$Key]['Enable'] = $LoadedConfiguration.$Scope.$Key.Enable

                    if ($null -ne $LoadedConfiguration[$Scope][$Key]['Source']) {
                        if ($null -ne $LoadedConfiguration[$Scope][$Key]['Source']['ExpectedOutput']) {
                            $Script:TestimoConfiguration[$Scope][$Key]['Source']['ExpectedOutput'] = $LoadedConfiguration.$Scope.$Key['Source']['ExpectedOutput']
                        }
                        if ($null -ne $LoadedConfiguration[$Scope][$Key]['Source']['Parameters']) {
                            foreach ($Parameter in [string] $LoadedConfiguration[$Scope][$Key]['Source']['Parameters'].Keys) {
                                $Script:TestimoConfiguration[$Scope][$Key]['Source']['Parameters'][$Parameter] = $LoadedConfiguration[$Scope][$Key]['Source']['Parameters'][$Parameter]
                            }
                        }
                    }

                    foreach ($Test in $LoadedConfiguration.$Scope.$Key.Tests.Keys) {
                        $Script:TestimoConfiguration[$Scope][$Key]['Tests'][$Test]['Enable'] = $LoadedConfiguration.$Scope.$Key.Tests.$Test.Enable

                        if ($null -ne $LoadedConfiguration.$Scope.$Key.Tests.$Test.Parameters.ExpectedValue) {
                            $Script:TestimoConfiguration[$Scope][$Key]['Tests'][$Test]['Parameters']['ExpectedValue'] = $LoadedConfiguration.$Scope.$Key.Tests.$Test.Parameters.ExpectedValue
                        }
                        if ($null -ne $LoadedConfiguration.$Scope.$Key.Tests.$Test.Parameters.ExpectedCount) {
                            $Script:TestimoConfiguration[$Scope][$Key]['Tests'][$Test]['Parameters']['ExpectedCount'] = $LoadedConfiguration.$Scope.$Key.Tests.$Test.Parameters.ExpectedCount
                        }
                        if ($null -ne $LoadedConfiguration.$Scope.$Key.Tests.$Test.Parameters.Property) {
                            $Script:TestimoConfiguration[$Scope][$Key]['Tests'][$Test]['Parameters']['Property'] = $LoadedConfiguration.$Scope.$Key.Tests.$Test.Parameters.Property
                        }
                        if ($null -ne $LoadedConfiguration.$Scope.$Key.Tests.$Test.Parameters.OperationType) {
                            $Script:TestimoConfiguration[$Scope][$Key]['Tests'][$Test]['Parameters']['OperationType'] = $LoadedConfiguration.$Scope.$Key.Tests.$Test.Parameters.OperationType
                        }
                    }
                }
            } else {

                foreach ($Key in ($LoadedConfiguration.$Scope).PSObject.Properties.Name) {
                    $Script:TestimoConfiguration[$Scope][$Key]['Enable'] = $LoadedConfiguration.$Scope.$Key.Enable

                    if ($null -ne $LoadedConfiguration.$Scope.$Key.'Source') {
                        if ($null -ne $LoadedConfiguration.$Scope.$Key.'Source'.'ExpectedOutput') {
                            $Script:TestimoConfiguration[$Scope][$Key]['Source']['ExpectedOutput'] = $LoadedConfiguration.$Scope.$Key.'Source'.'ExpectedOutput'
                        }
                        if ($null -ne $LoadedConfiguration.$Scope.$Key.'Source'.'Parameters') {
                            foreach ($Parameter in $LoadedConfiguration.$Scope.$Key.'Source'.'Parameters'.PSObject.Properties.Name) {
                                $Script:TestimoConfiguration[$Scope][$Key]['Source']['Parameters'][$Parameter] = $LoadedConfiguration.$Scope.$Key.'Source'.'Parameters'.$Parameter
                            }
                        }
                    }

                    foreach ($Test in $LoadedConfiguration.$Scope.$Key.Tests.PSObject.Properties.Name) {
                        $Script:TestimoConfiguration[$Scope][$Key]['Tests'][$Test]['Enable'] = $LoadedConfiguration.$Scope.$Key.Tests.$Test.Enable

                        if ($null -ne $LoadedConfiguration.$Scope.$Key.Tests.$Test.Parameters.ExpectedValue) {
                            $Script:TestimoConfiguration[$Scope][$Key]['Tests'][$Test]['Parameters']['ExpectedValue'] = $LoadedConfiguration.$Scope.$Key.Tests.$Test.Parameters.ExpectedValue
                        }
                        if ($null -ne $LoadedConfiguration.$Scope.$Key.Tests.$Test.Parameters.ExpectedCount) {
                            $Script:TestimoConfiguration[$Scope][$Key]['Tests'][$Test]['Parameters']['ExpectedCount'] = $LoadedConfiguration.$Scope.$Key.Tests.$Test.Parameters.ExpectedCount
                        }
                        if ($null -ne $LoadedConfiguration.$Scope.$Key.Tests.$Test.Parameters.Property) {
                            $Script:TestimoConfiguration[$Scope][$Key]['Tests'][$Test]['Parameters']['Property'] = $LoadedConfiguration.$Scope.$Key.Tests.$Test.Parameters.Property
                        }
                        if ($null -ne $LoadedConfiguration.$Scope.$Key.Tests.$Test.Parameters.OperationType) {
                            $Script:TestimoConfiguration[$Scope][$Key]['Tests'][$Test]['Parameters']['OperationType'] = $LoadedConfiguration.$Scope.$Key.Tests.$Test.Parameters.OperationType
                        }
                    }
                }
            }
        }
        #Out-Status -Status $null -Domain $Domain -DomainController $DomainController -ExtendedValue ("Configuration loaded from $Option")


        Out-Informative -OverrideTitle 'Testimo' -Status $null -Domain $Domain -DomainController $DomainController -ExtendedValue ("Configuration loaded from $Option") -End

    } else {
        Out-Informative -OverrideTitle 'Testimo' -Text  "Using configuration defaults" -Level 0 -Status $null -ExtendedValue ("No configuration provided by user") #-Domain $Domain -DomainController $DomainController

        # Out-Begin -Text "Using configuration defaults" -Level 0
        # Out-Status -Status $null -Domain $Domain -DomainController $DomainController -ExtendedValue ("No configuration provided by user")
    }
}

