function Get-ForestDFSHealth {
    param(
        [string[]] $Domains,
        [int] $EventDays = 1
    )

    $Forest = Get-ADForest
    if (-not $Domains) {
        $Domains = $Forest.Domains
    }
    [Array] $Table = foreach ($Domain in $Domains) {
        $DomainControllers = Get-ADDomainController -Filter * -Server $Domain

        [Array]$GPOs = @(Get-GPO -All -Domain $Domain)

        foreach ($DC in $DomainControllers) {
            $DCName = $DC.Name
            $Hostname = $DC.Hostname
            $DN = $DC.ComputerObjectDN

            $LocalSettings = "CN=DFSR-LocalSettings,$DN"
            $Subscriber = "CN=Domain System Volume,$LocalSettings"
            $Subscription = "CN=SYSVOL Subscription,$Subscriber"

            $DomainSummary = [ordered] @{
                "DC"                  = $DCName
                "IsPDC"               = $DC.OperationMasterRoles -contains 'PDCEmulator'
                "Domain"              = $Domain
                "GPOCount"            = $GPOs.Count
                "SysvolCount"         = 0
                "Availability"        = $false
                "Member(CN=Topology)" = $null
                "DFSErrors"           = 0
                "DFSEvents"           = $null
                "DFSLocalSetting"     = ''
                "DomainSystemVolume"  = ''
                "SYSVOLSubscription"  = ''
            }
            try {
                $MemberReference = (Get-ADObject $Subscriber -Properties msDFSR-MemberReference -Server $Domain -ErrorAction Stop).'msDFSR-MemberReference' -like "CN=$DCName,*"
                if ($MemberReference) {
                    $DomainSummary['Member(CN=Topology)'] = $true
                }
            } catch {
                $DomainSummary['Member(CN=Topology)'] = $false
            }

            try {
                $DFSLocalSetting = Get-ADObject $LocalSettings -Server $Domain -ErrorAction Stop
                if ($DFSLocalSetting) {
                    $DomainSummary['DFSLocalSetting'] = $true
                }
            } catch {
                $DomainSummary['DFSLocalSetting'] = $false
            }

            try {
                $DomainSystemVolume = Get-ADObject $Subscriber -Server $Domain -ErrorAction Stop
                if ($DomainSystemVolume) {
                    $DomainSummary['DomainSystemVolume'] = $true
                }
            } catch {
                $DomainSummary['DomainSystemVolume'] = $false
            }


            try {
                $SysVolSubscription = Get-ADObject $Subscription -Server $Domain -ErrorAction Stop
                if ($SysVolSubscription) {
                    $DomainSummary['SYSVOLSubscription'] = $true
                }
            } catch {
                $DomainSummary['SYSVOLSubscription'] = $false
            }

            try {
                $SYSVOL = Get-ChildItem -Path "\\$Hostname\SYSVOL\$Domain\Policies" -ErrorAction Stop
                $DomainSummary['SysvolCount'] = $SYSVOL.Count
            } catch {
                $DomainSummary['SysvolCount'] = 0
            }

            if (Test-Connection $Hostname -ErrorAction SilentlyContinue) {
                $DomainSummary['Availability'] = $true
            } else {
                $DomainSummary['Availability'] = $false
            }
            try {
                $Yesterday = (Get-Date).AddDays($EventDays)
                [Array] $Events = Get-WinEvent -LogName "DFS Replication" -ComputerName $Hostname | Where-Object { ($_.LevelDisplayName -eq "Error") -and ($_.TimeCreated -ge $Yesterday) }
                $DomainSummary['DFSErrors'] = $Events.Count
                $DomainSummary['DFSEvents'] = $Events
            } catch {
                $DomainSummary['DFSErrors'] = $null
            }
        }
        [PSCustomObject] $DomainSummary
    }
    $Table
}

#$Health = Get-ForestDFSHealth
#$Health | ft -AutoSize *


