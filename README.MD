<p align="center">
  <a href="https://www.powershellgallery.com/packages/Testimo"><img src="https://img.shields.io/powershellgallery/v/Testimo.svg"></a>
  <a href="https://www.powershellgallery.com/packages/Testimo"><img src="https://img.shields.io/powershellgallery/vpre/Testimo.svg?label=powershell%20gallery%20preview&colorB=yellow"></a>
  <a href="https://github.com/EvotecIT/Testimo"><img src="https://img.shields.io/github/license/EvotecIT/Testimo.svg"></a>
</p>

<p align="center">
  <a href="https://www.powershellgallery.com/packages/Testimo"><img src="https://img.shields.io/powershellgallery/p/Testimo.svg"></a>
  <a href="https://github.com/EvotecIT/Testimo"><img src="https://img.shields.io/github/languages/top/evotecit/Testimo.svg"></a>
  <a href="https://github.com/EvotecIT/Testimo"><img src="https://img.shields.io/github/languages/code-size/evotecit/Testimo.svg"></a>
  <a href="https://www.powershellgallery.com/packages/Testimo"><img src="https://img.shields.io/powershellgallery/dt/Testimo.svg"></a>
</p>

<p align="center">
  <a href="https://twitter.com/PrzemyslawKlys"><img src="https://img.shields.io/twitter/follow/PrzemyslawKlys.svg?label=Twitter%20%40PrzemyslawKlys&style=social"></a>
  <a href="https://evotec.xyz/hub"><img src="https://img.shields.io/badge/Blog-evotec.xyz-2A6496.svg"></a>
  <a href="https://www.linkedin.com/in/pklys"><img src="https://img.shields.io/badge/LinkedIn-pklys-0077B5.svg?logo=LinkedIn"></a>
</p>

# Testimo - PowerShell Module

**Testimo** is a PowerShell Module to help with basic/more advanced testing of **Active Directory** and maybe in future other types of servers.
**Testimo** is an **alpha product** and as such things do change.
It's goal is to be fully automated solution where one can run the command and get results without executing 50 little functions.

If you're new to **Testimo** you should read this [blog post](https://evotec.xyz/what-do-we-say-to-health-checking-active-directory/)!

**Note:** At present this module is not supported in PowerShell Core/PowerShell 7.
This is because the Testimo module depends on other Microsoft moodules that are also not supported in PowerShell 7, including GroupPolicy and ServerManager.
There is an issue tracking this compatibiity which you can follow: <https://github.com/EvotecIT/Testimo/issues/110>.

Things to know:

- [x] Configuration hash is not written in stone and can change rapidly as Testimo gets tested
- [x] Ideas are VERY welcome
- [x] There's a big mess in files/function names - I'm still testing things out creating some random names, will be cleaned up later on
- [x] There are lots of details missing for tests, and some things may not work as you want - please report issues or if you know how, fix them
- [x] I don't know EVERYTHING - I'm very open to help with making Testimo more robust, detailed and easy to use
- [x] This module works great in Windows PowerShell!

