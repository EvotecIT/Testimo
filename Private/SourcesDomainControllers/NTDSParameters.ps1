$NTDSParameters = @{
    Name   = 'DCNTDSParameters'
    Enable = $true
    Scope  = 'DC'
    Source = @{
        Name           = "NTDS Parameters"
        Data           = {
            Get-PSRegistry -RegistryPath "HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Services\NTDS\Parameters" -ComputerName $DomainController
        }
        Details        = [ordered] @{
            Area        = ''
            Description = ''
            Resolution  = ''
            Importance  = 10
            Resources   = @(

            )
        }
        ExpectedOutput = $true
    }
    Tests  = [ordered] @{
        DsaNotWritable = @{
            Enable     = $true
            Name       = 'Domain Controller should be writeable'
            Parameters = @{
                Property       = 'Dsa Not Writable'
                ExpectedOutput = $false
            }
        }
    }
}