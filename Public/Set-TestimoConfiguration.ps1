
function Set-TestimoConfiguration {
    param(

    )

    [string] $AllUserReportsPath = "$Env:ALLUSERSPROFILE\Evotec\Testimo"
    [string] $CurrentUserReportsPath = "$Env:USERPROFILE\Evotec\Testimo"


    #$CurrentConfiguration = $CurrentUserReportsPath


    $CurrentConfig = 'C:\Support\GitHub\Testimo\Example\Config.json'

    $ConfigExists = if (Test-Path -LiteralPath $CurrentConfig) {

    } else {
        $Script:TestimoConfiguration | ConvertTo-Json -Depth 10 | Out-File -FilePath $CurrentConfig
    }

}