- [Testimo - PowerShell Module](#testimo---powershell-module)
  - [Execution](#execution)
  - [ChangeLog](#changelog)
    - [Comments](#comments)
    - [Things to consider](#things-to-consider)
  - [Known Issues / By Design](#known-issues--by-design)
  - [To install](#to-install)
    - [And to update](#and-to-update)
  - [To use after installation](#to-use-after-installation)
  - [Changing default configuration](#changing-default-configuration)
    - [Straight to FILE/JSON](#straight-to-filejson)
      - [Straight to JSON](#straight-to-json)
      - [Output to Hashtable so you can edit it freely and keep in ps1](#output-to-hashtable-so-you-can-edit-it-freely-and-keep-in-ps1)
  - [Using Invoke-Testimo with non-default configuration](#using-invoke-testimo-with-non-default-configuration)
    - [Dependencies](#dependencies)
    - [Portability](#portability)
    - [Removal](#removal)
      - [Option 1](#option-1)
      - [Option 2](#option-2)

## Execution

Generate all tests and show HTML report (I'm currently thinking on making -ShowReport obsolete and adding -HideReport instead)

```powershell
Invoke-Testimo -ShowReport
```

Generate all tests but display content only in PowerShell

```powershell
Invoke-Testimo
```

Please keep in mind that there is currently known issue that running all tests while works correctly generated HTML is very very slow when switching Tabs.

## ChangeLog

- 0.0.57 - 2021.02.09
  - [x] General
    - [x] Parameter for `Invoke-Testimo` **ShowReport** is deprecated and doesn't do anything
    - [x] Parameter for `Invoke-Testimo` **HideHTML** was added and prevents auto-opening of HTML
    - [x] Parameter for `Invoke-Testimo` **HideSteps**/**HideSolution** was added to hide solution/steps in case it's not needed
    - [x] Added additional information about HTML report generating where the file was saved (useful if no FilePath was provided)
    - [x] Parameter `ReportPath` was renamed to `FilePath`, `ReportPath` is still an alias - to get it the same as [GPOZaurr](https://github.com/EvotecIT/GPOZaurr)
  - [x] Reporting
    - [x] Solution/Steps added to Report when available for display
  - [x] Tests
    - [x] Improved `DomainDomainControllers`
- 0.0.56 - 2021.02.07
  - [x] Tests
    - [x] Improved `ForestOrphanedAdmins`
    - [x] Added `ForestConfigurationPartitionOwners`
    - [x] Improved `DomainDuplicateObjects`
    - [x] Improved `DomainDomainControllers`
    - [x] Improved `DCTimeSynchronizationExternal`
  - [x] Reporting
    - [x] HTML report updated with new format, still not final
    - [x] Added Importance/Category visibility in HTML -> if only those were updated in all tests 🤣
    - [x] Added Description visibility in HTML -> if only those were updated in all tests 🤣
    - [x] Added Resources visibility in HTML -> if only those were updated in all tests 🤣
- 0.0.55 - 2021.02.02
  - [x] Improvement to report (domain section)
  - [x] Improvement to `DomainDuplicateObjects`
  - [x] Improvement to `OrphanedForeignSecurityPrincipals`
  - [x] Removed `ForestDuplicateObjects` - duplicate of `DomainDuplicateObjects`
- 0.0.54 - 2021.01.29
  - [x] Fixes report to work with IE 11 (not great, not bad either)
- 0.0.53 - 2021.01.28
  - [x] Improved `DomainDomainControllers`
- 0.0.52 - 2021.01.27
  - [x] Improved `DCUNCHardenedPaths` to check for multiple values
- 0.0.51 - 2021.01.26
  - [x] Fix for Invoke-Testimo crashing on dead/non-responding/no-access DC [#117](https://github.com/EvotecIT/Testimo/issues/117)
- 0.0.50 - 2021.01.25
  - [x] Fix for Invoke-Testimo returning more than one line of error which would stop Testimo [#116](https://github.com/EvotecIT/Testimo/issues/116)
- 0.0.49 - 2021.01.25
  - [x] Fix for Invoke-Testimo not working correctly with some tests [#116](https://github.com/EvotecIT/Testimo/issues/116)
  - [x] Improved some tests
  - [x] Reporting
    - [x] HTML report improved a bit for Domain based checks
- 0.0.48 - 2021.01.21
  - [x] Fix for Invoke-Testimo not working when no tests are defined
  - [x] Tests
    - [x] Added `DomainDomainControllers` - covers DC ACL owner, DC Manager, DC Password Last Set, DC Last Logon, Enabled
- 0.0.47 - 2021.01.19
  - [x] Improvements
    - [x] Added warning & errors to HTML
    - [x] Removed dependency on `PSWinDocumentation.AD` temporary (no tests for now)
  - [x] Tests
    - [x] Removed `DomainGroupPolicyPermissionUnknown`
    - [x] Removed `GroupPolicyMissingPermissions`
    - [x] Added `DomainGroupPolicyPermissions` - covers unknown, adminitrative, authenticated users and system (both removed + some)
    - [x] Removed `DomainGroupPolicyEmptyUnlinked`
    - [x] Added `DomainGroupPolicyAssesment` - covers empty, unlinked, disabled, with problem, optimized, no apply permission
    - [x] Added `DomainNetLogonOwner`
    - [x] Improved `ForestSiteLinksConnections` [#92](https://github.com/EvotecIT/Testimo/issues/92)
    - [x] Improved `ForestTombstoneLifetime` - support for forest
- 0.0.46 - 2020.10.29
  - [x] Improvement to `HTML`
    - [x] DataStore is now set to `JavaStore` which allows handling of more data within single HTML file
    - [x] Should have less errors on tab switching
    - [ ] Known issue: **with lots of tables/charts switching between tabs can take time, be patient**
  - [x] Improvement to `DomainSecurityKRBGT`
  - [x] Improvement to `DCWindowsUpdates`
  - [x] Removed `DomainKerberosAccountAge` as it's identical to `DomainSecurityKRBGT`
  - [x] Removed `DomainTrusts` as it wasn't really working great
  - [x] Added `ForestTrusts` with improvements
  - [x] `ForestObjectsWithConflict` renamed to `ForestDuplicateObjects`
  - [x] `ForestDuplicateObjects` disabled by default (same thing as `DomainDuplicateObjects` just done forest wide)
  - [x] `DomainDuplicateObjects` enabled by default (same thing as forest just done per domain)
  - [x] `DCTimeSettings` updated with proper NTP recommendation [#65](https://github.com/EvotecIT/Testimo/issues/65) - tnx SolidKnight, SUBnet192, itpro-tips
- 0.0.45 - 2020.10.20
  - [x] Reversed on HTML change due to issues
- 0.0.44 - 2020.10.19
  - HTML
    - [x] HTML report should now be much faster to work with even with larger datasets
  - Tests
    - [x] `DomainWellKnownFolders` - removed duplicate code
    - [x] Added some additional descriptions to tests, still long way to go
    - [x] Small name fix for `DomainGroupPolicySysvol`
    - [x] `DomainGroupPolicyEmptyUnlinked` - added new test
    - [x] Silent `GitHub` version check
    - [x] Fixes working with lowercase source names
    - [x] Fixes issue `Service Status fails on value "Auto"` [#106](https://github.com/EvotecIT/Testimo/issues/106) due to change in `PSSharedGoods`
- 0.0.43 - 2020.06.17
  - Tests
    - [x] Small name update to `OrganizationalUnitsEmpty` and `OrganizationalUnitsProtected` fixing [#103](https://github.com/EvotecIT/Testimo/issues/103)
- 0.0.42 - 2020.06.08
  - Tests
    - [x] Fix for `DCNetSessionEnumeration` not run against target [#102](https://github.com/EvotecIT/Testimo/issues/102)
  - Engine
    - [x] Better `Sources` handling during typing
- 0.0.41 - 2020.06.06
  - Engine
    - [x] Renamed `MustExists` to `ExpectedOutput` for Parameters in Tests for unified experience
    - [x] Added `ExpectedResult` for Parameters in Tests
      - [ ] This works in a way where if we use WhereObject filtering on Array you can check if output is given or not and fail/pass right away
      - [ ] This brings 3 ways to test `ExpectedCount`, `ExpectedValue` or `ExpectedResult`
      - [ ] `ExpectedResult` ignores all other settings in parameters except for `WhereObject`
  - Tests
    - [x] Added `DomainGroupPolicyPermissionConsistency` (requires `GPOZaurr` PowerShell module)
    - [x] Added `DomainGroupPolicyOwner` (requires `GPOZaurr` PowerShell module)
      - [x] Test for: `GPO: Owner Consistent`
      - [x] Test for: `GPO: Owner Administrative`
    - [x] Added `DomainGroupPolicyPermissionUnknown` (requires `GPOZaurr` PowerShell module)
    - [x] Added `DomainGroupPolicySysvol` (requires `GPOZaurr` PowerShell module)
    - [x] Renamed `DCGroupPolicySYSVOL` to `DCGroupPolicySYSVOLDC` to prevent conflict with per Domain checks
    - [x] Replaced `DomainGroupPolicyADM` with `GPOZaurr` command

- 0.0.40 - 2020.05.09
  - Engine
    - [x] ExpectedOutput is now required for Source
  - Tests
    - [x] ExpectedOutput (true/false/null) added for all tests
    - [x] Fix regression `ForestReplicationStatus` if multiple DC
    - [x] Fix regression `ForestReplication` if multiple DC
    - [x] Added `DomainDuplicateObjects` test - finds CNF objects

- 0.0.39 - 2020.04.11
  - Engine
    - [x] Add requirements (IsInternalForest = $true) for tests that do not support external forest (such as repadmin)
    - [x] Fixed `ExpectedCount` not working correctly for some values (no sure why it worked at all)
  - Reporting
    - [x] Improved output to not include empty tabs
  - Tests
    - [x] Improved `ForestReplicationStatus` if only 1 DC, disabled if asking for external forest
    - [x] Improved `ForestReplication` if only 1 DC
    - [x] Renamed `DomainEmptyOrganizationalUnits` to `DomainOrganizationalUnitsEmpty`
    - [x] Added `DomainOrganizationalUnitsProtected`
    - [x] Improved `DCServices` for non-existing spooler service
    - [x] Changed `DomainPasswordComplexity` Lockout Treshold changed to 5+
    - [x] Renamed `DCNetSessionEnumaration` to `DCNetSessionEnumeration` - tnx subnet192 [#99](https://github.com/EvotecIT/Testimo/pull/99)
    - [x] Added `DCDNSForwarders` - DNS: More than one forwarding server should be configured
    - [x] Added `DomainExchangeUsers` - Exchange Users: Missing MailNickName [monitors for issue described on blog](https://evotec.xyz/office-365-msexchhidefromaddresslists-does-not-synchronize-with-office-365/)
    - [x] Improved `DNSScavengingForPrimaryDNSServer`
  - Other
    - Fix typos - tnx subnet192 [#99](https://github.com/EvotecIT/Testimo/pull/99)

- 0.0.38 - 2020.03.14
  - Added GroupPolicy and ActiveDirectory to RequiredModules and ExternalModuleDependencies preventing error reported in [#91](https://github.com/EvotecIT/Testimo/issues/91)

- 0.0.37 - 2020.03.13
  - Engine
    - [x] Update to `DomainSecurityUsers` to exclude DomainGuests
    - [x] Fix for ExpectedOutput $false
  - Tests
    - [x] Fix for `DomainSecurityUsers` - tnx itpro-tips [#89](https://github.com/EvotecIT/Testimo/issues/89)
    - [x] Added DomainSecurityKRBGT
    - [x] Improved `DCNetworkSettings` - DNS: DNS servers on Ethernet should include the loopback address, but not as the first entry - [#90](https://github.com/EvotecIT/Testimo/pull/90) - tnx itpro-tips
    - [x] Improved `DCNetworkSettings` - DNS: Ethernet should have static IPv4 settings (disabled by default) - [#90](https://github.com/EvotecIT/Testimo/pull/90) - tnx itpro-tips
    - [x] Improved `DCLanManServer` - [ADV200005 | Microsoft Guidance for Disabling SMBv3 Compression](https://portal.msrc.microsoft.com/en-US/security-guidance/advisory/adv200005) - Disabled by default, as patch is available

- 0.0.36 - 2020.03.04
  - Engine
    - [x] Fix for broken tests

- 0.0.35 - 2020.03.04
  - Engine
    - [x] Added MustExists (True/False) for Parameters
    - [x] Fixes for In/NotIn
    - [x] Fixes for Inclusion/Exclusion DC/Domain
    - [x] Fixes for ExpectedCount 0 not working
  - Tests
    - [x] DCServices Improvement with XBOX Service
    - [x] Added DCSMBSharesPermissions
    - [x] Added DomainSecurityUsers
    - [x] Added DCUNCHardenedPaths - read potential issues of implementing UNC Hardened Paths. If you enable and things go south GPOs won't work.

- 0.0.34 - 2020.01.29
  - Tests
    - [x] Modify repadmin (ForestReplicationStatus) for non-english OS [#86](https://github.com/EvotecIT/Testimo/pull/86) - tnx Fiyorden

- 0.0.33 - 2020.01.28
  - Tests
    - [x] Fixing legacy ADM files check - [#84](https://github.com/EvotecIT/Testimo/issues/84) - tnx PMORMR

- 0.0.32 - 2020.01.27
  - Tests
    - [x] Fix for DCGroupPolicySYSVOL - [#83](https://github.com/EvotecIT/Testimo/issues/83) - tnx PMORMR

- 0.0.31 - 2020.01.23
  - Engine
    - [x] Fix for loading configuration

- 0.0.30 - 2020.01.19
  - Engine
    - [x] Fix for version checks

- 0.0.29 - 2020.01.19
  - Engine
    - [x] Added IncludeDomain, IncludeDomainControllers (when used skips Exclusions)
      - [ ] This requires heavy improvements - soon enough
    - [x] Fixes issue when first running single source and then running all tests (it would use the "old source" instead of using defaults)
  - Tests
    - [x] Fix for Windows Roles and Feature for other language (non-english) [#79](https://github.com/EvotecIT/Testimo/pull/79) - tnx Fiyorden
    - [x] Added LDAPInsecureBindings

- 0.0.28 - 2019.12.29
  - Engine
    - [x] Fix for not running tests for DC if no Forest/Domain tests are present
    - [x] Added -SkipRODC parameter to skip DCs that are RODC

- 0.0.27 - 2019.12.26
  - Engine
    - [x] Better support for Portable Testimo

- 0.0.26 - 2019.12.26
  - Engine
    - [x] Improvments to some error handling
    - [x] Added Version/Date Published (#72)
    - [x] Do not run Tests for Domain/DomainControllers if not enabled
  - Updated modules
    - [x] ADEssentials to 0.0.27 (Get-WinADDFSHealth fixed)
    - [x] Other dependencies also updated
  - Tests
    - [x] Fix for DNSForwaders
    - [x] Added DomainComputersUnsupported (older than 2008)
    - [x] Added DomainComputersUnsupportedMainstream (2008 computers with support from Microsoft)

- 0.0.25 - 2019.11.18
  - Engine
    - Small configuration saving fixes
    - Added version
  - Tests
    - [x] ForestObjectsWithConflict  - **Added**
    - [x] DCRDPSecurity - **Added**
      - [x] Minimum Encryption Level
    - [x] DCServiceWINRM - **Added**
      - [x] DisableRunAS
    - [x] DCSMBProtocols - added BPA findings - **Added**
      - [x] AutoDisconnectTimeout
      - [x] CachedOpenLimit
      - [x] DurableHandleV2TimeoutInSeconds
      - [x] EnableSMB1Protocol
      - [x] EnableSMB2Protocol
      - [x] MaxThreadsPerQueue
      - [x] Smb2CreditsMin
      - [x] Smb2CreditsMax
      - [x] RequireSecuritySignature
    - [x] DCNetSessionEnumeration (Net Cease) - **Added**
      - [x] Hardening Net Session Enumeration
    - [x] DCLanManServer - **Added**
      - [x] Microsoft network server: Digitally sign communications (if client agrees)
      - [x] Microsoft network server: Digitally sign communications (always)
      - [x] Users are not forcibly disconnected when logon hours expire.
- 0.0.23 - 2019.10.08
  - Tests
    - [x] DCDiagnostics - **Added**
      - [x] Basically wrapper over DcDiag
        - [x] Checks Connectivity
        - [x] Checks Advertising
        - [x] Checks CheckSecurityError
        - [x] Checks CutoffServers
        - [x] Checks FrsEvent
        - [x] Checks DFSREvent
        - [x] Checks SysVolCheck
        - [x] Checks FrsSysVol
        - [x] Checks KccEvent
        - [x] Checks KnowsOfRoleHolders
        - [x] Checks MachineAccount
        - [x] Checks NCSecDesc
        - [x] Checks NetLogons
        - [x] Checks ObjectsReplicated
        - [x] Checks Replications
        - [x] Checks RidManager
        - [x] Checks Services
        - [x] Checks SystemLog
        - [x] Checks Topology
        - [x] Checks VerifyEnterpriseReferences
        - [x] Checks VerifyReferences
        - [x] Checks VerifyReplicas
        - [x] Checks DNS
        - [x] Checks ForestDnsZonesCheckSDRefDom
        - [x] Checks ForestDnsZonesCrossRefValidation
        - [x] Checks DomainDnsZonesCheckSDRefDom
        - [x] Checks DomainDnsZonesCrossRefValidation
        - [x] Checks SchemaCheckSDRefDom
        - [x] Checks SchemaCrossRefValidation
        - [x] Checks ConfigurationCheckSDRefDom
        - [x] Checks ConfigurationCrossRefValidation
        - [x] Checks NetbiosCheckSDRefDom
        - [x] Checks NetbiosCrossRefValidation
        - [x] Checks DNSDomain
        - [x] Checks LocatorCheck
        - [x] Checks FsmoCheck
        - [x] Checks Intersite
    - [x] DCEventLog - **Added**
      - [x] Check for Application Log - LogMode/LogFull
      - [x] Check for System Log - LogMode/LogFull
      - [x] Check for PowerShell Log - LogMode/LogFull
      - [x] Check for Security Log - Size/SizeMax/LogMode/LogFull
      - [x] Check for Security Log - Default Security Permissions
    - [x] DCTimeSynchronizationExternal
      - [x] Supports parameters [#41 - tnx James Rudd](https://github.com/EvotecIT/Testimo/issues/41)
    - [x] DCDFS - **Added**
      - [x] DFS should be Healthy
      - [x] Central Repository for GPO for Domain should be available
      - [x] Central Repository for GPO for DC should be available
      - [x] GPO Count should match folder count
      - [x] MemberReference should return TRUE
      - [x] DFSErrors should be 0
      - [x] DFSLocalSetting should be TRUE
      - [x] DomainSystemVolume should be TRUE
      - [x] SYSVOLSubscription should be TRUE
      - [x] DFSR AutoRecovery should be enabled (not stopped)
    - [x] DCDFSRAutoRecovery - **DELETED**
      - [x] Moved to DCDFS
    - [x] DomainDHCPAuthorized - **Added but DISABLED**
      - [x] Check added, by default disabled.
    - [x] DCTimeSettings
      - [x] Fix for Incorrect NTP Interval [#42 - tnx Jakob West](https://github.com/EvotecIT/Testimo/issues/42)
      - [x] Added test for checking NTP Incorrect Interval [#42 - tnx Jakob West](https://github.com/EvotecIT/Testimo/issues/42)
      - [x] Should properly read settings via Policy (GPO) - change in PSSharedGoods [#41 - tnx James Rudd](https://github.com/EvotecIT/Testimo/issues/41)
    - [x] DomainGroupPolicyADM - **Added**
      - [x] Added check for legacy ADM files
    - [x] DCGroupPolicySYSVOL - **Added**
      - [x] Added check if all GPO's have their folder on SYSVOL
    - [x] DCLanManagerSettings - **Added**
      - [x] Added checks for Lan Manager Settings
    - [x] DCTimeSynchronizationInternal
      - [x] Added check for LastBootUpTime be less than X (60) days
  - Engine
    - Added checks for potential NULL after Where-Object (fails tests now, while before it would ignore it)
    - Added parameters for SourceParameters for use within Sources [#41 - tnx James Rudd](https://github.com/EvotecIT/Testimo/issues/41)
    - Changed export / import configuration to support SourceParameters/ExpectedOutput. [#41 - tnx James Rudd](https://github.com/EvotecIT/Testimo/issues/41)
    - Support for Requirements/CommandAvailable

- 0.0.22 - 2019.09.10
  - Tests
    - [x] DCPorts - typo fix OPEN vs CLOSED

- 0.0.21 - 2019.09.10
  - Tests
    - [x] DCPorts - Checking for port 139 - Require PORT CLOSED ([#29 - tnx SP3269](https://github.com/EvotecIT/Testimo/issues/29))
    - [x] DCNetworkSettings - Netbios TCPIP settings on network card - Require DISABLED ([#29 - tnx SP3269](https://github.com/EvotecIT/Testimo/issues/29))
    - [x] DCWindowsFirewall - was renamed to DCNetworkSettings
    - [x] DomainEmptyOrganizationalUnits - fix for lacking Contacts ([#32 - tnx JasonCook599](https://github.com/EvotecIT/Testimo/pull/32))
    - [x] DNSScavengingForPrimaryDNSServer - fix LT should be GT ([#33 - tnx JasonCook599](https://github.com/EvotecIT/Testimo/pull/33))
    - [x] DomainDNSZonesForest0ADEL - Added new test
    - [x] DomainDNSZonesDomain0ADEL - Added new test
  - Engine
    - [x] Support for match/notmatch/notcontains

- 0.0.20 - 2019.09.09
  - [x] Fix for configuration loading from JSON file ([#30](https://github.com/EvotecIT/Testimo/issues/30) - tnx Alex)

- 0.0.19 - 2019.09.08
  - [x] First public release - More information in [blog post](https://evotec.xyz/what-do-we-say-to-health-checking-active-directory/)!

### Comments

Keep in mind not all tests apply to each environment.
I'm adding those to be flexible and be able to test things as needed.
Each of those tests will need additional description and recommendation, most likely with links and steps to fix.
Some of the tests are very basic and will need feedback, work on making it a robust test.
Nothing is written in stone for now. Things can change day by day.

### Things to consider

- Criticality of Tests - some tests are critical, some are less critical, some are informative only
- Recommended, Default, Sane - not all tests are equal or make sense in all conditions

Tests are based on:

- [Active Directory CheckList](https://github.com/mczerniawski/Active-Directory-CheckList)
- [AD Health & Checkup](https://arnaudloos.com/AD-Health-Check/)
- Some tests I've defined myself
- Feel free to submit your own ideas either via Issues or direct PR.

| Type              | Name                                                   | Area              | Description                                                                              |
| ----------------- | ------------------------------------------------------ | ----------------- | ---------------------------------------------------------------------------------------- |
| Forest            | Backup                                                 | Backup            | Verify `last backup time should be [less than X days]`                                   |
| Forest            | Replication                                            | Connectivity      | Verify each `DC in replication site can [reach other replication members]`               |
| Forest            | Replication using Repadmin                             | Connectivity      | Verify each `DC in replication site can [reach other replication members]`               |
| Forest            | Optional Features                                      | Features          | Verify Optional Feature `Recycle Bin should be [Enabled]`                                |
| Forest            | Optional Features                                      | Features          | Verify Optional Feature `Privileged Access Management Feature should be [Enabled]`       |
| Forest            | Optional Features                                      | Features          | Verify Optional Feature `Laps should be enabled [Configured]`                            |
| Forest            | Sites Verification                                     | Sites             | Verify each `site has at least [one subnet configured]`                                  |
| Forest            | Sites Verification                                     | Sites             | Verify each `site has at least [one domain controller configured]`                       |
| Forest            | Site Links                                             | Site Links        | Verify each `site link is automatic`                                                     |
| Forest            | Site Links                                             | Site Links        | Verify each `site link uses notifications`                                               |
| Forest            | Site Links                                             | Site Links        | Verify each `site link does not use notifications`                                       |
| Forest            | Roles                                                  | Connectivity      | Verify each `FSMO holder is [reachable]`                                                 |
| Forest            | Orphaned/Empty Admins                                  | Security          | Verify `there are no Orphaned Admins (users/groups/computers)`                           |
| Forest            | Tombstone Lifetime                                     | Features          | Verify `Tombstone lifetime is greater or equal 180 days`                                 |
| Domain            | Roles                                                  | Connectivity      | Verify each `FSMO holder is [reachable]`                                                 |
| Domain            | Password Complexity Requirements                       | Password          | Verify Password `Complexity Policy should be [Enabled]`                                  |
| Domain            | Password Complexity Requirements                       | Password          | Verify Password `Length should be [greater than X]`                                      |
| Domain            | Password Complexity Requirements                       | Password          | Verify Password `Threshold should be [greater than X]`                                   |
| Domain            | Password Complexity Requirements                       | Password          | Verify Password `Lockout Duration should be [greater than X minutes]`                    |
| Domain            | Password Complexity Requirements                       | Password          | Verify Password `Lockout Observation Window should be [greater than X minutes]`          |
| Domain            | Password Complexity Requirements                       | Password          | Verify Password `Minimum Age should be [greater than X]`                                 |
| Domain            | Password Complexity Requirements                       | Password          | Verify Password `History Count should be [greater than X]`                               |
| Domain            | Password Complexity Requirements                       | Password          | Verify Password `Reversible Encryption should be [Disabled]`                             |
| Domain            | Trust Availability                                     | Connectivity      | Verify each `Trust status is OK`                                                         |
| Domain            | Trust Unconstrained TGTDelegation                      | Security          | Verify each `Trust TGTDelegation is set to True`                                         |
| Domain            | Kerberos Account Age                                   | Security          | Verify `Kerberos Last Password Change Should be less than 180 days`                      |
| Domain            | Groups: Account Operators                              | Security          | Verify `Group is empty`                                                                  |
| Domain            | Groups: Schema Admins                                  | Security          | Verify `Group is empty`                                                                  |
| Domain            | User: Administrator                                    | Security          | Verify `Last Password Change should be less than 360 days or account disabled`           |
| Domain            | DNS Forwarders                                         | DNS               | Verify `DNS Forwarders are identical on all DNS nodes`                                   |
| Domain            | DNS Scavenging - Primary DNS Server                    | DNS               | Verify `DNS Scavenging is set to [X days]`                                               |
| Domain            | DNS Scavenging - Primary DNS Server                    | DNS               | Verify `DNS Scavenging State is set to True`                                             |
| Domain            | DNS Scavenging - Primary DNS Server                    | DNS               | Verify `DNS Scavenging Time is less than [X days]`                                       |
| Domain            | DNS Zone Aging                                         | DNS               | Verify `DNS Zone Aging is set`                                                           |
| Domain            | DNS Zones Forest 0ADEL                                 | Configuration/DNS | Verify `owner is not 0ADEL`                                                              |
| Domain            | DNS Zones Domain 0ADEL                                 | Configuration/DNS | Verify `owner is not 0ADEL`                                                              |
| Domain            | Well known folder - UsersContainer                     | WellKnownFolders  | Verify `folder is not at it's defaults.`                                                 |
| Domain            | Well known folder - ComputersContainer                 | WellKnownFolders  | Verify `folder is not at it's defaults.`                                                 |
| Domain            | Well known folder - DomainControllersContainer         | WellKnownFolders  | Verify `folder is at it's defaults.`                                                     |
| Domain            | Well known folder - DeletedObjectsContainer            | WellKnownFolders  | Verify `folder is at it's defaults.`                                                     |
| Domain            | Well known folder - SystemsContainer                   | WellKnownFolders  | Verify `folder is at it's defaults.`                                                     |
| Domain            | Well known folder - LostAndFoundContainer              | WellKnownFolders  | Verify `folder is at it's defaults.`                                                     |
| Domain            | Well known folder - QuotasContainer                    | WellKnownFolders  | Verify `folder is at it's defaults.`                                                     |
| Domain            | Well known folder - ForeignSecurityPrincipalsContainer | WellKnownFolders  | Verify `folder is at it's defaults.`                                                     |
| Domain            | Orphaned Foreign Security Principals                   | Cleanup           | Verify `there are no orphaned FSP objects.`                                              |
| Domain            | Orphaned/Empty Organizational Units                    | Cleanup           | Verify `there are no orphaned Organizational Units`                                      |
| Domain            | Group Policy Missing Permissions                       | Configuration     | Verify `Authenticated Users/Domain Computers are on each and every Group Policy`         |
| Domain            | DFSR Sysvol                                            | Configuration     | Verify `SYSVOL is DFSR`                                                                  |
| Domain            | NTDS Parameters                                        | Configuration     | Verify `Domain Controller is writable (DSA Not Writable)`                                |
| Domain Controller | Information                                            | Configuration     | Verify `Is enabled`                                                                      |
| Domain Controller | Information                                            | Configuration     | Verify `Is global catalog`                                                               |
| Domain Controller | Service Status                                         | Services          | Verify all `{Services} are [running]`                                                    |
| Domain Controller | Service Status                                         | Services          | Verify all `{Services} are set to [automatic startup]`                                   |
| Domain Controller | Service Status (Print Spooler)                         | Security          | Verify `Print Spooler Service is set to disabled`                                        |
| Domain Controller | Service Status (Print Spooler)                         | Security          | Verify `Print Spooler Service is stopped`                                                |
| Domain Controller | Ping Connectivity                                      | Connectivity      | Verify `DC is [reachable]`                                                               |
| Domain Controller | Ports                                                  | Connectivity      | Verify `Following ports 53, 88, 135, 139, 389, 445, 464, 636, 3268, 3269, 9389 are open` |
| Domain Controller | RDP Ports                                              | Connectivity      | Verify `Following ports 3389 (RDP) is open`                                              |
| Domain Controller | RDP Security                                           | Connectivity      | Verify `NLA is enabled`                                                                  |
| Domain Controller | LDAP Connectivity                                      | Connectivity      | Verify all `{LDAP Ports} are open]`                                                      |
| Domain Controller | LDAP Connectivity                                      | Connectivity      | Verify all `{LDAP SSL Ports} are open]`                                                  |
| Domain Controller | Windows Firewall                                       | Connectivity      | Verify `windows firewall is enabled` for all network cards                               |
| Domain Controller | Windows Remote Management                              | Connectivity      | Verify `Windows Remote Management identification requests are managed`                   |
| Domain Controller | Resolves internal DNS queries                          | DNS               | Verify `DNS on DC [resolves Internal DNS]`                                               |
| Domain Controller | Resolves external DNS queries                          | DNS               | Verify `DNS on DC [resolves External DNS]`                                               |
| Domain Controller | Name servers for primary domain zone                   | DNS               | Verify `DNS Name servers for primary zone are identical`                                 |
| Domain Controller | Responds to PowerShell Queries                         | PowerShell        | Verify DC `responds to PowerShell queries`                                               |
| Domain Controller | TimeSettings                                           | Time              | Verify `PDC should [sync time to external source]`                                       |
| Domain Controller | TimeSettings                                           | Time              | Verify `Non-PDC should [sync time to PDC emulator]`                                      |
| Domain Controller | TimeSettings                                           | Time              | Verify `Virtualized DCs should [sync to hypervisor during boot time only]`               |
| Domain Controller | Time Synchronization Internal                          | Time              | Verify `Time Synchronization Difference to PDC [less than X seconds]`                    |
| Domain Controller | Time Synchronization External                          | Time              | Verify `Time Synchronization Difference to pool.ntp.org [less than X seconds]`           |
| Domain Controller | Disk Free                                              | Computer          | Verify `OS partition Free space is [at least X %]`                                       |
| Domain Controller | Disk Free                                              | Computer          | Verify `NTDS partition Free space is [at least X %]`                                     |
| Domain Controller | Operating System                                       | Computer          | Verify `Windows Operating system is Windows 2012 or higher`                              |
| Domain Controller | Windows Updates                                        | Computer          | Verify `Last patch was installed less than 60 days ago`                                  |
| Domain Controller | SMB Protocols                                          | Security          | Verify `SMB v1 protocol is disabled`                                                     |
| Domain Controller | SMB Protocols                                          | Security          | Verify `SMB v2 protocol is enabled`                                                      |
| Domain Controller | SMB Shares                                             | Security          | Verify `default SMB shares NETLOGON/SYSVOL are visible`                                  |
| Domain Controller | DFSR AutoRecovery                                      | Security          | Verify `DFSR AutoRecovery is enabled`                                                    |
| Domain Controller | Windows Roles and Features                             | Security          | Verify `Windows Features for AD/DNS/File Services are enabled`                           |

## Known Issues / By Design

- Requirements for Sources work differently then for Tests
  - For Sources when Requirements are not met Testimo skips it totally from output
  - For Tests when Requirements are not met Testimo marks it as skipped

## To install

```powershell
Install-Module -Name Testimo -AllowClobber -Force
```

Force and AllowClobber aren't really nessecary but they do skip errors in case some appear.

### And to update

```powershell
Update-Module -Name Testimo
```

That's it. Whenever there's new version you simply run the command and you can enjoy it. Remember, that you may need to close, reopen PowerShell session if you have already used module before updating it.

**The important thing** is if something works for you on production, keep using it till you test the new version on a test computer. I do changes that may not be big, but big enough that auto-update will break your code. For example, small rename to a parameter and your code stops working! Be responsible!

## To use after installation

With output to screen only

```powershell
Invoke-Testimo
```

![Image](https://evotec.xyz/wp-content/uploads/2019/08/img_5d68310c9f9a5.png)
![Image](https://evotec.xyz/wp-content/uploads/2019/08/img_5d6831266a8ac.png)
![Image](https://evotec.xyz/wp-content/uploads/2019/08/img_5d68323befd13.png)

With option to be able to process output - for example to email

```powershell
Invoke-Testimo -ReturnResults
```

## Changing default configuration

**Testimo** comes with preset rules that may not apply to your environment.
You may want to change some things like disabling some tests or changing some values (to an extent).
There are 3 ways to do it.
Depending on how you want to save/edit/pass configuration to TestIMO - I leave it up to you.

### Straight to FILE/JSON

```powershell
Get-TestimoConfiguration -FilePath $PSScriptRoot\Configuration\TestimoConfiguration.json
```

#### Straight to JSON

```powershell
Get-TestimoConfiguration -AsJson
```

#### Output to Hashtable so you can edit it freely and keep in ps1

```powershell
$OutputOrderedDictionary = Get-TestimoConfiguration
$OutputOrderedDictionary.Forest.OptionalFeatures.Tests.RecycleBinEnabled.Enable = $false
$OutputOrderedDictionary.Forest.OptionalFeatures.Tests.LapsAvailable.Enable = $true
$OutputOrderedDictionary.Forest.OptionalFeatures.Tests.LapsAvailable.Parameters.ExpectedValue = $false
```

## Using Invoke-Testimo with non-default configuration

Following configuration allows you to:

- Edit default TestImo configuration with some other values
- Exclude one of the domains
- Return Results for future processing
- Limit sources to only 4 types (you could also limit that via Hashtable but this way is quicker for Adhoc enabling/disabling)

```powershell
Import-Module Testimo

$OutputOrderedDictionary = Get-TestimoConfiguration
$OutputOrderedDictionary.Forest.OptionalFeatures.Tests.RecycleBinEnabled.Enable = $false
$OutputOrderedDictionary.Forest.OptionalFeatures.Tests.LapsAvailable.Enable = $true
$OutputOrderedDictionary.Forest.OptionalFeatures.Tests.LapsAvailable.Parameters.ExpectedValue = $false

$Sources = @(
    'ForestFSMORoles'
    'ForestOptionalFeatures'
    'ForestBackup'
    'ForestOrphanedAdmins'
    'DomainPasswordComplexity'
    'DomainKerberosAccountAge'
    'DomainDNSScavengingForPrimaryDNSServer'
    'DCWindowsUpdates'
)

$TestResults = Invoke-Testimo -ReturnResults -ExcludeDomains 'ad.evotec.pl' -Sources $Sources -Configuration $OutputOrderedDictionary
$TestResults | Format-Table -AutoSize *
```

Be sure to checkout **Examples** section for more **How-To**.

### Dependencies

- [x] PowerShell 5.1 - I know, bummer right?
- [x] RSAT if run externally from Windows 10 machine

When you use the `Install-Module` option what happens in the backgrouns is that Windows will use [PowershellGallery](https://www.powershellgallery.com/) (hosted by Microsoft) to download **Testimo** and any dependencies this module needs.
As it stands all dependencies except one (**DSInternals**) are my other PowerShell Modules.
Why I am using it this way? Because I don't want to write multiple times the same code over and over.

- [x] Testimo - this module
  - [x] [PSWinDocumentation.AD](https://github.com/EvotecIT/PSWinDocumentation.AD) - PowerShell Module that's main purpose is deliver formmated/compressive Active Directory data for documentation purposes. It's read only.
    - [x] [DSInternals](https://github.com/MichaelGrafnetter/DSInternals) - Directory Services Internals PowerShell Module and Framework by Michael Grafnetter - it's main purpose is to verify Active Directory Passwords
  - [x] [PSWinDocumentation.DNS](https://github.com/EvotecIT/PSWinDocumentation.DNS) - PowerShell Module that's main purpose is deliver formmated/compressive DNS data for documentation purposes (it's a bit unfinished product but it works as far Testimo is concerned). It's read only.
  - [x] [ADEssentials](https://github.com/EvotecIT/ADEssentials) - PowerShell Module that's supposed to hold a bunch of useful Get/Set tools for Active Directory.
  - [x] [PSSharedGoods](https://github.com/EvotecIT/PSSharedGoods) - PowerShell Module with lots of different, helpfull functions that I have gathered over the years
    - [x] [PSWriteColor](https://github.com/EvotecIT/PSWriteColor) - PowerShell Module responsible for Console Colors
    - [x] [Connectimo](https://github.com/EvotecIT/Connectimo) - PowerShell Module responsible for Connecting to O365 - while it's not in use in this project PSSharedGoods depends on it, so it's here. No function is used from it.
  - [x] [PSWriteHTML](https://github.com/EvotecIT/PSWriteHTML) - PowerShell Module that creates nice looking reports. Responsible for visual HTML reporting.
  - [x] [Emailimo](https://github.com/EvotecIT/Emailimo) - PowerShell Module that creates nice looking emails. Responsible for emails in Testimo.

In **Testimo** I'm using internal functions from some of the modules without any real documentation.

### Portability

There are times where you may want to use **Testimo** in Portable way.
Following function when executed will download all modules to given path and load them for you.
Following [blog post](https://evotec.xyz/making-powershellgallery-modules-portable/) shows the way.
It was written specifically for Testimo.

```PowerShell
Initialize-ModulePortable -Name 'Testimo' -Path "$PSScriptRoot\TestimoPortable" -Download
```

After that,, you can use `Invoke-Testimo` as you normally would.
You can also skip **Download** parameter if you already downloaded all the modules before.
This function is also available as part of [PSSharedGoods](https://github.com/EvotecIT/PSSharedGoods) module.

### Removal

In case you decide that **Testimo** is not for you, you can easily clean it up.
Unfortunetly since **Testimo** uses all those dependencies as mentioned above you will have to remove all those modules one by one.
Additionally if you have been using **Testimo** and you update it using `Update-Module` command and other modules got updated as well, it's possible there will be more then 1 version of said modules.
Keep in mind that if you already use some of my modules some of the stuff may be already there and needed for different modules. Be careful when removing **PowerShellModules**.

#### Option 1

- [x] Finding where modules are stored `(Get-Module -ListAvailable Testimo).ModuleBase`
- [x] Manually deleting all folders Testimo, and other dependant modules

#### Option 2

- [x] Run `Uninstall-Module`

```powershell
$Modules = @('Testimo', 'PSWinDocumentation.AD','PSWinDocumentation.DNS','ADEssentials', 'PSSharedGoods','PSWriteColor', 'Connectimo', 'DSInternals','Emailimo','PSWriteHTML' )
foreach ($Module in $Modules) {
    Uninstall-Module $Module -Force -AllVersions
}
```

Due to multiple versions per each module you may need to rerun this couple of times to remove all those mdoules in case there are some problems.
