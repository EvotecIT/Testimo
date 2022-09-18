Import-Module .\Testimo.psd1 -Force

Invoke-Testimo -ExternalTests $PSScriptRoot\DSCSample -Sources AzureADConditionalPolicyDenyBasicAuth -Variables @{
    Authorization = $Authorization1
}