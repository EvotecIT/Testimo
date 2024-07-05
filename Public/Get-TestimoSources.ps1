function Get-TestimoSources {
    <#
    .SYNOPSIS
    Retrieves information about Testimo data sources.

    .DESCRIPTION
    This function retrieves detailed information about Testimo data sources based on the provided source names. It returns information such as source name, scope, tests available, area, category, tags, severity, risk level, description, resolution, and resources.

    .PARAMETER Sources
    Specifies an array of source names to retrieve information for.

    .PARAMETER SourcesOnly
    Indicates whether to return only the list of source names without additional details.

    .PARAMETER Enabled
    Indicates whether to retrieve information only for enabled sources.

    .PARAMETER Advanced
    Indicates whether to include advanced details for each source.

    .EXAMPLE
    Example 1
    ----------------
    Get-TestimoSources -Sources "DomainComputersUnsupported", "DomainDHCPAuthorized"

    .EXAMPLE
    Example 2
    ----------------
    Get-TestimoSources -Sources "DomainComputersUnsupported", "DomainDHCPAuthorized" -Advanced

    #>
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