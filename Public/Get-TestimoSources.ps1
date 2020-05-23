function Get-TestimoSources {
    [CmdletBinding()]
    param(
        [string[]] $Sources,
        [switch] $SourcesOnly,
        [switch] $Enabled,
        [switch] $Advanced
    )
    if (-not $Sources) {
        $Sources = @(
            $ForestKeys = $Script:TestimoConfiguration.Forest.Keys
            $DomainKeys = $Script:TestimoConfiguration.Domain.Keys
            $DomainControllerKeys = $Script:TestimoConfiguration.DomainControllers.Keys

            $TestSources = @(
                foreach ($Key in $ForestKeys) {
                    if ($Enabled) {
                        if ($Script:TestimoConfiguration.Forest["$Key"].Enable) {
                            "Forest$Key"
                        }
                    } else {
                        "Forest$Key"
                    }

                }
                foreach ($Key in $DomainKeys) {
                    if ($Enabled) {
                        if ($Script:TestimoConfiguration.Domain["$Key"].Enable) {
                            "Domain$Key"
                        }
                    } else {
                        "Domain$Key"
                    }
                }
                foreach ($Key in $DomainControllerKeys) {
                    if ($Enabled) {
                        if ($Script:TestimoConfiguration.DomainControllers["$Key"].Enable) {
                            "DC$Key"
                        }
                    } else {
                        "DC$Key"
                    }
                }
            )
            $TestSources | Sort-Object
        )
    }
    if ($SourcesOnly) {
        return $TestSources
    }

    foreach ($S in $Sources) {
        $DetectedSource = ConvertTo-Source -Source $S
        $Scope = $DetectedSource.Scope
        $Name = $DetectedSource.Name
        $Object = [ordered]@{
            Source = $S
            Scope  = $Scope
            Name   = $Name
            Tests  = $Script:TestimoConfiguration.$Scope[$Name].Tests.Keys
        }
        $Object['Area'] = $Script:TestimoConfiguration.$Scope[$Name].Source.Details.Area
        $Object['Category'] = $Script:TestimoConfiguration.$Scope[$Name].Source.Details.Category
        #$Object['Tags'] = $Script:TestimoConfiguration.$Scope[$Name].Source.Details.Tags
        $Object['Severity'] = $Script:TestimoConfiguration.$Scope[$Name].Source.Details.Severity
        $Object['RiskLevel'] = $Script:TestimoConfiguration.$Scope[$Name].Source.Details.RiskLevel
        $Object['Description'] = $Script:TestimoConfiguration.$Scope[$Name].Source.Details.Description
        $Object['Resolution'] = $Script:TestimoConfiguration.$Scope[$Name].Source.Details.Resolution
        $Object['Resources'] = $Script:TestimoConfiguration.$Scope[$Name].Source.Details.Resources

        if ($Advanced) {
            $Object['Advanced'] = $Script:TestimoConfiguration.$Scope[$Name]
        }
        [PSCustomObject] $Object
    }
}