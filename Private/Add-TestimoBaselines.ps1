function Add-TestimoBaselines {
    <#
    .SYNOPSIS
    Adds baseline objects to the Testimo configuration.

    .DESCRIPTION
    This function adds baseline objects to the Testimo configuration. It compares baseline sources and targets, excluding specified properties, and stores the comparison results in the Testimo configuration.

    .PARAMETER BaseLineObjects
    Specifies an array of baseline objects to be added to the Testimo configuration.

    .EXAMPLE
    Add-TestimoBaselines -BaseLineObjects @($BaselineObject1, $BaselineObject2)
    Adds $BaselineObject1 and $BaselineObject2 to the Testimo configuration and performs a comparison between their baseline sources and targets.

    .NOTES
    File Name      : Add-TestimoBaselines.ps1
    Prerequisite   : This function requires Compare-MultipleObjects function.
    #>
    [CmdletBinding()]
    param(
        [System.Collections.IDictionary[]] $BaseLineObjects
    )
    $ListNewSources = [System.Collections.Generic.List[string]]::new()
    $ListOverwritten = [System.Collections.Generic.List[string]]::new()
    foreach ($Source in $BaseLineObjects) {
        if (-not $Script:TestimoConfiguration[$Source.Scope]) {
            $Script:TestimoConfiguration[$Source.Scope] = [ordered] @{}
        }

        #$Execute = Compare-MultipleObjects -FlattenObject -Objects $Source.BaseLineSource, $Source.BaseLineTarget

        $ExcludeProperties = @(
            'id'
            "*@odata*"
            "#microsoft.graph*"
            "ResourceID"
            "Credential"
            "ResourceName"
            if ($Source.ExcludeProperty) {
                $Source.ExcludeProperty
            }
        )
        If ($Source.BaseLineSource -and $Source.BaseLineTarget) {
            try {
                $DataOutput = Compare-MultipleObjects -FlattenObject -Objects $Source.BaseLineSource, $Source.BaseLineTarget -ObjectsName "Source", "Target" -ExcludeProperty $ExcludeProperties -SkipProperties -AllProperties
            } catch {
                $DataOutput = $null
                Write-Warning -Message "Error comparing $($Source.BaseLineSource) and $($Source.BaseLineTarget) with error: $($_.Exception.Message)"
            }
        } else {
            $DataOutput = $null
        }

        $Script:TestimoConfiguration[$Source.Scope][$Source.Name] = @{
            Name           = $Source.Name
            Enable         = $true
            Scope          = $Source.Scope
            Source         = @{
                Name           = $Source.DisplayName
                DataCode       = 'Compare-MultipleObjects -FlattenObject -Objects $Source.BaseLineSource, $Source.BaseLineTarget -CompareNames "Source", "Target" -ExcludeProperty "*@odata*" -SkipProperties'
                DataOutput     = $DataOutput
                Details        = [ordered] @{
                    Area        = ''
                    Category    = $Source.Category
                    Severity    = ''
                    Importance  = 0
                    Description = ''
                    Resolution  = ''
                    Resources   = @(

                    )
                }
                ExpectedOutput = $true
            }
            Tests          = [ordered] @{
                Baseline = @{
                    Enable     = $true
                    Name       = 'Baseline comparison'
                    Parameters = @{
                        #OverwriteName = { "Trust status | Source $($_.'TrustSource'), Target $($_.'TrustTarget'), Direction $($_.'TrustDirection')" }
                        Property      = 'Status'
                        ExpectedValue = $true
                        OperationType = 'eq'
                        OverwriteName = { "Property $($_.Name)" }
                    }
                    Details    = [ordered] @{
                        Category    = $Source.Category
                        Importance  = 5
                        ActionType  = 2
                        StatusTrue  = 1
                        StatusFalse = 5
                    }
                }
            }
            DataHighlights = {
                New-HTMLTableCondition -Name 'Status' -ComparisonType bool -BackgroundColor PaleGreen -Value $true -Operator eq -FailBackgroundColor Salmon
            }
        }
        $ListNewSources.Add($Source.Name)
    }
    if ($ListNewSources.Count -gt 0) {
        Out-Informative -Text 'Following baseline sources were added' -Level 0 -Status $true -ExtendedValue ($ListNewSources -join ', ') -OverrideTextStatus "External Baselines"
    }
    if ($ListOverwritten.Count -gt 0) {
        Out-Informative -Text 'Following baseline sources overwritten' -Level 0 -Status $true -ExtendedValue ($ListOverwritten -join ', ') -OverrideTextStatus "Overwritten Baselines"
    }
}