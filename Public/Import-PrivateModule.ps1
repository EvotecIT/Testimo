function Import-PrivateModule {
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