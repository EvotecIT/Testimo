function Get-TestimoSources {
    [CmdletBinding()]
    param(
        [string[]] $Source,
        [switch] $Enabled
    )
    if ($Source) {
        $DetectedSource = ConvertTo-Source -Source $Source
        $Scope = $DetectedSource.Scope
        $Name = $DetectedSource.Name
        $Script:TestimoConfiguration.$Scope[$Name].Tests.Keys

    } else {
        $ForestKeys = $TestimoConfiguration.Forest.Keys
        $DomainKeys = $TestimoConfiguration.Domain.Keys
        $DomainControllerKeys = $TestimoConfiguration.DomainControllers.Keys

        $TestSources = @(
            foreach ($Key in $ForestKeys) {
                if ($Enabled) {
                    if ($TestimoConfiguration.Forest["$Key"].Enable) {
                        "Forest$Key"
                    }
                } else {
                    "Forest$Key"
                }

            }
            foreach ($Key in $DomainKeys) {
                if ($Enabled) {
                    if ($TestimoConfiguration.Domain["$Key"].Enable) {
                        "Domain$Key"
                    }
                } else {
                    "Domain$Key"
                }
            }
            foreach ($Key in $DomainControllerKeys) {
                if ($Enabled) {
                    if ($TestimoConfiguration.DomainControllers["$Key"].Enable) {
                        "DC$Key"
                    }
                } else {
                    "DC$Key"
                }
            }
        )
        $TestSources | Sort-Object
    }
}