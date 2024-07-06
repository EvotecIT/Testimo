function New-ChartData {
    <#
    .SYNOPSIS
    Creates a chart data structure based on the input results.

    .DESCRIPTION
    This function takes an array of results and generates a chart data structure that counts the occurrences of each assessment. If an assessment is null, it is categorized as 'Skipped'.

    .PARAMETER Results
    The array of results to generate the chart data from.

    .EXAMPLE
    $results = @(
        [PSCustomObject]@{ Assessment = 'Pass' },
        [PSCustomObject]@{ Assessment = 'Fail' },
        [PSCustomObject]@{ Assessment = 'Pass' },
        [PSCustomObject]@{ Assessment = $null },
        [PSCustomObject]@{ Assessment = 'Pass' }
    )
    New-ChartData -Results $results

    This example creates a chart data structure based on the provided results array.

    #>
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