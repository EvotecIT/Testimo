$FileSystem = @{
    Name   = 'DCFileSystem'
    Enable = $true
    Scope  = 'DC'
    Source = @{
        Name           = "FileSystem"
        Data           = {
            Get-PSRegistry -RegistryPath 'HKLM\SYSTEM\CurrentControlSet\Control\FileSystem' -ComputerName $DomainController
        }
        Details        = [ordered] @{
            Type        = 'Security'
            Area        = ''
            Description = ''
            Resolution  = ''
            Importance  = 10
            Resources   = @(
                ''
            )
        }
        Requirements   = @{
            CommandAvailable = 'Get-WinADLMSettings'
        }
        ExpectedOutput = $true
    }
    Tests  = [ordered] @{
        NtfsDisable8dot3NameCreation = @{
            Enable     = $true
            Name       = 'NtfsDisable8dot3NameCreation'
            Parameters = @{
                Property      = 'NtfsDisable8dot3NameCreation'
                ExpectedValue = 0
                OperationType = 'gt'
            }
            Details    = [ordered] @{
                Area        = ''
                Description = ''
                Resolution  = ''
                Importance  = 10
                Resources   = @(
                    'https://guyrleech.wordpress.com/2014/04/15/ntfs-8-3-short-names-solving-the-issues/'
                    'https://blogs.technet.microsoft.com/josebda/2012/11/13/windows-server-2012-file-server-tip-disable-8-3-naming-and-strip-those-short-names-too/'
                    'https://support.microsoft.com/en-us/help/121007/how-to-disable-8-3-file-name-creation-on-ntfs-partitions'
                )
            }
        }
    }
}
