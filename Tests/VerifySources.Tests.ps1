Describe 'Testimo Sources' {
    $TestimoSources = Get-TestimoSources -Advanced
    foreach ($Source in $TestimoSources) {
        It "Source $($Source.Source) should contain Enable key and be enabled or disabled" {
            $Source.Advanced.Enable | Should -BeIn @($True, $False)
        }
        It "Source $($Source.Source) should contain Source Key" {
            $Source.Advanced.Keys | Should -Contain 'Source'
        }
    }
}