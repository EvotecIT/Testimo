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
    function Get-RequiredModule {
        param(
            [string] $Path,
            [string] $Name
        )
        $PrimaryModule = Get-ChildItem -LiteralPath "$Path\$Name" -Filter '*.psd1' -Recurse -ErrorAction SilentlyContinue -Depth 1
        if ($PrimaryModule) {
            $Module = Get-Module -ListAvailable $PrimaryModule.FullName -ErrorAction SilentlyContinue -Verbose:$false
            if ($Module) {
                [Array] $RequiredModules = $Module.RequiredModules.Name
                $RequiredModules
                foreach ($_ in $RequiredModules) {
                    Get-RequiredModule -Path $Path -Name $_
                }
            }
        } else {
            Write-Warning "Initialize-ModulePortable - Modules to load not found in $Path"
        }
    }

    if (-not $Name) {
        Write-Warning "Initialize-ModulePortable - Module name not given. Terminating."
        return
    }
    if (-not $Download -and -not $Import) {
        Write-Warning "Initialize-ModulePortable - Please choose Download/Import switch. Terminating."
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

    if ($Download -or $Import) {
        [Array] $Modules = Get-RequiredModule -Path $Path -Name $Name | Where-Object { $null -ne $_ }
        [array]::Reverse($Modules)

        $CleanedModules = [System.Collections.Generic.List[string]]::new()

        foreach ($_ in $Modules) {
            if ($CleanedModules -notcontains $_) {
                $CleanedModules.Add($_)
            }
        }
        $CleanedModules.Add($Name)

        $Items = foreach ($_ in $CleanedModules) {
            Get-ChildItem -LiteralPath "$Path\$_" -Filter '*.psd1' -Recurse -ErrorAction SilentlyContinue -Depth 1
        }
        [Array] $PSD1Files = $Items.FullName
    }
    if ($Download) {
        $ListFiles = foreach ($PSD1 in $PSD1Files) {
            $PSD1.Replace("$Path", '$PSScriptRoot')
        }
        # Build File
        $Content = @(
            '$Modules = @('
            foreach ($_ in $ListFiles) {
                "   `"$_`""
            }
            ')'
            "foreach (`$_ in `$Modules) {"
            "   Import-Module `$_ -Verbose:`$false -Force"
            "}"
        )
        $Content | Set-Content -Path $Path\$Name.ps1 -Force
    }
    if ($Import) {
        $ListFiles = foreach ($PSD1 in $PSD1Files) {
            $PSD1
        }
        foreach ($_ in $ListFiles) {
            Import-Module $_ -Verbose:$false -Force
        }
    }
}

Initialize-ModulePortable -Name 'Testimo' -Path "$PSScriptRoot\TestimoPortable" -Download