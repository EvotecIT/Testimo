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
        [System.Collections.IDictionary] $SourceDetails,
        [System.Collections.IDictionary] $TestDetails,
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

    $Output = [PSCustomObject]@{
        Name             = $TestText
        Type             = $TestType
        Status           = $Status
        Extended         = $ExtendedValue
        Domain           = $Domain
        DomainController = $DomainController
    }

    if ($Domain -and $DomainController) {
        $Script:Reporting['Domains'][$Domain]['DomainControllers'][$DomainController]['Tests'][$ReferenceID]['Results'].Add($Output)
    } elseif ($Domain) {
        $Script:Reporting['Domains'][$Domain]['Tests'][$ReferenceID]['Results'].Add($Output)
    } else {
        $Script:Reporting['Forest']['Tests'][$ReferenceID]['Results'].Add($Output)
    }
    $Script:TestResults.Add($Output)
}