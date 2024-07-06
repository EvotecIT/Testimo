# Testimo Release History

## 0.0.89
- Improve `ForestTomstoneLifetime` to check for 180 days in RecycleBin and not only for TombestoneLifetime
- Improve HTML reports by hiding specific columns in tables

## 0.0.88 - 2024.01.23
- Added `WindowsSecureTimeSeeding` check in `DCTimeSettings` check

## 0.0.87 - 2024.01.15
- Fixes `DomainComputersUnsupported`,`DomainComputersUnsupportedMainstream`
- Add missing dependency PSSharedGoods

## 0.0.86 - 2023.12.12
- Improve `DomainDomainControllers` by adding checks for PasswordNotRequired/PasswordNeverExpires as those are critical for DCs
- Tables in Testimo now use ScrollX to make it easier to read on smnaller screen
- Fixes `DCLDAP` date comparison
- Improves `DCDiskSpace` to show more information
- Improve `ForestOptionalFeatures` by adding WindowsLAPS detection
- Rename `DomainSecurityKRBGT` to `DomainSecurityKrbtgt` as it should be
- Improve `DomainSecurityKrbtgt` to detect Azure AD Keberbos account and measure it/ignore
- Added ability to use `IncludeTags`,`ExcludeTags` to filter tests (only on Source level, not on tests level)

## 0.0.85 - 2023.03.08
- Improve `DCSMBShares`
- Improve `DCSMBSharesPermissions`

## 0.0.84 - 2022.11.22
- Improves error handling for DSC
- Fixes Get-Get-TestimoConfiguration
- Added `SplitReports` to `Invoke-Testimo` to allow splitting the reports into multiple files (1 per category) more easily
- Added icons in `SplitReports` tabs to make it easier to identify if there's a problem in given DC/Domain

## 0.0.83 - 2022.07.29
- Fixes issue with some tests returning an error `You cannot call a method on a null-valued expression.`

## 0.0.82 - 2022.07.20
- Small fix for `DomainMachineQuota` displaying unnessecary warnings and too many properties

## 0.0.81 - 2022.07.20
- Added new test `ForestVulnerableSchemaClass`

