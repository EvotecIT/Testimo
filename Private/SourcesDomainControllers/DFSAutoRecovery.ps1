$DFSAutoRecovery = @{
    Enable = $true
    Source = @{
        Name             = 'DFSR AutoRecovery'
        Data             = {
            Get-PSRegistry -RegistryPath "HKLM\SYSTEM\CurrentControlSet\Services\DFSR\Parameters" -ComputerName $DomainController
        }
        RecommendedLinks = @(
            'https://secureinfra.blog/2019/04/30/field-notes-a-quick-tip-on-dfsr-automatic-recovery-while-you-prepare-for-an-ad-domain-upgrade/'
        )
    }
    Tests  = [ordered] @{
        EnableSMB1Protocol = @{
            Enable     = $true
            Name       = 'DFSR AutoRecovery should be enabled'
            Parameters = @{
                Property      = 'StopReplicationOnAutoRecovery'
                ExpectedValue = 0
                OperationType = 'eq'
            }
        }
    }
}