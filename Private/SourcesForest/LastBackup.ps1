$LastBackup = @{
    Enable = $false
    Source = @{
        Name       = 'Forest Backup'
        Data       = {
            Get-WinADLastBackup
        }
    }
    Tests  = [ordered] @{
        LastBackupTests = @{
            Enable     = $true
            Name       = 'Forest Last Backup Time - Context'
            #Data       = $Script:SBForestLastBackupTest
            Parameters = @{
                ExpectedValue = 2
                OperationType = 'lt'
                Property      = 'LastBackupDaysAgo'
                PropertyExtendedValue = 'LastBackup'
                OverwriteName = { "Last Backup $($_.NamingContext)" }
            }
        }
    }
}
<#
$Script:SBForestLastBackup = {
    Get-WinADLastBackup
}


$Script:SBForestLastBackupTest = {
    foreach ($_ in $Object) {
        # 6
        Test-Value -Level $LevelTest -TestName "Last Backup $($_.NamingContext)" -Object $_ -Property 'LastBackupDaysAgo' -PropertyExtendedValue 'LastBackup' -OperationType 'lt' -ExpectedValue 2 -Domain $Domain -DomainController $DomainController
    }
}
#>