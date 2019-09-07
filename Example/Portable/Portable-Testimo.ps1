function Initialize-ModulePortable {
    [CmdletBinding()]
    param(
        [alias('ModuleName')][string] $Name,
        [string] $Path = $PSScriptRoot,
        [switch] $Download
    )
    if (-not $Name) {
        Write-Warning "Initialize-ModulePortable - Module name not given. Terminating."
        return
    }
    if ($Download) {
        try {
            Save-Module -Name $Name -LiteralPath $Path -WarningVariable WarningData -WarningAction SilentlyContinue -ErrorAction Stop
        } catch {
            $ErrorMessage = $_.Exception.Message

            if ($WarningData) {
                Write-Warning "Initialize-ModulePortable - $WarningData"
            }
            Write-Warning "Initialize-ModulePortable - Error $ErrorMessage"
            return
        }
    }

    $PrimaryModule = Get-ChildItem -LiteralPath "$Path\$Name" -Filter '*.psd1' -Recurse -ErrorAction SilentlyContinue -Depth 1
    $PrimaryModuleInformation = Get-Module -ListAvailable $PrimaryModule.FullName
    [Array] $RequiredModules = $PrimaryModuleInformation.RequiredModules.Name
    foreach ($_ in $RequiredModules) {
        $ListModules = Get-ChildItem -LiteralPath "$Path\$_" -Filter '*.psd1' -Recurse -ErrorAction SilentlyContinue -Depth 1
        Import-Module -Name $ListModules.FullName -Force -ErrorAction SilentlyContinue -Verbose
    }
    Import-Module -Name $PrimaryModule.FullName-Force -ErrorAction SilentlyContinue -Verbose
}

Initialize-ModulePortable -Name 'testimo' -Path $PSScriptRoot -Download

# Invoke-Testimo