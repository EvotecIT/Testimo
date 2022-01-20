function Initialize-TestimoTests {
    <#
    .SYNOPSIS
    Simple command that goes thru all the tests and makes sure minimal tests are "improved" to become standard test

    .DESCRIPTION
    Simple command that goes thru all the tests and makes sure minimal tests are "improved" to become standard test

    .EXAMPLE
    Initialize-TestimoTests

    .NOTES
    General notes
    #>
    [CmdletBinding()]
    param()

    foreach ($Key in $Script:TestimoConfiguration.Keys) {
        if ($Key -notin 'Types', 'Exclusions', 'Inclusions', 'Debug') {
            foreach ($Source in [string[]] $Script:TestimoConfiguration[$Key].Keys) {
                foreach ($TestName in [string[]] $Script:TestimoConfiguration[$Key][$Source].Tests.Keys) {
                    $TestValue = $Script:TestimoConfiguration[$Key][$Source].Tests.$TestName
                    if ($TestValue -is [System.Collections.IDictionary]) {

                    } else {
                        # we use configuration as default category
                        $DefaultCategory = 'Configuration'
                        # but we also check if source has something different and we use it
                        if ($Script:TestimoConfiguration[$Key][$Source].Source.Details -and $Script:TestimoConfiguration[$Key][$Source].Source.Details.Category) {
                            $DefaultCategory = $Script:TestimoConfiguration[$Key][$Source].Source.Details.Category
                        }

                        # Overwrite the test value with the default settings
                        # This is to support basic paramters testing in a way that DSC does
                        $Script:TestimoConfiguration[$Key][$Source].Tests.$TestsName = [ordered] @{
                            Enable     = $true
                            Name       = $TestName
                            Parameters = @{
                                OperationType = 'eq'
                                ExpectedValue = $TestValue
                            }
                            Details    = [ordered] @{
                                Category    = $DefaultCategory
                                Importance  = 5
                                ActionType  = 2
                                StatusTrue  = 1
                                StatusFalse = 5
                            }
                        }
                    }
                }
            }
        }
    }
}