$PSVersionTable.PSVersion

$ModuleName = (Get-ChildItem $PSScriptRoot\*.psd1).BaseName
$RequiredModules = @(
    'PSSharedGoods'
    @{ Name = 'Pester'; MaximumVersion = '4.99.99.99' }
)
foreach ($_ in $RequiredModules) {
    if ($_ -is [string]) {
        if ($null -eq (Get-Module -ListAvailable $_)) {
            Write-Warning "$ModuleName - Downloading $_ from PSGallery"
            Install-Module -Name $_ -Repository PSGallery -Force -SkipPublisherCheck
        }
        Import-Module $_ -Force
    } else {
        if ($null -eq (Get-Module -ListAvailable $_.Name)) {
            Write-Warning "$ModuleName - Downloading $_ from PSGallery"
            Install-Module -Name $_ -Repository PSGallery -Force -SkipPublisherCheck
        }
        Import-Module $_.Name -Force -MaximumVersion $_.MaximumVersion
    }
}
Import-Module $PSScriptRoot\Testimo.psd1 -Force

$result = Invoke-Pester -Script $PSScriptRoot\Tests -Verbose -EnableExit

if ($result.FailedCount -gt 0) {
    throw "$($result.FailedCount) tests failed."
}