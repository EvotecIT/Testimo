$OrganizationalUnitsProtected = @{
    Enable = $true
    Scope  = 'Domain'
    Source = @{
        Name           = "Organizational Units: Protected"
        Data           = {
            $OUs = Get-ADOrganizationalUnit -Properties ProtectedFromAccidentalDeletion, CanonicalName -Filter * -Server $Domain
            $FilteredOus = foreach ($OU in $OUs) {
                if ($OU.ProtectedFromAccidentalDeletion -eq $false) {
                    $OU
                }
            }
            $FilteredOus | Select-Object -Property Name, CanonicalName, DistinguishedName, ProtectedFromAccidentalDeletion
        }
        Details        = [ordered] @{
            Area        = 'Cleanup'
            Category    = ''
            Severity    = ''
            Importance   = 0
            Description = ''
            Resolution  = ''
            Resources   = @(

            )
        }
        ExpectedOutput = $false
    }
}