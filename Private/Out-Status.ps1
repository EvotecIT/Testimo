function Out-Status {
    [CmdletBinding()]
    param(
        [string] $TestID,
        [string] $Text,
        [nullable[bool]] $Status,
        [string] $Section,
        [string] $ExtendedValue,
        [string] $Domain,
        [string] $DomainController,
        [System.Collections.IDictionary] $Source,
        [System.Collections.IDictionary] $Test,
        [string] $ReferenceID
    )
    if ($Domain -and $DomainController) {
        $TestType = 'Domain Controller'
        $TestText = "Domain Controller - $DomainController | $Text"
    } elseif ($Domain) {
        $TestType = 'Domain'
        $TestText = "Domain - $Domain | $Text"
    } elseif ($DomainController) {
        $TestType = 'Should not happen. Find an error.'
    } else {
        $TestType = 'Forest'
        $TestText = "Forest | $Text"
    }

    if ($Source) {
        # This means we're dealing with source
        if ($null -ne $Source.Details.Importance) {
            $ImportanceInformation = $Script:Importance[$Source.Details.Importance]
        } else {
            $ImportanceInformation = 'Not defined'
        }
        if ($null -ne $Source.Details.Category) {
            $Category = $Source.Details.Category
        } else {
            $Category = 'Not defined'
        }
        if ($null -ne $Source.Details.ActionType) {
            $Action = $Script:ActionType[$Source.Details.ActionType]
        } else {
            $Action = 'Not defined'
        }

        if ($null -ne $Source.Details.StatusTrue -and $null -ne $Source.Details.StatusFalse) {
            if ($Status -eq $true) {
                $StatusTranslation = $Script:StatusTranslation[$Source.Details.StatusTrue]
                $StatusColor = $Script:StatusTranslationConsoleColors[$Source.Details.StatusTrue]
            } elseif ($Status -eq $false) {
                $StatusTranslation = $Script:StatusTranslation[$Source.Details.StatusFalse]
                $StatusColor = $Script:StatusTranslationConsoleColors[$Source.Details.StatusFalse]
            } elseif ($null -eq $Status) {
                $StatusTranslation = $Script:StatusTranslation[0]
                $StatusColor = $Script:StatusTranslationConsoleColors[0]
            }
        } else {
            # We need to overwrite some values to better suite our reports
            #$StatusTranslation = $Status
            if ($Status -eq $true) {
                $StatusTranslation = $Script:StatusTranslation[1]
                $StatusColor = $Script:StatusTranslationConsoleColors[1]
            } elseif ($Status -eq $false) {
                $StatusTranslation = $Script:StatusTranslation[4]
                $StatusColor = $Script:StatusTranslationConsoleColors[4]
            } elseif ($null -eq $Status) {
                $StatusTranslation = $Script:StatusTranslation[0]
                $StatusColor = $Script:StatusTranslationConsoleColors[0]
            }
        }
    } else {
        if ($null -ne $Test.Details.Importance) {
            $ImportanceInformation = $Script:Importance[$Test.Details.Importance]
        } else {
            $ImportanceInformation = 'Not defined'
        }
        if ($null -ne $Test.Details.Category) {
            $Category = $Test.Details.Category
        } else {
            $Category = 'Not defined'
        }
        if ($null -ne $Test.Details.ActionType) {
            $Action = $Script:ActionType[$Test.Details.ActionType]
        } else {
            $Action = 'Not defined'
        }
        if ($null -ne $Test.Details.StatusTrue -and $null -ne $Test.Details.StatusFalse) {
            if ($Status -eq $true) {
                $StatusTranslation = $Script:StatusTranslation[$Test.Details.StatusTrue]
                $StatusColor = $Script:StatusTranslationConsoleColors[$Test.Details.StatusTrue]
            } elseif ($Status -eq $false) {
                $StatusTranslation = $Script:StatusTranslation[$Test.Details.StatusFalse]
                $StatusColor = $Script:StatusTranslationConsoleColors[$Test.Details.StatusFalse]
            } elseif ($null -eq $Status) {
                $StatusTranslation = $Script:StatusTranslation[0]
                $StatusColor = $Script:StatusTranslationConsoleColors[0]
            }
        } else {
            # We need to overwrite some values to better suite our reports
            #$StatusTranslation = $Status
            if ($Status -eq $true) {
                $StatusTranslation = $Script:StatusTranslation[1]
                $StatusColor = $Script:StatusTranslationConsoleColors[1]
            } elseif ($Status -eq $false) {
                $StatusTranslation = $Script:StatusTranslation[4]
                $StatusColor = $Script:StatusTranslationConsoleColors[4]
            } elseif ($null -eq $Status) {
                $StatusTranslation = $Script:StatusTranslation[0]
                $StatusColor = $Script:StatusTranslationConsoleColors[0]
            }
        }
    }

    $Output = [PSCustomObject]@{
        Name             = $TestText
        DisplayName      = $Text
        Type             = $TestType
        Category         = $Category
        Assessment       = $StatusTranslation
        Status           = $Status
        Action           = $Action
        Importance       = $ImportanceInformation
        Extended         = $ExtendedValue
        Domain           = $Domain
        DomainController = $DomainController
    }
    if (-not $ReferenceID) {
        $Script:Reporting['Errors'].Add($Output)
    } else {
        if ($Domain -and $DomainController) {
            $Script:Reporting['Domains'][$Domain]['DomainControllers'][$DomainController]['Tests'][$ReferenceID]['Results'].Add($Output)
        } elseif ($Domain) {
            $Script:Reporting['Domains'][$Domain]['Tests'][$ReferenceID]['Results'].Add($Output)
        } else {
            $Script:Reporting['Forest']['Tests'][$ReferenceID]['Results'].Add($Output)
        }
    }

    <#
    if ($Status -eq $true) {
        [string] $TextStatus = 'Pass'
        [ConsoleColor[]] $Color = [ConsoleColor]::Cyan, [ConsoleColor]::Green, [ConsoleColor]::Cyan, [ConsoleColor]::Cyan, [ConsoleColor]::Green, [ConsoleColor]::Cyan
    } elseif ($Status -eq $false) {
        [string] $TextStatus = 'Fail'
        [ConsoleColor[]] $Color = [ConsoleColor]::Cyan, [ConsoleColor]::Red, [ConsoleColor]::Cyan, [ConsoleColor]::Cyan, [ConsoleColor]::Red, [ConsoleColor]::Cyan
    } else {
        [string] $TextStatus = 'Informative'
        [ConsoleColor[]] $Color = [ConsoleColor]::Cyan, [ConsoleColor]::DarkGray, [ConsoleColor]::Cyan, [ConsoleColor]::Cyan, [ConsoleColor]::Magenta, [ConsoleColor]::Cyan
    }
    #>
    [ConsoleColor[]] $Color = [ConsoleColor]::Cyan, $StatusColor, [ConsoleColor]::Cyan, [ConsoleColor]::Cyan, $StatusColor, [ConsoleColor]::Cyan
    if ($ExtendedValue) {
        Write-Color -Text ' [', $StatusTranslation, ']', " [", $ExtendedValue, "]" -Color $Color
    } else {
        Write-Color -Text ' [', $StatusTranslation, ']' -Color $Color
    }

    $Script:TestResults.Add($Output)
}