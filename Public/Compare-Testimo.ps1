function Compare-Testimo {
    [cmdletbinding(DefaultParameterSetName = 'JSON')]
    param(
        [parameter(Mandatory, ParameterSetName = 'Object')]
        [parameter(Mandatory, ParameterSetName = 'JSON')]
        [string] $Name,

        [parameter(ParameterSetName = 'Object')]
        [parameter(ParameterSetName = 'JSON')]
        [parameter()][string] $DisplayName,

        [parameter(Mandatory, ParameterSetName = 'Object')]
        [parameter(Mandatory, ParameterSetName = 'JSON')]
        [string] $Scope,

        [parameter(ParameterSetName = 'Object')]
        [parameter(ParameterSetName = 'JSON')]
        [string] $Category = 'Baseline',

        [parameter(Mandatory, ParameterSetName = 'Object')][Object] $BaseLineSource,
        [parameter(Mandatory, ParameterSetName = 'Object')][Object] $BaseLineTarget,
        [parameter(Mandatory, ParameterSetName = 'JSON')][Object] $BaseLineSourcePath,
        [parameter(Mandatory, ParameterSetName = 'JSON')][Object] $BaseLineTargetPath,

        [parameter(ParameterSetName = 'Object')]
        [parameter(ParameterSetName = 'JSON')]
        [string[]] $ExcludeProperty
    )


    if ($PSBoundParameters.ContainsKey("BaseLineSourcePath")) {
        $BaseLineSource = Get-Content -LiteralPath $BaseLineSourcePath -Raw | ConvertFrom-Json
        $BaseLineTarget = Get-Content -LiteralPath $BaseLineTargetPath -Raw | ConvertFrom-Json
    }
    @{
        Name            = $Name
        DisplayName     = if ($DisplayName) { $DisplayName } else { $Name }
        Scope           = $Scope
        Category        = $Category
        BaseLineSource  = $BaseLineSource
        BaseLineTarget  = $BaseLineTarget
        ExcludeProperty = $ExcludeProperty
    }
}