## 0.0.80 - 2022.07.07
- Fixes `Results meet expected values, but test listed as failure in 0.0.79` [#165](https://github.com/EvotecIT/Testimo/issues/165)

## 0.0.79 - 2022.06.30
- Fixes link to MSFT article on LDAP binding/signing in script is 404 [#160](https://github.com/EvotecIT/Testimo/issues/160)
- Fixes `DomainWellKnownFolders` [#162](https://github.com/EvotecIT/Testimo/issues/162)
- Improves DSC comparison

## 0.0.78 - 2022.04.02
  - Fix PowerShell 2.0 detection [#161](https://github.com/EvotecIT/Testimo/pull/161) - tnx Sparticuz

## 0.0.77 - 2022.03.14
  - Fixes [Well Know Folders test fails on ambiguous name #159](https://github.com/EvotecIT/Testimo/issues/159)
  - Added ability to use `Compare-Testimo` as a way to compare two DSC files (single object, can have nested properties)

## 0.0.76 - 2022.02.24
  - Added new test `DCWindowsFeaturesOptional` to check for PowerShell 2.0 on DCs
  - Updated test `DomainSecurityUsersAcccountAdministrator`
  - Added ability to use `Compare-Testimo` as a way to compare two JSON files (single object, can have nested properties)

## 0.0.75 - 2022.01.25
  - Fixes errors that could happen for some tests during HTML creation

## 0.0.74 - 2022.01.25
  - Improved test `ForestDuplicateSPN` to check for duplicate SPNs in a forest
  - Added test `ForestRootKDS` to check for a KDS Root Key
  - Fixes a typo in `DomainSecurityComputers` [#156](https://github.com/EvotecIT/Testimo/issues/156)
  - Improved summary a bit (still requires work)
  - Added support for external tests

## 0.0.73 - 2021.02.03
  - Added a new test `DomainMachineQuota` to check for `ms-DS-MachineAccountQuota`
  - Fixed `Windows Server 2022 version flagged as failed` [#141](https://github.com/EvotecIT/Testimo/issues/141)
  - Fixed `Some tests report Fail but no reason why` [#143](https://github.com/EvotecIT/Testimo/issues/143)
  - Fixed charts to show proper values (the ones from the table) [#149](https://github.com/EvotecIT/Testimo/issues/149)
  - Modified charts colors to more eye friendly (at least to me) [#149](https://github.com/EvotecIT/Testimo/issues/149)
  - Modified console output to show statuses the same as HTML version instead of Pass/Fail [#145](https://github.com/EvotecIT/Testimo/issues/145)
  - Modified console output to remove full stop from some statuses [#147](https://github.com/EvotecIT/Testimo/issues/147)
  - Added a new test `ForestDuplicateSPN` to check for duplicate SPNs in a forest
  - Fixed `Skipped section in diagram but everything is True in report` [#151](https://github.com/EvotecIT/Testimo/issues/151)
  - Improved `ForestReplication` and `ForestReplicationStatus`
  - Improved `DomainOrganizationalUnitsEmpty`
## 0.0..72 - 2021.07.20
  - Fixes [Group Policy SysvolDC checking for non-existent property](https://github.com/EvotecIT/Testimo/issues/135) - tnx jwmoss
## 0.0..71 - 2021.07.05
  - Fixes spelling [#131](https://github.com/EvotecIT/Testimo/pull/131) - tnx ghBCollier
  - Improves `DomainDNSResolveExternal` [#133](https://github.com/EvotecIT/Testimo/pull/133) - tnx rmbolger
## 0.0..70 - 2021.06.10
  - Tests
    - 🐛 Fixed `DomainGroupPolicyPermission` - Unknown GPOs were detected incorrectly [#129](https://github.com/EvotecIT/Testimo/pull/129) tnx illumniN8i
    - 🐛 Fixed `DomainDHCPAuthorized` - properly detects single DHCP [#128](https://github.com/EvotecIT/Testimo/pull/128) tnx illumniN8i
## 0.0..69 - 2021.05.27
  - General
    - Small fix for reports
  - Tests
    - 📦 Added `ForestDHCP`
## 0.0..68 - 2021.04.21
  - General
    - 🐛 Small detection of problems with gathering information about Forest
  - Tests
    - 📦 Added `DomainSecurityDelegatedObjects`
## 0.0..67 - 2021.04.07
  - Tests
  - 💡 Improved `DomainGroupPolicyAssessment`
## 0.0..66 - 2021.04.07
  - Tests
    - 📦 Added `DomainSecurityComputers`
    - 🔠 Renamed `DomainGroupPolicyAssessment` due to typo [#124](https://github.com/EvotecIT/Testimo/pull/124) / tnx JasonCook599
    - 🐛 Fixed `DomainGroupPolicyAssessment` empty and problematic GPOs detection condition [#124](https://github.com/EvotecIT/Testimo/pull/124) / tnx JasonCook599
## 0.0..65 - 2021.03.23
  - [x] Tests
    - [x] Improvement `DomainSecurityUsers`
    - [x] Improvement `DomainSecurityKRBGT`
  - [x] General
    - [x] Improvement of HTML
## 0.0..64 - 2021.03.23
  - [x] Tests
    - [x] Improvement `DomainSecurityUsers`
    - [x] Improvement `DomainSecurityKRBGT`
  - [x] General
    - [x] Improvement of HTML
## 0.0..63 - 2021.03.23
  - [x] Tests
    - [x] Improvement `ForestSubnets`
## 0.0..62 - 2021.03.20
  - [x] Tests
    - [x] Fixed `DCDNSResolveExternal` reported in [#122](https://github.com/EvotecIT/Testimo/issues/122)
    - [x] Improvement `ForestTrusts`
  - [x] General
    - [x] Improvement of HTML
## 0.0..61 - 2021.03.17
  - [x] Tests
    - [x] Improved `ForestTrusts`
    - [x] Improved `ForestRoles`
  - [x] General
    - [ ] Improvement of HTML
## 0.0..60 - 2021.03.17
  - [x] Tests
    - [x] Improved `ForestSubnets`
    - [x] Improved `ForestSites`
    - [x] Improved `ForestOptionalFeatures`
    - [x] Improved `ForestBackup`
    - [x] Improved `ForestTombstoneLifetime`
    - [x] Improved `DomainDomainControllers`
    - [x] Improved `DomainLDAP`
    - [x] Improved `DomainOrphanedSecurityPrincipals`
  - [x] General
    - [x] Added `AlwaysShowSteps`
    - [x] Improved support for new [PSWriteHTML](https://github.com/EvotecIT/pswritehtml)
## 0.0..59 - 2021.03.01
  - [x] General
    - [x] Misspelled word in report (Extream -> Extreme) [#120](https://github.com/EvotecIT/Testimo/issues/120) - tnx mojomojoman
## 0.0..58 - 2021.02.25
  - [x] Tests
    - [x] Added `ForestSubnets`
    - [x] Improved `DomainDomainControllers`
    - [x] Improved `DomainLDAP`
    - [x] Improved `ForestBackup`
    - [x] Improved `ForestOrphanedAdmins`
    - [x] Improved `ForestConfigurationPartitionOwners`
    - [x] Improved `DomainDuplicateObjects`
    - [x] Improved `ForestSites`
  - [x] General
    - [x] Improved reporting
    - [x] Improved reporting status (assesment)
## 0.0..57 - 2021.02.21
  - [x] Tests
    - [x] Added `DomainLDAP` - takes over `DCLDAP`
    - [x] Disabled `DCLDAP` by default. Still there just not used.
    - [x] Improved `ForestOrphanedAdmins`
    - [x] Improved `ForestConfigurationPartitionOwners`
    - [x] Improved `DomainDuplicateObjects`
    - [x] Improved `DomainDomainControllers`
  - [x] General
    - [x] Renamed Parameter `ReturnResults` to `PassThru` (left as an alias)
    - [x] Fixed loading configuration from JSON/File/HashTable - **Configuration changed so much rebuild will be required**
    - [x] Fixed saving configuration to JSON/File/HashTable - **Configuration changed so much rebuild will be required**
    - [x] Parameter for `Invoke-Testimo` **ShowReport** is deprecated and doesn't do anything
    - [x] Parameter for `Invoke-Testimo` **HideHTML** was added and prevents auto-opening of HTML
    - [x] Parameter for `Invoke-Testimo` **HideSteps**/**HideSolution** was added to hide solution/steps in case it's not needed
    - [x] Added additional information about HTML report generating where the file was saved (useful if no FilePath was provided)
    - [x] Parameter `ReportPath` was renamed to `FilePath`, `ReportPath` is still an alias - to get it the same as [GPOZaurr](https://github.com/EvotecIT/GPOZaurr)
  - [x] Reporting
    - [x] Solution/Steps added to Report when available for display
    - [x] Reporting is still getting more and more changes
## 0.0..56 - 2021.02.07
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
## 0.0..55 - 2021.02.02
  - [x] Improvement to report (domain section)
  - [x] Improvement to `DomainDuplicateObjects`
  - [x] Improvement to `OrphanedForeignSecurityPrincipals`
  - [x] Removed `ForestDuplicateObjects` - duplicate of `DomainDuplicateObjects`
## 0.0..54 - 2021.01.29
  - [x] Fixes report to work with IE 11 (not great, not bad either)
## 0.0..53 - 2021.01.28
  - [x] Improved `DomainDomainControllers`
## 0.0..52 - 2021.01.27
  - [x] Improved `DCUNCHardenedPaths` to check for multiple values
## 0.0..51 - 2021.01.26
  - [x] Fix for Invoke-Testimo crashing on dead/non-responding/no-access DC [#117](https://github.com/EvotecIT/Testimo/issues/117)
## 0.0..50 - 2021.01.25
  - [x] Fix for Invoke-Testimo returning more than one line of error which would stop Testimo [#116](https://github.com/EvotecIT/Testimo/issues/116)
## 0.0..49 - 2021.01.25
  - [x] Fix for Invoke-Testimo not working correctly with some tests [#116](https://github.com/EvotecIT/Testimo/issues/116)
  - [x] Improved some tests
  - [x] Reporting
    - [x] HTML report improved a bit for Domain based checks
## 0.0..48 - 2021.01.21
  - [x] Fix for Invoke-Testimo not working when no tests are defined
  - [x] Tests
    - [x] Added `DomainDomainControllers` - covers DC ACL owner, DC Manager, DC Password Last Set, DC Last Logon, Enabled
## 0.0..47 - 2021.01.19
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
## 0.0..46 - 2020.10.29
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
## 0.0..45 - 2020.10.20
  - [x] Reversed on HTML change due to issues
## 0.0..44 - 2020.10.19
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
## 0.0..43 - 2020.06.17
  - Tests
    - [x] Small name update to `OrganizationalUnitsEmpty` and `OrganizationalUnitsProtected` fixing [#103](https://github.com/EvotecIT/Testimo/issues/103)
## 0.0..42 - 2020.06.08
  - Tests
    - [x] Fix for `DCNetSessionEnumeration` not run against target [#102](https://github.com/EvotecIT/Testimo/issues/102)
  - Engine
    - [x] Better `Sources` handling during typing
## 0.0..41 - 2020.06.06
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

## 0.0..40 - 2020.05.09
  - Engine
    - [x] ExpectedOutput is now required for Source
  - Tests
    - [x] ExpectedOutput (true/false/null) added for all tests
    - [x] Fix regression `ForestReplicationStatus` if multiple DC
    - [x] Fix regression `ForestReplication` if multiple DC
    - [x] Added `DomainDuplicateObjects` test - finds CNF objects

## 0.0..39 - 2020.04.11
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

## 0.0..38 - 2020.03.14
  - Added GroupPolicy and ActiveDirectory to RequiredModules and ExternalModuleDependencies preventing error reported in [#91](https://github.com/EvotecIT/Testimo/issues/91)

## 0.0..37 - 2020.03.13
  - Engine
    - [x] Update to `DomainSecurityUsers` to exclude DomainGuests
    - [x] Fix for ExpectedOutput $false
  - Tests
    - [x] Fix for `DomainSecurityUsers` - tnx itpro-tips [#89](https://github.com/EvotecIT/Testimo/issues/89)
    - [x] Added DomainSecurityKRBGT
    - [x] Improved `DCNetworkSettings` - DNS: DNS servers on Ethernet should include the loopback address, but not as the first entry - [#90](https://github.com/EvotecIT/Testimo/pull/90) - tnx itpro-tips
    - [x] Improved `DCNetworkSettings` - DNS: Ethernet should have static IPv4 settings (disabled by default) - [#90](https://github.com/EvotecIT/Testimo/pull/90) - tnx itpro-tips
    - [x] Improved `DCLanManServer` - [ADV200005 | Microsoft Guidance for Disabling SMBv3 Compression](https://portal.msrc.microsoft.com/en-US/security-guidance/advisory/adv200005) - Disabled by default, as patch is available

## 0.0..36 - 2020.03.04
  - Engine
    - [x] Fix for broken tests

## 0.0..35 - 2020.03.04
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

## 0.0..34 - 2020.01.29
  - Tests
    - [x] Modify repadmin (ForestReplicationStatus) for non-english OS [#86](https://github.com/EvotecIT/Testimo/pull/86) - tnx Fiyorden

## 0.0..33 - 2020.01.28
  - Tests
    - [x] Fixing legacy ADM files check - [#84](https://github.com/EvotecIT/Testimo/issues/84) - tnx PMORMR

## 0.0..32 - 2020.01.27
  - Tests
    - [x] Fix for DCGroupPolicySYSVOL - [#83](https://github.com/EvotecIT/Testimo/issues/83) - tnx PMORMR

## 0.0..31 - 2020.01.23
  - Engine
    - [x] Fix for loading configuration

## 0.0..30 - 2020.01.19
  - Engine
    - [x] Fix for version checks

## 0.0..29 - 2020.01.19
  - Engine
    - [x] Added IncludeDomain, IncludeDomainControllers (when used skips Exclusions)
      - [ ] This requires heavy improvements - soon enough
    - [x] Fixes issue when first running single source and then running all tests (it would use the "old source" instead of using defaults)
  - Tests
    - [x] Fix for Windows Roles and Feature for other language (non-english) [#79](https://github.com/EvotecIT/Testimo/pull/79) - tnx Fiyorden
    - [x] Added LDAPInsecureBindings

## 0.0..28 - 2019.12.29
  - Engine
    - [x] Fix for not running tests for DC if no Forest/Domain tests are present
    - [x] Added -SkipRODC parameter to skip DCs that are RODC

## 0.0..27 - 2019.12.26
  - Engine
    - [x] Better support for Portable Testimo

## 0.0..26 - 2019.12.26
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

## 0.0..25 - 2019.11.18
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
## 0.0..23 - 2019.10.08
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

## 0.0..22 - 2019.09.10
  - Tests
    - [x] DCPorts - typo fix OPEN vs CLOSED

## 0.0..21 - 2019.09.10
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

## 0.0..20 - 2019.09.09
  - [x] Fix for configuration loading from JSON file ([#30](https://github.com/EvotecIT/Testimo/issues/30) - tnx Alex)

## 0.0..19 - 2019.09.08
  - [x] First public release - More information in [blog post](https://evotec.xyz/what-do-we-say-to-health-checking-active-directory/)!