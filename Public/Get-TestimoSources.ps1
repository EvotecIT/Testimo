function Get-TestimoSources {
    [CmdletBinding()]
    param(
        [string[]] $Sources,
        [switch] $SourcesOnly,
        [switch] $Enabled,
        [switch] $Advanced
    )
    if (-not $Sources) {
        $Sources = $Script:TestimoConfiguration.ActiveDirectory.Keys
    }
    if ($SourcesOnly) {
        return $Sources
    }
    foreach ($S in $Sources) {
        $Object = [ordered]@{
            Source = $S
            Scope  = $Script:TestimoConfiguration.ActiveDirectory[$S].Scope
            Name   = $Script:TestimoConfiguration.ActiveDirectory[$S].Source.Name
            Tests  = $Script:TestimoConfiguration.ActiveDirectory[$S].Tests.Keys
        }
        $Object['Area'] = $Script:TestimoConfiguration.ActiveDirectory[$S].Source.Details.Area
        $Object['Category'] = $Script:TestimoConfiguration.ActiveDirectory[$S].Source.Details.Category
        $Object['Tags'] = $Script:TestimoConfiguration.ActiveDirectory[$S].Source.Details.Tags
        $Object['Severity'] = $Script:TestimoConfiguration.ActiveDirectory[$S].Source.Details.Severity
        $Object['RiskLevel'] = $Script:TestimoConfiguration.ActiveDirectory[$S].Source.Details.RiskLevel
        $Object['Description'] = $Script:TestimoConfiguration.ActiveDirectory[$S].Source.Details.Description
        $Object['Resolution'] = $Script:TestimoConfiguration.ActiveDirectory[$S].Source.Details.Resolution
        $Object['Resources'] = $Script:TestimoConfiguration.ActiveDirectory[$S].Source.Details.Resources
        if ($Advanced) {
            $Object['Advanced'] = $Script:TestimoConfiguration.ActiveDirectory[$S]
        }
        [PSCustomObject] $Object
    }
}