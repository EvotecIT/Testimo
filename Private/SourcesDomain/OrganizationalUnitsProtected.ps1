$OrganizationalUnitsProtected = @{
    Enable = $true
    Source = @{
        Name           = "Orphaned/Empty Organizational Units"
        Data           = {
            $OUs = Get-ADOrganizationalUnit -Properties ProtectedFromAccidentalDeletion,CanonicalName -Filter * -Server $Domain
            $FilteredOus = foreach ($OU in $OUs) {
                if ($OU.ProtectedFromAccidentalDeletion -eq $false) {
                    $OU
                }
            }
            $FilteredOus | Select-Object -Property Name, CanonicalName, DistinguishedName, ProtectedFromAccidentalDeletion
        }
        Details = [ordered] @{
            Area        = 'Cleanup'
            Category    = ''
            Severity    = ''
            RiskLevel   = 0
            Description = ''
            Resolution  = ''
            Resources   = @(

            )
        }
        ExpectedOutput = $false
    }
}