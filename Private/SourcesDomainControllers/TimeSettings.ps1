$TimeSettings = [ordered] @{
    Name   = 'DCTimeSettings'
    Enable = $true
    Scope  = 'DC'
    Source = @{
        Name           = "Time Settings"
        Data           = {
            Get-TimeSettings -ComputerName $DomainController -Domain $Domain
        }
        Details        = [ordered] @{
            Area        = 'Configuration'
            Description = ''
            Resolution  = ''
            Importance  = 2
            Resources   = @(

            )
        }
        ExpectedOutput = $true
    }
    Tests  = [ordered] @{
        NTPServerEnabled           = @{
            Enable     = $true
            Name       = 'NtpServer must be enabled.'
            Parameters = @{
                WhereObject   = { $_.ComputerName -eq $DomainController }
                Property      = 'NtpServerEnabled'
                ExpectedValue = $true
                OperationType = 'eq'
            }
        }
        NTPServerIntervalMissing   = @{
            Enable     = $true
            Name       = 'Ntp Server Interval should be set'
            Parameters = @{
                WhereObject   = { $_.ComputerName -eq $DomainController }
                Property      = 'NtpServerIntervals'
                ExpectedValue = 'Missing'
                OperationType = 'notcontains'
            }
        }
        NTPServerIntervalIncorrect = @{
            Enable     = $true
            Name       = 'Ntp Server Interval should be within known settings'
            Parameters = @{
                WhereObject   = { $_.ComputerName -eq $DomainController }
                Property      = 'NtpServerIntervals'
                ExpectedValue = 'Incorrect'
                OperationType = 'notcontains'
            }
        }
        VMTimeProvider             = @{
            Enable     = $true
            Name       = 'Virtual Machine Time Provider should be disabled.'
            Parameters = @{
                WhereObject   = { $_.ComputerName -eq $DomainController }
                Property      = 'VMTimeProvider'
                ExpectedValue = $false
                OperationType = 'eq'
            }
        }
        NtpTypeNonPDC              = [ordered]  @{
            Enable       = $true
            Name         = 'NTP Server should be set to Domain Hierarchy'
            Requirements = @{
                IsPDC = $false
            }
            Parameters   = @{
                WhereObject   = { $_.ComputerName -eq $DomainController }
                Property      = 'NtpType'
                ExpectedValue = 'NT5DS'
                OperationType = 'eq'

            }
        }
        NtpTypePDC                 = [ordered] @{
            Enable       = $true
            Name         = 'NTP Server should be set to NTP'
            Requirements = @{
                IsPDC = $true
            }
            Parameters   = @{
                WhereObject   = { $_.ComputerName -eq $DomainController }
                Property      = 'NtpType'
                ExpectedValue = 'NTP'
                OperationType = 'eq'

            }
        }
        WindowsSecureTimeSeeding   = [ordered] @{
            Enable     = $true
            Name       = 'Windows Secure Time Seeding should be disabled.'
            Parameters = @{
                WhereObject   = { $_.ComputerName -eq $DomainController }
                Property      = 'WindowsSecureTimeSeeding'
                ExpectedValue = $false
                OperationType = 'eq'
            }
            Details    = @{
                Importance  = 10
                ActionType  = 2
                StatusTrue  = 1
                StatusFalse = 5
                Resources   = @(
                    '[Windows Secure Time Seeding, should you disable it?](https://www.askwoody.com/forums/topic/windows-secure-time-seeding-should-you-disable-it/)'
                    '[Wrong system time and insecure Secure Time Seeding](https://www.kaspersky.com/blog/windows-system-time-sudden-changes/48956/)'
                    '[How to enable or disable Secure Time Seeding in Windows computers](https://www.thewindowsclub.com/secure-time-seeding-windows-10)'
                    '[Windows feature that resets system clocks based on random data is wreaking havoc](https://arstechnica.com/security/2023/08/windows-feature-that-resets-system-clocks-based-on-random-data-is-wreaking-havoc/3/)'
                )
            }
        }
    }
}