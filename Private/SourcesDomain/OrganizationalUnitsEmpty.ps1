$OrganizationalUnitsEmpty = @{
    Enable = $true
    Scope  = 'Domain'
    Source = @{
        Name           = "Organizational Units: Orphaned/Empty"
        Data           = {
            <# We should replace it with better alternative
            ([adsisearcher]'(objectcategory=organizationalunit)').FindAll() | Where-Object {
            -not (-join $_.GetDirectoryEntry().psbase.children) }
            #>
            $OrganizationalUnits = Get-ADOrganizationalUnit -Filter * -Properties distinguishedname -Server $Domain | Select-Object -ExpandProperty distinguishedname
            $WellKnownContainers = Get-ADDomain | Select-Object *Container

            $AllUsedOU = Get-ADObject -Filter "ObjectClass -eq 'user' -or ObjectClass -eq 'computer' -or ObjectClass -eq 'group' -or ObjectClass -eq 'contact'" -Server $Domain | `
                Where-Object { ($_.DistinguishedName -notlike '*LostAndFound*') -and ($_.DistinguishedName -match 'OU=(.*)') } | `
                ForEach-Object { $matches[0] } | `
                Select-Object -Unique

            $OrganizationalUnits | Where-Object { ($AllUsedOU -notcontains $_) -and -not (Get-ADOrganizationalUnit -Filter * -SearchBase $_ -SearchScope 1 -Server $Domain) -and (($_ -notlike $WellKnownContainers.UsersContainer) -or ($_ -notlike $WellKnownContainers.ComputersContainer)) }
        }
        Details        = [ordered] @{
            Category    = 'Configuration'
            Importance  = 3
            ActionType  = 1
            Description = ''
            Resolution  = ''
            Resources   = @(
                "[Active Directory Friday: Find empty Organizational Unit](https://www.jaapbrasser.com/active-directory-friday-find-empty-organizational-unit/)"
            )
            StatusTrue  = 1
            StatusFalse = 2
        }
        ExpectedOutput = $false
    }
}