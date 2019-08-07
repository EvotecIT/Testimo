<#
$Script:SBDomainPasswordComplexity = {
    param(
        [string] $Domain
    )

    Start-TestProcessing -Test "Password Complexity Requirements ($Domain)" -Level 1 -Data {
        & $ADModule { param($Domain); Get-WinADDomainDefaultPasswordPolicy -Domain $Domain } $Domain
    } -Tests {
        Test-Value -TestName 'Complexity Enabled' -Property 'Complexity Enabled' -ExpectedValue $true
        Test-Value -TestName 'Lockout Duration' -Property 'Lockout Duration' -gt -ExpectedValue 30
        Test-Value -TestName 'Lockout Observation Window' -Property 'Lockout Observation Window' -ge -ExpectedValue 30
        Test-Value -TestName 'Lockout Threshold' -Property 'Lockout Duration' -gt -ExpectedValue 5
        Test-Value -TestName 'Max Password Age' -Property 'Max Password Age' -le -ExpectedValue 60
        Test-Value -TestName 'Min Password Length' -Property 'Min Password Length' -gt -ExpectedValue 8
        Test-Value -TestName 'Min Password Age' -Property 'Min Password Age' -le -ExpectedValue 1
        Test-Value -TestName 'Password History Count' -Property 'Password History Count' -ge -ExpectedValue 10
        Test-Value -TestName 'Reversible Encryption Enabled' -Property 'Reversible Encryption Enabled' -ExpectedValue $true
    }
}
#>
$Script:SBDomainPasswordComplexity = {
    & $ADModule { param($Domain); Get-WinADDomainDefaultPasswordPolicy -Domain $Domain } $Domain
}
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