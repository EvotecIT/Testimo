function Start-TestimoEmail {
    <#
    .SYNOPSIS
    Sends an email with a summary of Active Directory tests.

    .DESCRIPTION
    This function sends an email with a summary of Active Directory tests. It allows customization of email settings such as From, To, CC, BCC, Server, Port, SSL, UserName, Password, Priority, and Subject.

    .PARAMETER From
    The email address from which the email will be sent.

    .PARAMETER To
    An array of email addresses to which the email will be sent.

    .PARAMETER CC
    An array of email addresses to be CC'd on the email.

    .PARAMETER BCC
    An array of email addresses to be BCC'd on the email.

    .PARAMETER Server
    The SMTP server used to send the email.

    .PARAMETER Port
    The port number of the SMTP server.

    .PARAMETER SSL
    Indicates whether SSL should be used for the email connection.

    .PARAMETER UserName
    The username for authentication with the SMTP server.

    .PARAMETER Password
    The password for authentication with the SMTP server.

    .PARAMETER PasswordAsSecure
    Indicates whether the password should be treated as a secure string.

    .PARAMETER PasswordFromFile
    Indicates whether the password should be read from a file.

    .PARAMETER Priority
    The priority of the email. Default is 'High'.

    .PARAMETER Subject
    The subject of the email. Default is '[Reporting Evotec] Summary of Active Directory Tests'.

    .EXAMPLE
    Start-TestimoEmail -From "sender@example.com" -To "recipient@example.com" -Server "mail.example.com" -Port 587 -SSL -UserName "username" -Password "password" -Priority "High" -Subject "Summary of Active Directory Tests"

    Sends an email with the specified parameters.

    #>
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