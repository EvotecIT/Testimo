function Out-Status {
    <#
    .SYNOPSIS
    Outputs the status of a specific test or source.

    .DESCRIPTION
    The Out-Status function outputs the status of a specific test or source based on the provided parameters. It includes details such as the test type, importance, category, action type, and status translation.

    .PARAMETER Scope
    Specifies the scope of the test (e.g., 'Domain', 'DC').

    .PARAMETER TestID
    Specifies the unique identifier of the test.

    .PARAMETER Text
    Specifies additional text related to the test or source.

    .PARAMETER Status
    Specifies the status of the test or source.

    .PARAMETER Section
    Specifies the section to which the test or source belongs.

    .PARAMETER ExtendedValue
    Specifies any extended value associated with the test or source.

    .PARAMETER Domain
    Specifies the domain related to the test or source.

    .PARAMETER DomainController
    Specifies the domain controller related to the test or source.

    .PARAMETER Source
    An IDictionary containing details about the source.

    .PARAMETER Test
    An IDictionary containing details about the test.

    .PARAMETER ReferenceID
    Specifies the reference ID of the test or source.

    .EXAMPLE
    Out-Status -Scope 'Domain' -TestID '123' -Text 'Test description' -Status $true -Section 'Section1' -ExtendedValue 'Extended' -Domain 'example.com' -DomainController 'DC1' -Source $SourceDetails -Test $TestDetails -ReferenceID 'REF123'
    Outputs the status of a test in the 'Domain' scope with the specified details.

    .EXAMPLE
    Out-Status -Scope 'DC' -TestID '456' -Text 'Another test' -Status $false -Section 'Section2' -ExtendedValue 'Additional' -Domain 'example.com' -DomainController 'DC2' -Source $SourceDetails -Test $TestDetails -ReferenceID 'REF456'
    Outputs the status of a test in the 'DC' scope with the specified details.
    #>
    [CmdletBinding()]
    param(
        [string] $Scope,
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
    } else {
        $TestType = $Scope
        $TestText = "$Scope | $Text"
    }

    if ($Source -and -not $Test) {
        # This means we're dealing with source
        if (-not [string]::IsNullOrWhitespace($Source.Details.Importance)) {
            $ImportanceInformation = $Script:Importance[$Source.Details.Importance]
        } else {
            $ImportanceInformation = 'Not defined'
        }
        if (-not [string]::IsNullOrWhitespace($Source.Details.Category)) {
            $Category = $Source.Details.Category
        } else {
            $Category = 'Not defined'
        }
        if (-not [string]::IsNullOrWhitespace($Source.Details.ActionType)) {
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
        if (-not [string]::IsNullOrWhitespace($Test.Details.Importance)) {
            $ImportanceInformation = $Script:Importance[$Test.Details.Importance]
        } else {
            $ImportanceInformation = 'Not defined'
        }
        if (-not [string]::IsNullOrWhitespace($Test.Details.Category)) {
            $Category = $Test.Details.Category
        } else {
            $Category = 'Not defined'
        }
        if (-not [string]::IsNullOrWhitespace($Test.Details.ActionType)) {
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
        Source           = $Source.Name
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
        if ($Scope -in 'Forest', 'Domain', 'DC') {
            if ($Domain -and $DomainController) {
                $Script:Reporting['Domains'][$Domain]['DomainControllers'][$DomainController]['Tests'][$ReferenceID]['Results'].Add($Output)
            } elseif ($Domain) {
                $Script:Reporting['Domains'][$Domain]['Tests'][$ReferenceID]['Results'].Add($Output)
            } else {
                $Script:Reporting['Forest']['Tests'][$ReferenceID]['Results'].Add($Output)
            }
        } else {
            $Script:Reporting[$Scope]['Tests'][$ReferenceID]['Results'].Add($Output)
        }
    }
    if ($null -eq $StatusColor) {
        Write-Warning -Message "Status color for $StatusTranslation is not within -1 and 5 range. Test: $($Output.Name). Fix test!!"
        $StatusColor = [ConsoleColor]::Red
    }
    [ConsoleColor[]] $Color = [ConsoleColor]::Cyan, $StatusColor, [ConsoleColor]::Cyan, [ConsoleColor]::Cyan, $StatusColor, [ConsoleColor]::Cyan
    if ($ExtendedValue) {
        Write-Color -Text ' [', $StatusTranslation, ']', " [", $ExtendedValue, "]" -Color $Color
    } else {
        Write-Color -Text ' [', $StatusTranslation, ']' -Color $Color
    }

    $Script:TestResults.Add($Output)
}