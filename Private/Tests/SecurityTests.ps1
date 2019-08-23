$Script:KeberosAccountTimeChange = {
    Get-ADUser krbtgt -Properties Created, PasswordLastSet, msDS-KeyVersionNumber -Server $Domain
}

$Script:GroupsAccountOperators = {
    # Account Operators'
    Get-ADGroupMember -Identity 'S-1-5-32-548' -Recursive -Server $Domain
}

$Script:UsersAccountAdministrator = {
    # this test is kind of special
    # basically when account is disabled it doesn't make sense to check for PasswordLastSet
    # therefore i'm adding setting PasswordLastSet to current date to be able to test just that field
    # At least until support for multiple checks is added

    $DomainSID = (Get-ADDomain -Server $Domain).DomainSID
    $User = Get-ADUser -Identity "$DomainSID-500" -Properties PasswordLastSet, LastLogonDate, servicePrincipalName -Server $Domain
    if ($User.Enabled -eq $false) {
        [PSCustomObject] @{
            Name            = 'Administrator'
            PasswordLastSet = Get-Date
        }
    } else {
        [PSCustomObject] @{
            Name            = 'Administrator'
            PasswordLastSet = $User.PasswordLastSet
        }
    }
}