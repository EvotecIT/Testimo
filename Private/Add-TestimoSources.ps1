function Add-TestimoSources {
    [CmdletBinding()]
    param(
        [string[]] $FolderPath
    )
    $ListNewSources = [System.Collections.Generic.List[string]]::new()
    $ListOverwritten = [System.Collections.Generic.List[string]]::new()
    foreach ($Folder in $FolderPath) {
        $FilesWithCode = @( Get-ChildItem -Path "$Folder\*.ps1" -ErrorAction SilentlyContinue -Recurse )

        Foreach ($import in $FilesWithCode) {
            $Content = Get-Content -LiteralPath $import.fullname -Raw
            $Script = [scriptblock]::Create($Content)
            $Data = $Script.Invoke()
            foreach ($Source in $Data) {
                if (-not $Script:TestimoConfiguration[$Source.Scope]) {
                    $Script:TestimoConfiguration[$Source.Scope] = [ordered] @{}
                }
                if ($Source.Scope -in 'Forest', 'Domain', 'DC') {
                    if ($Script:TestimoConfiguration['ActiveDirectory'][$Source.Name]) {
                        $ListOverwritten.Add($Source.Name)
                    } else {
                        $ListNewSources.Add($Source.Name)
                    }
                    $Script:TestimoConfiguration['ActiveDirectory'][$Source.Name] = $Source
                } else {
                    $Script:TestimoConfiguration[$Source.Scope][$Source.Name] = $Source
                    $ListNewSources.Add($Source.Name)
                }
            }
        }
    }
    if ($ListNewSources.Count -gt 0) {
        Out-Informative -Text 'Following external sources were added' -Level 0 -Status $true -ExtendedValue ($ListNewSources -join ', ') -OverrideTextStatus "External Sources"
    }
    if ($ListOverwritten.Count -gt 0) {
        Out-Informative -Text 'Following external sources overwritten' -Level 0 -Status $true -ExtendedValue ($ListOverwritten -join ', ') -OverrideTextStatus "Overwritten Sources"
    }
}