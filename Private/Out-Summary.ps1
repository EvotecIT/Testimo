function Out-Summary {
    param(
        $Time,
        $Text
    )
    $EndTime = Stop-TimeLog -Time $Time -Option OneLiner

    # Write-Color -Text ' [', $Text, ']', " [", "Time:" $ExtendedValue, "]" -Color $Color

    Write-Color -Text '[i] ', $Text, ' [', 'Time to execute tests: ', $EndTime, ']' -Color Cyan, Yellow, Cyan, DarkGray
    #Write-Color -Text '[i] ', 'Tests Passed: ', $TestsPassed, ' Tests Failed: ', $TestsFailed, ' Tests Skipped: ', $TestsSkipped -Color Yellow, DarkGray, Green, DarkGray, Red, DarkGray, Cyan
}