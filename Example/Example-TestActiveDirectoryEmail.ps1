[Array] $Results = Invoke-Testimo -ReturnResults -ExcludeDomains 'ad.evotec.pl'
[Array] $ResultsFailed | Where-Object { $_.Status -eq $false }

if ($ResultsFailed.Count -gt 0) {
    Email {
        EmailHeader {
            EmailFrom -Address 'myemail@evotec.pl'
            EmailTo -Addresses "otheremail@evotec.pl"
            EmailServer -Server 'smtp.office365' -UserName 'myemail@evotec.pl' -Password 'C:\Support\Important\Password-Evotec.txt' -PasswordAsSecure -PasswordFromFile -Port 587 -SSL
            EmailOptions -Priority High -DeliveryNotifications Never
            EmailSubject -Subject '[Reporting Evotec] Summary of Active Directory Tests'
        }
        EmailBody -FontFamily 'Calibri' -Size 15 {
            EmailText -Text "Summary of Active Directory Tests" -Color None, Blue -LineBreak

            EmailTable -DataTable $Results {
                EmailTableCondition -ComparisonType 'string' -Name 'Status' -Operator eq -Value 'True' -BackgroundColor Green -Color White -Inline -Row
                EmailTableCondition -ComparisonType 'string' -Name 'Status' -Operator ne -Value 'True' -BackgroundColor Red -Color White -Inline -Row
            } -HideFooter
        }
    } -AttachSelf -Supress $false
}