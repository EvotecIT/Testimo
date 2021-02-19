$Script:Importance = @{
    0  = 'Informational (0)'
    1  = 'Neglible (1)'
    2  = 'Very low (2)'
    3  = 'Low (3)'
    4  = 'Minor (4)'
    5  = 'Moderate Low (5)'
    6  = 'Moderate (6)'
    7  = 'High (7)'
    8  = 'Very High (8)'
    9  = 'Signiciant (9)'
    10 = 'Extream (10)'
}
$Script:StatusTranslation = @{
    0 = 'Low' # #4D9F6F # Low risk
    1 = 'Guarded' # #507DC6 # General Risk
    2 = 'Elevated' # #998D16 # Significant Risk
    3 = 'High' # #7A5928 High Risk
    4 = 'Severe' # #D65742 Server Risk
}
$Script:WarningSystem = @{
    0 = 'All Clear'
    1 = 'Advice'
    2 = 'Watch and Act'
    3 = 'Emergency Warning'
}
$Script:ActionType = @{
    0 = 'Informational'
    1 = 'Recommended'
    2 = 'Must Implement'
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