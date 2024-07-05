function Import-PrivateModule {
    <#
    .SYNOPSIS
    Imports a private module by name.

    .DESCRIPTION
    This function imports a private module by name. It attempts to import the module specified by the given name. If the module is not found in the standard module directories, it looks for the module in the loaded modules.

    .PARAMETER Name
    Specifies the name of the private module to import.

    .PARAMETER Portable
    Indicates whether the module should be imported as portable.

    .EXAMPLE
    Example 1
    ----------------
    Import-PrivateModule -Name "MyPrivateModule"

    .EXAMPLE
    Example 2
    ----------------
    Import-PrivateModule -Name "MyPrivateModule" -Portable

    #>
    [cmdletBinding()]
    param(
        [string] $Name,
        [switch] $Portable
    )
    try {
        $ADModule = Import-Module -PassThru -Name $Name -ErrorAction Stop
    } catch {
        if ($_.Exception.Message -like '*was not loaded because no valid module file was found in any module directory*') {
            $Module = Get-Module -Name $Name
            #$PSD1 = -join ($Name, ".psd1")
            #$Module = [io.path]::Combine($Module.ModuleBase, $PSD1)
            if ($Module) {
                $ADModule = Import-Module $Module -PassThru
            }
        }
    }
    $ADModule
}