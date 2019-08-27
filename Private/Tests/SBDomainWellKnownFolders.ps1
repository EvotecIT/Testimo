$script:SBDomainWellKnownFolders = {
    param(
        $Domain
    )
    $DomainInformation = Get-ADDomain -Server $Domain
    $WellKnownFolders = $DomainInformation | Select-Object -Property UsersContainer, ComputersContainer, DomainControllersContainer, DeletedObjectsContainer, SystemsContainer, LostAndFoundContainer, QuotasContainer, ForeignSecurityPrincipalsContainer
    $CurrentWellKnownFolders = [ordered] @{ }

    $DomainDistinguishedName = $DomainInformation.DistinguishedName
    $DefaultWellKnownFolders = [ordered] @{
        UsersContainer                     = "CN=Users,$DomainDistinguishedName"
        ComputersContainer                 = "CN=Computers,$DomainDistinguishedName"
        DomainControllersContainer         = "OU=Domain Controllers,$DomainDistinguishedName"
        DeletedObjectsContainer            = "CN=Deleted Objects,$DomainDistinguishedName"
        SystemsContainer                   = "CN=System,$DomainDistinguishedName"
        LostAndFoundContainer              = "CN=LostAndFound,$DomainDistinguishedName"
        QuotasContainer                    = "CN=NTDS Quotas,$DomainDistinguishedName"
        ForeignSecurityPrincipalsContainer = "CN=ForeignSecurityPrincipals,$DomainDistinguishedName"
    }
    foreach ($_ in $WellKnownFolders.PSObject.Properties.Name) {
        $CurrentWellKnownFolders[$_] = $DomainInformation.$_
        $CurrentWellKnownFolders[$_] = $DomainInformation.$_
    }
    Compare-MultipleObjects -Object @($DefaultWellKnownFolders, $CurrentWellKnownFolders) -SkipProperties #| ft
}
#@($DefaultWellKnownFolders, $CurrentWellKnownFolders) | Out-HtmlView -Compare -HighlightDifferences

