function Import-TestimoConfiguration {
    <#
    .SYNOPSIS
    Imports a Testimo configuration from various sources.

    .DESCRIPTION
    This function imports a Testimo configuration from different sources such as Hashtable, JSON file, or JSON content. It then updates the Testimo configuration based on the provided input.

    .PARAMETER Configuration
    Specifies the configuration object to be imported. This can be a Hashtable, a path to a JSON file, or JSON content.

    .EXAMPLE
    Import-TestimoConfiguration -Configuration $Hashtable
    Imports a Testimo configuration from a Hashtable.

    .EXAMPLE
    Import-TestimoConfiguration -Configuration "C:\Path\to\Configuration.json"
    Imports a Testimo configuration from a JSON file located at the specified path.

    .EXAMPLE
    Import-TestimoConfiguration -Configuration '{"Key": {"Enable": true, "Source": {"ExpectedOutput": "Output"}}}'
    Imports a Testimo configuration from JSON content.

    #>
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
                if ($Script:TestimoConfiguration['ActiveDirectory'][$Key]) {
                    $Target = 'ActiveDirectory'
                } elseif ($Script:TestimoConfiguration['Office365'][$Key]) {
                    $Target = 'Office365'
                } else {
                    $Target = 'Unknown'
                }
                if ($Target -ne 'Unknown') {
                    $Script:TestimoConfiguration[$Target][$Key]['Enable'] = $LoadedConfiguration.$Key.Enable

                    if ($null -ne $LoadedConfiguration[$Key]['Source']) {
                        if ($null -ne $LoadedConfiguration[$Key]['Source']['ExpectedOutput']) {
                            $Script:TestimoConfiguration[$Target][$Key]['Source']['ExpectedOutput'] = $LoadedConfiguration.$Key['Source']['ExpectedOutput']
                        }
                        if ($null -ne $LoadedConfiguration[$Key]['Source']['Parameters']) {
                            foreach ($Parameter in [string] $LoadedConfiguration[$Key]['Source']['Parameters'].Keys) {
                                $Script:TestimoConfiguration[$Target][$Key]['Source']['Parameters'][$Parameter] = $LoadedConfiguration[$Key]['Source']['Parameters'][$Parameter]
                            }
                        }
                    }
                    foreach ($Test in $LoadedConfiguration.$Key.Tests.Keys) {
                        $Script:TestimoConfiguration[$Target][$Key]['Tests'][$Test]['Enable'] = $LoadedConfiguration.$Key.Tests.$Test.Enable

                        if ($null -ne $LoadedConfiguration.$Key.Tests.$Test.Parameters.ExpectedValue) {
                            $Script:TestimoConfiguration[$Target][$Key]['Tests'][$Test]['Parameters']['ExpectedValue'] = $LoadedConfiguration.$Key.Tests.$Test.Parameters.ExpectedValue
                        }
                        if ($null -ne $LoadedConfiguration.$Key.Tests.$Test.Parameters.ExpectedCount) {
                            $Script:TestimoConfiguration[$Target][$Key]['Tests'][$Test]['Parameters']['ExpectedCount'] = $LoadedConfiguration.$Key.Tests.$Test.Parameters.ExpectedCount
                        }
                        if ($null -ne $LoadedConfiguration.$Key.Tests.$Test.Parameters.Property) {
                            $Script:TestimoConfiguration[$Target][$Key]['Tests'][$Test]['Parameters']['Property'] = $LoadedConfiguration.$Key.Tests.$Test.Parameters.Property
                        }
                        if ($null -ne $LoadedConfiguration.$Key.Tests.$Test.Parameters.OperationType) {
                            $Script:TestimoConfiguration[$Target][$Key]['Tests'][$Test]['Parameters']['OperationType'] = $LoadedConfiguration.$Key.Tests.$Test.Parameters.OperationType
                        }
                    }
                } else {

                }
            }
        } else {
            foreach ($Key in ($LoadedConfiguration).PSObject.Properties.Name) {
                if ($Script:TestimoConfiguration['ActiveDirectory'][$Key]) {
                    $Target = 'ActiveDirectory'
                } elseif ($Script:TestimoConfiguration['Office365'][$Key]) {
                    $Target = 'Office365'
                } else {
                    $Target = 'Unknown'
                }
                if ($Target -ne 'Unknown') {
                    $Script:TestimoConfiguration[$Target][$Key]['Enable'] = $LoadedConfiguration.$Key.Enable

                    if ($null -ne $LoadedConfiguration.$Key.'Source') {
                        if ($null -ne $LoadedConfiguration.$Key.'Source'.'ExpectedOutput') {
                            $Script:TestimoConfiguration[$Target][$Key]['Source']['ExpectedOutput'] = $LoadedConfiguration.$Key.'Source'.'ExpectedOutput'
                        }
                        if ($null -ne $LoadedConfiguration.$Key.'Source'.'Parameters') {
                            foreach ($Parameter in $LoadedConfiguration.$Key.'Source'.'Parameters'.PSObject.Properties.Name) {
                                $Script:TestimoConfiguration[$Target][$Key]['Source']['Parameters'][$Parameter] = $LoadedConfiguration.$Key.'Source'.'Parameters'.$Parameter
                            }
                        }
                    }

                    foreach ($Test in $LoadedConfiguration.$Key.Tests.PSObject.Properties.Name) {
                        $Script:TestimoConfiguration[$Target][$Key]['Tests'][$Test]['Enable'] = $LoadedConfiguration.$Key.Tests.$Test.Enable

                        if ($null -ne $LoadedConfiguration.$Key.Tests.$Test.Parameters.ExpectedValue) {
                            $Script:TestimoConfiguration[$Target][$Key]['Tests'][$Test]['Parameters']['ExpectedValue'] = $LoadedConfiguration.$Key.Tests.$Test.Parameters.ExpectedValue
                        }
                        if ($null -ne $LoadedConfiguration.$Key.Tests.$Test.Parameters.ExpectedCount) {
                            $Script:TestimoConfiguration[$Target][$Key]['Tests'][$Test]['Parameters']['ExpectedCount'] = $LoadedConfiguration.$Key.Tests.$Test.Parameters.ExpectedCount
                        }
                        if ($null -ne $LoadedConfiguration.$Key.Tests.$Test.Parameters.Property) {
                            $Script:TestimoConfiguration[$Target][$Key]['Tests'][$Test]['Parameters']['Property'] = $LoadedConfiguration.$Key.Tests.$Test.Parameters.Property
                        }
                        if ($null -ne $LoadedConfiguration.$Key.Tests.$Test.Parameters.OperationType) {
                            $Script:TestimoConfiguration[$Target][$Key]['Tests'][$Test]['Parameters']['OperationType'] = $LoadedConfiguration.$Key.Tests.$Test.Parameters.OperationType
                        }
                    }
                } else {

                }
            }
        }
        Out-Informative -OverrideTitle 'Testimo' -Status $null -Domain $Domain -DomainController $DomainController -ExtendedValue ("Configuration loaded from $Option") -End

    } else {
        Out-Informative -OverrideTitle 'Testimo' -Text "Using configuration defaults" -Level 0 -Status $null -ExtendedValue ("No configuration provided by user")
    }
}

