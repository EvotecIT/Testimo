Describe 'Testimo Configuration for Forest' {
    # Preparations
    $ImportedModule = Import-Module $PSScriptRoot\..\Testimo.psd1 -Force -PassThru
    $TestimoConfiguration = & $ImportedModule {
        $Script:TestimoConfiguration
    }

    foreach ($Key in $TestimoConfiguration['Forest'].Keys) {
        It -Name "Test Source $Key should not be NULL" {
            $TestimoConfiguration['Forest'].$Key | Should -Not -Be $Null
        }
        It -Name "Test Source $Key should contain Enable" {
            $TestimoConfiguration['Forest'].$Key.Keys | Should -Contain 'Enable'
        }
        It -Name "Test Source $Key should contain Source" {
            $TestimoConfiguration['Forest'].$Key.Keys | Should -Contain 'Source'
        }
    }
}

Describe 'Testimo Configuration for Domains' {
    # Preparations
    $ImportedModule = Import-Module $PSScriptRoot\..\Testimo.psd1 -Force -PassThru
    $TestimoConfiguration = & $ImportedModule {
        $Script:TestimoConfiguration
    }

    It -Name 'Should contain roles' {
        $TestimoConfiguration['Domain'].Keys | Should -Contain 'Roles'
    }
    foreach ($Key in $TestimoConfiguration['Domain'].Keys) {
        It -Name "Test Source $Key should not be NULL" {
            $TestimoConfiguration['Domain'].$Key | Should -Not -Be $Null
        }
        It -Name "Test Source $Key should contain Enable" {
            $TestimoConfiguration['Domain'].$Key.Keys | Should -Contain 'Enable'
        }
        It -Name "Test Source $Key should contain Source" {
            $TestimoConfiguration['Domain'].$Key.Keys | Should -Contain 'Source'
        }
    }
}

Describe 'Testimo Configuration for DomainControllers' {
    # Preparations
    $ImportedModule = Import-Module $PSScriptRoot\..\Testimo.psd1 -Force -PassThru
    $TestimoConfiguration = & $ImportedModule {
        $Script:TestimoConfiguration
    }

    foreach ($Key in $TestimoConfiguration['DomainControllers'].Keys) {
        It -Name "Test Source $Key should not be NULL" {
            $TestimoConfiguration['DomainControllers'].$Key | Should -Not -Be $Null
        }
        It -Name "Test Source $Key should contain Enable" {
            $TestimoConfiguration['DomainControllers'].$Key.Keys | Should -Contain 'Enable'
        }
        It -Name "Test Source $Key should contain Source" {
            $TestimoConfiguration['DomainControllers'].$Key.Keys | Should -Contain 'Source'
        }
    }
}