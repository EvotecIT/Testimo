function Get-TestimoSources {
    [CmdletBinding()]
    param(
        [string[]] $Source
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
                "Forest$Key"
            }
            foreach ($Key in $DomainKeys) {
                "Domain$Key"
            }
            foreach ($Key in $DomainControllerKeys) {
                "DC$Key"
            }
        )
        $TestSources | Sort-Object
    }
}