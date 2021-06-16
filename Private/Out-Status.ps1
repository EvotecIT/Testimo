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
    if ($ExtendedValue) {
        Write-Color -Text ' [', $TextStatus, ']', " [", $ExtendedValue, "]" -Color $Color
    } else {
        Write-Color -Text ' [', $TextStatus, ']' -Color $Color
    }
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
            } elseif ($Status -eq $false) {
                $StatusTranslation = $Script:StatusTranslation[$Source.Details.StatusFalse]
            } elseif ($null -eq $Status) {
                $StatusTranslation = $Script:StatusTranslation[0]
            }
        } else {
            $StatusTranslation = $Status
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
            } elseif ($Status -eq $false) {
                $StatusTranslation = $Script:StatusTranslation[$Test.Details.StatusFalse]
            } elseif ($null -eq $Status) {
                $StatusTranslation = $Script:StatusTranslation[0]
            }
        } else {
            $StatusTranslation = $Status
        }
    }


    $Output = [PSCustomObject]@{
        Name             = $TestText
        DisplayName      = $Text
        Type             = $TestType
        Category         = $Category
        Assessment        = $StatusTranslation
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
    $Script:TestResults.Add($Output)
}