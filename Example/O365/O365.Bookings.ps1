@{
    Name   = 'O365Bookings'
    Enable = $true
    Scope  = 'Office365'
    Source = @{
        Name           = 'O365 Bookings Settings'
        Data           = {
            $Test = Get-O365OrgBookings -Authorization $Authorization
            $Test
        }
        Details        = [ordered] @{
            Category    = 'Configuration'
            Description = "Microsoft Bookings makes scheduling and managing appointments a breeze. Bookings includes a web-based booking calendar and integrates with Outlook to optimize your staff’s calendar and give your customers flexibility to book a time that works best for them. Email and SMS text notifications reduce no-shows and enhances customer satisfaction Your organization saves time with a reduction in repetitive scheduling tasks. With built in flexibility and ability to customize, Bookings can be designed to fit the situation and needs of many different parts of an organization."
            Importance  = 0
            ActionType  = 0
            Resources   = @(

            )
            Tags        = 'O365', 'Configuration', 'Bookings'
            StatusTrue  = 0
            StatusFalse = 5
        }
        ExpectedOutput = $true
    }
    Tests  = [ordered] @{
        BookingsEnabled = @{
            Enable     = $true
            Name       = 'Bookings Status'
            Parameters = @{
                ExpectedValue = $true
                OperationType = 'eq'
                Property      = 'Enabled'
            }
            Details    = [ordered] @{
                Category    = 'Configuration'
                Importance  = 5
                ActionType  = 2
                StatusTrue  = 1
                StatusFalse = 5
            }
        }
        BookingsEnabled2 = @{
            Enable     = $true
            Name       = 'Bookings Status'
            Parameters = @{
                ExpectedValue = $true
                OperationType = 'eq'
                Property      = 'Enabled'
            }
            Details    = [ordered] @{
                Category    = 'Configuration'
                Importance  = 5
                ActionType  = 2
                StatusTrue  = 1
                StatusFalse = 5
            }
        }
    }
}