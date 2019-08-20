$Script:SBDomainPasswordComplexity = {
    # Imports all commands / including private ones from PSWinDocumentation.AD
    $ADModule = Import-Module PSWinDocumentation.AD -PassThru
    & $ADModule { param($Domain); Get-WinADDomainDefaultPasswordPolicy -Domain $Domain } $Domain
}
<#
$Script:SBDomainPasswordComplexityTest1 = {
    Test-Value -TestName 'Complexity Enabled' -Property 'Complexity Enabled' @args
}
$Script:SBDomainPasswordComplexityTest2 = {
    Test-Value -TestName 'Lockout Duration' -Property 'Lockout Duration' @args
}
$Script:SBDomainPasswordComplexityTest3 = {
    Test-Value -TestName 'Lockout Observation Window' -Property 'Lockout Observation Window' @args
}
$Script:SBDomainPasswordComplexityTest4 = {
    Test-Value -TestName 'Lockout Threshold' -Property 'Lockout Threshold' @args
}
$Script:SBDomainPasswordComplexityTest5 = {
    Test-Value -TestName 'Max Password Age' -Property 'Max Password Age' @args
}
$Script:SBDomainPasswordComplexityTest6 = {
    Test-Value -TestName 'Min Password Length' -Property 'Min Password Length' @args
}
$Script:SBDomainPasswordComplexityTest7 = {
    Test-Value -TestName 'Min Password Age' -Property 'Min Password Age' @args
}
$Script:SBDomainPasswordComplexityTest8 = {
    Test-Value -TestName 'Password History Count' -Property 'Password History Count' @args
}
$Script:SBDomainPasswordComplexityTest9 = {
    Test-Value -TestName 'Reversible Encryption Enabled' -Property 'Reversible Encryption Enabled' @args
}
#>