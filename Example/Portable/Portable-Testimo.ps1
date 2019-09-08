# This function is also part of the module PSSharedGoods. If you have it, you don't need to copy paste anything except the command below
# Install-Module PSSharedGoods

function Initialize-ModulePortable {
    [CmdletBinding()]
    param(
        [alias('ModuleName')][string] $Name,
        [string] $Path = $PSScriptRoot,
        [switch] $Download,
        [switch] $Import
    )
    if (-not $Name) {
        Write-Warning "Initialize-ModulePortable - Module name not given. Terminating."
        return
    }
    if ($Download) {
        try {
            if (-not $Path -or -not (Test-Path -LiteralPath $Path)) {
                $null = New-Item -ItemType Directory -Path $Path -Force
            }
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
    if ($PrimaryModule) {
        $PrimaryModuleInformation = Get-Module -ListAvailable $PrimaryModule.FullName -ErrorAction SilentlyContinue
        if ($PrimaryModuleInformation) {
            if ($Import) {
                [Array] $RequiredModules = $PrimaryModuleInformation.RequiredModules.Name
                foreach ($_ in $RequiredModules) {
                    $ListModules = Get-ChildItem -LiteralPath "$Path\$_" -Filter '*.psd1' -Recurse -ErrorAction SilentlyContinue -Depth 1
                    Import-Module -Name $ListModules.FullName -Force -ErrorAction SilentlyContinue -Verbose
                }
                Import-Module -Name $PrimaryModule.FullName -Force -ErrorAction SilentlyContinue -Verbose
            }
            $Content = @"
    `$Name = '$Name'
    `$Path = `$PSScriptRoot
    `$PrimaryModule = Get-ChildItem -LiteralPath "`$Path\`$Name" -Filter '*.psd1' -Recurse -ErrorAction SilentlyContinue -Depth 1
    `$PrimaryModuleInformation = Get-Module -ListAvailable `$PrimaryModule.FullName
    [Array] `$RequiredModules = `$PrimaryModuleInformation.RequiredModules.Name
    foreach (`$_ in `$RequiredModules) {
        `$ListModules = Get-ChildItem -LiteralPath "`$Path\`$_" -Filter '*.psd1' -Recurse -ErrorAction SilentlyContinue -Depth 1
        Import-Module -Name `$ListModules.FullName -Force -ErrorAction SilentlyContinue -Verbose
    }
    Import-Module -Name `$PrimaryModule.FullName -Force -ErrorAction SilentlyContinue -Verbose
"@
            $Content | Set-Content -Path $Path\$Name.ps1 -Force
        } else {
            Write-Warning "Initialize-ModulePortable - Primary module is not available. Did you use Download switch?"
        }
    } else {
        Write-Warning "Initialize-ModulePortable - Primary module is not available. Did you use Download switch?"
    }
}

Initialize-ModulePortable -Name 'Testimo' -Path "$PSScriptRoot\TestimoPortable" -Download