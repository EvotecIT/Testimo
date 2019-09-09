$OrphanedAdmins = @{
    Enable = $true
    Source = @{
        Name           = 'Orphaned Administrative Objects (AdminCount)'
        Data           = {
            Get-WinADPriviligedObjects -OrphanedOnly
        }
        ExpectedOutput = $false
        Details        = [ordered] @{
            Area             = 'Features'
            Description      = "Consider this: a user is stamped with an AdminCount of 1, as a result of being added to Domain Admins; the user is removed from Domain Admins; the AdminCount value persists. In this instance the user is considered as orphaned. The ramifications? The AdminSDHolder ACL will be stamped upon this user every hour to protect against tampering. In turn, this can cause unexpected issues with delegation and application permissions."
            Resolution   = ''
            RiskLevel        = 10
            Resources = @(
                'https://blogs.technet.microsoft.com/poshchap/2016/07/29/security-focus-orphaned-admincount-eq-1-ad-users/'
            )
        }
    }
}