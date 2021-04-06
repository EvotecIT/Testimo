Import-Module $PSScriptRoot\..\Testimo.psd1 -Force #-Verbose

# this will get you single source
#Get-TestimoSources -Sources DCDiagnostics

#
Get-TestimoSources | Format-Table *
#Get-TestimoSources | Out-HtmlView