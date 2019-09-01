Import-Module .\Testimo.psd1 -Force #-Verbose

# There are 3 ways to deal with configuration

# Straight to FILE/JSON
Get-TestimoConfiguration -FilePath $PSScriptRoot\Configuration\TestimoConfiguration.json

# Straight to JSON
Get-TestimoConfiguration -AsJson

# Output to Hashtable so you can edit it freely and keep in ps1
$OutputOrderedDictionary = Get-TestimoConfiguration
$OutputOrderedDictionary.Forest.OptionalFeatures.Tests.RecycleBinEnabled.Enable = $false
$OutputOrderedDictionary.Forest.OptionalFeatures.Tests.LapsAvailable.Enable = $true
$OutputOrderedDictionary.Forest.OptionalFeatures.Tests.LapsAvailable.Parameters.ExpectedValue = $false