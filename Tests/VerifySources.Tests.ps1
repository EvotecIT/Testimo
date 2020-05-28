Describe 'Testimo Sources' {
    $TestimoSources = Get-TestimoSources -Advanced
    foreach ($Source in $TestimoSources) {
        It "Source $($Source.Source) should contain Enable key and be enabled or disabled" -TestCases @{ Source = $Source } {
            $Source.Advanced.Enable | Should -BeIn @($True, $False)
        }
        It "Source $($Source.Source) should contain Source Key" -TestCases @{ Source = $Source } {
            $Source.Advanced.Keys | Should -Contain 'Source'
        }
        It "Source $($Source.Source) should contain 6 in Source Details" -TestCases @{ Source = $Source } {
            $Keys = @(
                'Area'
                'Category'
                'Severity'
                'RiskLevel'
                'Description'
                'Resolution'
                'Resources'
            )
            $Source.Advanced.Source.Details.Keys | Sort-Object | Should -Be ($Keys | Sort-Object)
        }
    }
}