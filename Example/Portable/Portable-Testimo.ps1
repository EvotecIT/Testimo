function Get-TestimoPortable {
    [CmdletBinding()]
    param(
        [string] $Path = $PSScriptRoot,
        [switch] $Download
    )
    if ($Download) {
        try {
            Save-Module -Name 'Testimo' -LiteralPath $Path -WarningVariable WarningData -WarningAction SilentlyContinue -ErrorAction Stop
        } catch {
            $ErrorMessage = $_.Exception.Message
            if ($ErrorMessage -like "*Unable to save the module 'Testimo'*") {
                if ($WarningData -like '*Access to the path*DSInternals* is denied.') {
                    Write-Warning "Get-TestimoPortable - $WarningData"
                    Write-Warning "Get-TestimoPortable - Can't download DSInternals. Most likely DLL is already loaded. Please restart PowerShell and retry."
                    return
                }
            } else {
                Write-Warning "Get-TestimoPortable - $WarningData"
                Write-Warning "Get-TestimoPortable - Error $ErrorMessage"
                return
            }
        }
    }
    $ListModules = Get-ChildItem -LiteralPath $Path -Filter '*.psd1' -Recurse -ErrorAction SilentlyContinue
    foreach ($Module in $ListModules.FullName) {
        Import-Module -Name $Module -Force -ErrorAction SilentlyContinue
    }
}

Get-TestimoPortable -Download -Path $PSScriptRoot

# Invoke-Testimo