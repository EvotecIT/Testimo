$Script:Importance = @{
    0  = 'Informational'
    1  = 'Negligible'
    2  = 'Very low'
    3  = 'Low'
    4  = 'Minor'
    5  = 'Moderate Low'
    6  = 'Moderate'
    7  = 'High'
    8  = 'Very High'
    9  = 'Significant'
    10 = 'Extreme'
}
$Script:StatusTranslation = @{
    -1 = 'Skipped'
    0  = 'Informational' # #4D9F6F # Low risk
    1  = 'Good'
    2  = 'Low' # #507DC6 # General Risk
    3  = 'Elevated' # #998D16 # Significant Risk
    4  = 'High' # #7A5928 High Risk
    5  = 'Severe' # #D65742 Server Risk
}

$Script:StatusToColors = @{
    'Skipped'       = 'DeepSkyBlue'
    'Informational' = 'ElectricBlue'
    'Good'          = 'LawnGreen'
    'Low'           = 'ParisDaisy' #  # General Risk
    'Elevated'      = 'SafetyOrange' #  # Significant Risk
    'High'          = 'InternationalOrange' #  High Risk
    'Severe'        = 'TorchRed' #  Server Risk
}

$Script:StatusTranslationColors = @{
    -1 = 'DeepSkyBlue'
    0  = 'ElectricBlue'
    1  = 'LawnGreen'
    2  = 'ParisDaisy' #  # General Risk
    3  = 'SafetyOrange' #  # Significant Risk
    4  = 'InternationalOrange' #  High Risk
    5  = 'TorchRed' #  Server Risk
}
$Script:ActionType = @{
    0 = 'Informational'
    1 = 'Recommended'
    2 = 'Must Implement'
}
$Script:StatusTranslationConsoleColors = @{
    -1 = [System.ConsoleColor]::DarkBlue
    0  = [System.ConsoleColor]::DarkBlue
    1  = [System.ConsoleColor]::Green
    2  = [System.ConsoleColor]::Magenta #  # General Risk
    3  = [System.ConsoleColor]::DarkMagenta #  # Significant Risk
    4  = [System.ConsoleColor]::Red #  High Risk
    5  = [System.ConsoleColor]::DarkRed #  Server Risk
}

<#
$Script:WarningSystem = @{
    0 = 'All Clear'
    1 = 'Advice'
    2 = 'Watch and Act'
    3 = 'Emergency Warning'
}
$Script:PotentialImpact = @{
    0 = 'Neglible'
    1 = 'Minor'
    3 = 'Moderate'
    4 = 'Significant'
    5 = 'Severe'
}
$Script:Likelihood = @{
    0 = 'Very Unlikely'
    1 = 'Unlikely'
    2 = 'Possible'
    3 = 'Likely'
    4 = 'Very Likely'
}
$Script:Consequence = @{
    0 = 'Small'
    1 = 'Moderate'
    2 = 'Severe'
    3 = 'Catastrophic'
}
#>