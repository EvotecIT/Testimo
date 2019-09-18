$EmptyOrganizationalUnits = @{
    Enable = $true
    Source = @{
        Name           = "Orphaned/Empty Organizational Units"
        Data           = {
            $OrganizationalUnits = Get-ADOrganizationalUnit -Filter * -Properties distinguishedname -Server $Domain | Select-Object -ExpandProperty distinguishedname

            $AllUsedOU = Get-ADObject -Filter "ObjectClass -eq 'user' -or ObjectClass -eq 'computer' -or ObjectClass -eq 'group' -or ObjectClass -eq 'contact'" -Server $Domain | `
                Where-Object { ($_.DistinguishedName -notlike '*LostAndFound*') -and ($_.DistinguishedName -match 'OU=(.*)') } | `
                ForEach-Object { $matches[0] } | `
                Select-Object -Unique

            $OrganizationalUnits | Where-Object { ($AllUsedOU -notcontains $_) -and -not (Get-ADOrganizationalUnit -Filter * -SearchBase $_ -SearchScope 1 -Server $Domain) }
        }
        ExpectedOutput = $false
        Details = [ordered] @{
            Area        = ''
            Category    = ''
            Severity    = ''
            RiskLevel   = 0
            Description = ''
            Resolution  = ''
            Resources   = @(

            )
        }
    }
}