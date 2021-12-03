function New-ChartData {
    [cmdletBinding()]
    param(
        $Results
    )
    $ChartData = [ordered] @{}
    foreach ($Result in $Results) {
        if ($null -ne $Result.Assessment) {
            if (-not $ChartData[$Result.Assessment]) {
                $ChartData[$Result.Assessment] = [ordered] @{
                    Count = 0
                    Color = $Script:StatusToColors[$Result.Assessment]
                }
            }
            $ChartData[$Result.Assessment].Count++
        } else {
            # if for whatever reason result.assesment is null we need to improvise
            if (-not $ChartData['Skipped']) {
                $ChartData['Skipped'] = [ordered] @{
                    Count = 0
                    Color = $Script:StatusToColors['Skipped']
                }
            }
            $ChartData['Skipped'].Count++
        }
    }
    $ChartData
}