<#
$Script:SBForestReplication = {
    $Replication = Start-TestProcessing -Test "Forest Replication" -Level 1 -ExpectedStatus $true -OutputRequired {
        Get-WinTestReplication -Status $true
    }
    foreach ($_ in $Replication) {
        Test-Value -TestName "Replication from $($_.Server) to $($_.ServerPartner)" -Object $_ -Property 'Status' -ExpectedValue $true -Level 2 -PropertyExtendedValue 'StatusMessage'
    }
}
#>

$Script:SBForestReplication = {
    Get-WinADForestReplication -WarningAction SilentlyContinue
}
$Script:SBForestReplicationTest1 = {
    # Needs fixing $args not working
    # If you don't pass $Args you basically need to pass:
    # $Domain, $DomainController, $Object, $Level, $ExpectedValue and all other properties yourself
    # Domain, DomainController and Object are variables that are available by default
    foreach ($_ in $Object) {
        # 6
        Test-Value -TestName "Replication from $($_.Server) to $($_.ServerPartner)" -Property 'Status' -PropertyExtendedValue 'StatusMessage' -ExpectedValue $True -Level $LevelTest -Object $_ -Domain $Domain -DomainController $DomainController #@args
    }
}