function Start-TestimoReport {
    [CmdletBinding()]
    param(
        [System.Collections.IDictionary] $TestResults,
        [string] $FilePath,
        [switch] $Online,
        [switch] $ShowHTML,
        [switch] $HideSteps,
        [switch] $AlwaysShowSteps,
        [string[]] $Scopes,
        [switch] $SplitReports
    )
    if ($FilePath -eq '') {
        $FilePath = Get-FileName -Extension 'html' -Temporary
    }

    $ColorPassed = 'LawnGreen'
    $ColorSkipped = 'DeepSkyBlue'
    $ColorFailed = 'TorchRed'
    $ColorPassedText = 'Black'
    $ColorFailedText = 'Black'
    $ColorSkippedText = 'Black'

    $TestResults['Configuration'] = @{
        Colors = @{
            ColorPassed      = $ColorPassed
            ColorSkipped     = $ColorSkipped
            ColorFailed      = $ColorFailed
            ColorPassedText  = $ColorPassedText
            ColorFailedText  = $ColorFailedText
            ColorSkippedText = $ColorSkippedText
        }
    }
    $TestResults['Configuration']['ResultConditions'] = {
        #New-TableCondition -Name 'Status' -Value $true -BackgroundColor 'LawnGreen'
        # #New-TableCondition -Name 'Status' -Value $false -BackgroundColor 'Tomato'
        # New-TableCondition -Name 'Status' -Value $null -BackgroundColor 'DeepSkyBlue'
        foreach ($Status in $Script:StatusTranslation.Keys) {
            New-HTMLTableCondition -Name 'Assessment' -Value $Script:StatusTranslation[$Status] -BackgroundColor $Script:StatusTranslationColors[$Status] #-Row
        }
        New-HTMLTableCondition -Name 'Assessment' -Value $true -BackgroundColor $TestResults['Configuration']['Colors']['ColorPassed'] -Color $TestResults['Configuration']['Colors']['ColorPassedText'] #-Row
        New-HTMLTableCondition -Name 'Assessment' -Value $false -BackgroundColor $TestResults['Configuration']['Colors']['ColorFailed'] -Color $TestResults['Configuration']['Colors']['ColorFailedText'] #-Row
    }
    $TestResults['Configuration']['ResultConditionsEmail'] = {
        $Translations = @{
            -1 = 'Skipped'
            0  = 'Informational' # #4D9F6F # Low risk
            1  = 'Good'
            2  = 'Low' # #507DC6 # General Risk
            3  = 'Elevated' # #998D16 # Significant Risk
            4  = 'High' # #7A5928 High Risk
            5  = 'Severe' # #D65742 Server Risk
        }
        $TranslationsColors = @{
            -1 = 'DeepSkyBlue'
            0  = 'ElectricBlue'
            1  = 'LawnGreen'
            2  = 'ParisDaisy' #  # General Risk
            3  = 'SafetyOrange' #  # Significant Risk
            4  = 'InternationalOrange' #  High Risk
            5  = 'TorchRed' #  Server Risk
        }
        foreach ($Status in $Translations.Keys) {
            New-HTMLTableCondition -Name 'Assessment' -Value $Translations[$Status] -BackgroundColor $TranslationsColors[$Status] -Inline
        }
        New-HTMLTableCondition -Name 'Assessment' -Value $true -BackgroundColor 'LawnGreen' -Inline
        New-HTMLTableCondition -Name 'Assessment' -Value $false -BackgroundColor 'TorchRed' -Inline
    }
    # [Array] $PassedTests = $TestResults['Results'] | Where-Object { $_.Status -eq $true }
    # [Array] $FailedTests = $TestResults['Results'] | Where-Object { $_.Status -eq $false }
    # [Array] $SkippedTests = $TestResults['Results'] | Where-Object { $_.Status -ne $true -and $_.Status -ne $false }
    if ($SplitReports) {
        Start-TestimoReportHTMLWithSplit -TestResults $TestResults -FilePath $FilePath -Online:$Online -ShowHTML:$ShowHTML.IsPresent -HideSteps:$HideSteps.IsPresent -AlwaysShowSteps:$AlwaysShowSteps.IsPresent -Scopes $Scopes
    } else {
        Start-TestimoReportHTML -TestResults $TestResults -FilePath $FilePath -Online:$Online -ShowHTML:$ShowHTML.IsPresent -HideSteps:$HideSteps.IsPresent -AlwaysShowSteps:$AlwaysShowSteps.IsPresent -Scopes $Scopes
    }
}