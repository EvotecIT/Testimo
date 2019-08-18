
function Set-TestimoConfiguration {
    param(

    )

    [string] $AllUserReportsPath = "$Env:ALLUSERSPROFILE\Evotec\Testimo"
    [string] $CurrentUserReportsPath = "$Env:USERPROFILE\Evotec\Testimo"


    $CurrentConfiguration = $CurrentUserReportsPath
}