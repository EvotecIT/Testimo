$Script:SBForestSiteLinks = {
    <#
    Name                            : DEFAULTIPSITELINK
    Cost                            : 100
    ReplicationFrequencyInMinutes   : 15
    Options                         : UseNotify
    Created                         : 20.05.2018 09:55:23
    Modified                        : 21.08.2019 13:00:37
    ProtectedFromAccidentalDeletion : False

    Name                            : ForeignLink
    Cost                            : 100
    ReplicationFrequencyInMinutes   : 180
    Options                         : None
    Created                         : 21.08.2019 13:00:57
    Modified                        : 21.08.2019 13:00:57
    ProtectedFromAccidentalDeletion : False
        #>
    Get-WinADSiteLinks
}