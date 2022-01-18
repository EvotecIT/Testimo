function Add-TestimoSources {
    [CmdletBinding()]
    param(
        [string[]] $FolderPath
    )
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
                $Script:TestimoConfiguration[$Source.Scope][$Source.Source.Name] = $Source
            }
        }
    }
}