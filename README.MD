﻿<p align="center">
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

- ✅ Configuration hash is not written in stone and can change rapidly as **Testimo** gets tested
- ✅ Ideas are VERY welcome
- ✅ There's a big mess in files/function names - I'm still testing things out creating some random names, will be cleaned up later on
- ✅ There are lots of details missing for tests, and some things may not work as you want - please report issues or if you know how, fix them
- ✅ I don't know EVERYTHING - I'm very open to help with making Testimo more robust, detailed and easy to use
- ✅ This module works great in Windows PowerShell!

## Known Issues / By Design

- Requirements for Sources work differently then for Tests
  - For Sources when Requirements are not met Testimo skips it totally from output
  - For Tests when Requirements are not met Testimo marks it as skipped

## Installation

```powershell
Install-Module -Name Testimo -AllowClobber -Force
```

Force and AllowClobber aren't really nessecary but they do skip errors in case some appear.

## Updates

```powershell
Update-Module -Name Testimo
```

Alternatively, rerunnng `Install-Module` with force will trigger reinstallation or update

```powershell
Install-Module -Name Testimo -AllowClobber -Force
```

That's it. Whenever there's new version you simply run the command and you can enjoy it. Remember, that you may need to close, reopen PowerShell session if you have already used module before updating it.

**The important thing** is if something works for you on production, keep using it till you test the new version on a test computer. I do changes that may not be big, but big enough that auto-update will break your code. For example, small rename to a parameter and your code stops working! Be responsible!

## Usage

With output to screen and HTML

```powershell
Invoke-Testimo
```

Generate all tests but display content only in PowerShell

```powershell
Invoke-Testimo -HideHTML
```

![Image](https://evotec.xyz/wp-content/uploads/2019/08/img_5d68310c9f9a5.png)
![Image](https://evotec.xyz/wp-content/uploads/2019/08/img_5d6831266a8ac.png)
![Image](https://evotec.xyz/wp-content/uploads/2019/08/img_5d68323befd13.png)

Please keep in mind that there is currently known issue that running all tests while works correctly generated HTML is very very slow when switching Tabs.
It's advised to run seperate tests which will generate smaller file which will be more responsive

```powershell
Invoke-Testimo -Source 'ForestOptionalFeatures','DomainWellKnownFolders','ForestSubnets' -Online -ReportPath $PSScriptRoot\Reports\TestimoSummary.html -AlwaysShowSteps
```

There are also other parameters available With option to be able to process output - for example to email

```powershell
Invoke-Testimo -ReturnResults
```

### Using Invoke-Testimo with non-default configuration

Following configuration allows you to:

- Edit default TestImo configuration with some other values
- Exclude one of the domains
- Return Results for future processing
- Limit sources to only 4 types (you could also limit that via Hashtable but this way is quicker for Adhoc enabling/disabling)

```powershell
Import-Module Testimo

$OutputOrderedDictionary = Get-TestimoConfiguration
$OutputOrderedDictionary.ForestOptionalFeatures.Tests.RecycleBinEnabled.Enable = $false
$OutputOrderedDictionary.ForestOptionalFeatures.Tests.LapsAvailable.Enable = $true
$OutputOrderedDictionary.ForestOptionalFeatures.Tests.LapsAvailable.Parameters.ExpectedValue = $false

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

$TestResults = Invoke-Testimo -PassThru -ExcludeDomains 'ad.evotec.pl' -Sources $Sources -Configuration $OutputOrderedDictionary
$TestResults | Format-Table -AutoSize *
```

Be sure to checkout **Examples** section for more **How-To**.

### Changing default configuration

**Testimo** comes with preset rules that may not apply to your environment.
You may want to change some things like disabling some tests or changing some values (to an extent).
There are 3 ways to do it.
Depending on how you want to save/edit/pass configuration to TestIMO - I leave it up to you.

#### Straight to FILE/JSON

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
$OutputOrderedDictionary.ForestOptionalFeatures.Tests.RecycleBinEnabled.Enable = $false
$OutputOrderedDictionary.ForestOptionalFeatures.Tests.LapsAvailable.Enable = $true
$OutputOrderedDictionary.ForestOptionalFeatures.Tests.LapsAvailable.Parameters.ExpectedValue = $false
```

## Comments

Keep in mind not all tests apply to each environment.
I'm adding those to be flexible and be able to test things as needed.
Each of those tests will need additional description and recommendation, most likely with links and steps to fix.
Some of the tests are very basic and will need feedback, work on making it a robust test.
Nothing is written in stone for now. Things can change day by day.

## Things to consider

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
