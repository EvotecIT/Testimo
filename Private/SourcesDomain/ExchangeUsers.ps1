$ExchangeUsers = @{
    Name   = 'DomainExchangeUsers'
    Enable = $false
    Scope  = 'Domain'
    Source = @{
        Name           = "Exchange Users: Missing MailNickName"
        Data           = {
            Get-ADUser -Filter { Mail -like '*' -and MailNickName -notlike '*' } -Properties mailNickName, mail -Server $Domain
        }
        Details        = [ordered] @{
            Area        = ''
            Category    = ''
            Severity    = ''
            Importance  = 0
            Description = ''
            Resolution  = ''
            Resources   = @(
                'https://evotec.xyz/office-365-msexchhidefromaddresslists-does-not-synchronize-with-office-365/'
            )

        }
        ExpectedOutput = $false
    }
}