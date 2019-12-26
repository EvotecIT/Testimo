function Get-TestimoForest {
    [CmdletBinding()]
    param()
    try {
        $DC = Get-ADDomainController -Discover
        $Forest = Get-ADForest -ErrorAction Stop -Server $DC.HostName[0]

        $Domains = foreach ($_ in $Forest.Domains) {
            if ($_ -notin $Script:TestimoConfiguration['Exclusions']['Domains']) {
                $_.ToLower()
            }
        }

        [ordered] @{
            Name                  = $Forest.Name
            #RootDomain          = $Forest.RootDomain
            ForestMode            = $Forest.ForestMode
            Domains               = $Domains
            PartitionsContainer   = $Forest.PartitionsContainer
            DomainNamingMaster    = $Forest.DomainNamingMaster
            SchemaMaster          = $Forest.SchemaMaster
            GlobalCatalogs        = $Forest.GlobalCatalogs
            Sites                 = $Forest.Sites
            SPNSuffixes           = $Forest.SPNSuffixes
            UPNSuffixes           = $Forest.UPNSuffixes
            ApplicationPartitions = $Forest.ApplicationPartitions
            CrossForestReferences = $Forest.CrossForestReferences
        }

    } catch {
        Out-Failure -Text "Gathering Forest Information failed. Tests for domains/domain controllers will be skipped." -Level 0 -ExtendedValue $_.Exception.Message -Type 'e'
        return
    }
}