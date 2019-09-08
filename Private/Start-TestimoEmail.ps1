function Start-TestimoEmail {
    [CmdletBinding()]
    param(
        [string] $From,
        [string[]] $To,
        [string[]] $CC,
        [string[]] $BCC,
        [string] $Server,
        [int] $Port,
        [switch] $SSL,
        [string] $UserName,
        [string] $Password,
        [switch] $PasswordAsSecure,
        [switch] $PasswordFromFile,
        [string] $Priority = 'High',
        [string] $Subject = '[Reporting Evotec] Summary of Active Directory Tests'
    )
    Email {
        EmailHeader {
            EmailFrom -Address $From
            EmailTo -Addresses $To
            EmailServer -Server $Server -UserName $UserName -Password $PasswordFromFile -PasswordAsSecure:$PasswordAsSecure -PasswordFromFile:$PasswordFromFile -Port 587 -SSL:$SSL
            EmailOptions -Priority $Priority -DeliveryNotifications Never
            EmailSubject -Subject $Subject
        }
        EmailBody -FontFamily 'Calibri' -Size 15 {
            #EmailText -Text "Summary of Active Directory Tests" -Color None, Blue -LineBreak

            EmailTable -DataTable $Results {
                EmailTableCondition -ComparisonType 'string' -Name 'Status' -Operator eq -Value 'True' -BackgroundColor Green -Color White -Inline -Row
                EmailTableCondition -ComparisonType 'string' -Name 'Status' -Operator ne -Value 'True' -BackgroundColor Red -Color White -Inline -Row
            } -HideFooter
        }
    } -AttachSelf -Supress $false
}