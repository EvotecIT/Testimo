$Script:SBForestLastBackup = {
    $LastBackup = Start-TestProcessing -Test "Forest Last Backup Time" -Level 1 -OutputRequired {
        Get-WinADLastBackup
    }
    foreach ($_ in $LastBackup) {
        #Test-Value -TestName "Replication from $($_.Server) to $($_.ServerPartner)" -Object $_ -Property 'Status' -ExpectedValue $true -Level 2 -PropertExtendedValue 'StatusMessage'
        Test-Value -Level 2 -TestName "Last Backup $($_.NamingContext)" -Object $_ -Property 'LastBackupDaysAgo' -PropertExtendedValue 'LastBackup' -lt -ExpectedValue 2
    }
}