<#
$Script:SBForestLastBackup = {
    $LastBackup = Start-TestProcessing -Test "Forest Last Backup Time" -Level 1 -OutputRequired {
        Get-WinADLastBackup
    }
    foreach ($_ in $LastBackup) {
        Test-Value -Level 2 -TestName "Last Backup $($_.NamingContext)" -Object $_ -Property 'LastBackupDaysAgo' -PropertyExtendedValue 'LastBackup' -lt -ExpectedValue 2
    }
}
#>

$Script:SBForestLastBackup = {
    Get-WinADLastBackup
}


$Script:SBForestLastBackupTest = {
    foreach ($_ in $Object) {
        # 6
        Test-Value -Level $LevelTest -TestName "Last Backup $($_.NamingContext)" -Object $_ -Property 'LastBackupDaysAgo' -PropertyExtendedValue 'LastBackup' -OperationType 'lt' -ExpectedValue 2 -Domain $Domain -DomainController $DomainController
    }
}