function Invoke-Testimo {
    <#
    .SYNOPSIS
    Testimo simplifies Active Directory testing and reporting.

    .DESCRIPTION
    Testimo simplifies Active Directory testing and reporting. It provides a way to execute tests and generate HTML reports. It's a wrapper around other modules like PSWinDocumentation, PSSharedGoods, PSEventViewer, PSWriteHTML, ADEssentials, GPOZaurr, and more.

    .PARAMETER BaselineTests
    Specifies the baseline tests to be executed.

    .PARAMETER Sources
    Specifies the type of reports to be generated from a list of available reports.

    .PARAMETER ExcludeSources
    Specifies the type of report to be excluded from the list of available reports. By default, all reports are run.

    .PARAMETER ExcludeDomains
    Excludes specific domains from the search. By default, the entire forest is scanned.

    .PARAMETER IncludeDomains
    Includes only specific domains in the search. By default, the entire forest is scanned.

    .PARAMETER ExcludeDomainControllers
    Excludes specific domain controllers from the search. By default, no exclusions are made.

    .PARAMETER IncludeDomainControllers
    Includes only specific domain controllers in the search. By default, all domain controllers are included.

    .PARAMETER IncludeTags
    Includes only tests with specific tags. By default, all tests are included.

    .PARAMETER ExcludeTags
    Excludes tests with specific tags. By default, no tests are excluded.

    .PARAMETER ForestName
    Specifies the target forest to be tested. By default, the current forest is used.

    .PARAMETER PassThru
    Indicates whether to return created objects after the report is generated.

    .PARAMETER ShowErrors
    Specifies whether to display errors during the execution of the tests.

    .PARAMETER ExtendedResults
    Indicates whether to return more detailed information to the console.

    .PARAMETER Configuration
    Loads configuration settings from a file or an object.

    .PARAMETER FilePath
    Path where the HTML report will be saved. If not specified, the report will be saved in the temporary directory and the path will be displayed in console.

    .PARAMETER ShowReport
    Specifies whether to display the HTML report once the tests are completed.

    .PARAMETER HideHTML
    Specifies whether to prevent the HTML report from being displayed in the default browser upon completion.

    .PARAMETER HideSteps
    Specifies whether to exclude the steps in the report.

    .PARAMETER AlwaysShowSteps
    Specifies whether to always show the steps in the report.

    .PARAMETER SkipRODC
    Specifies whether to skip Read-Only Domain Controllers. By default, all domain controllers are included.

    .PARAMETER Online
    Specifies whether HTML files should use CSS/JS from the Internet (CDN). By default, CSS/JS is embedded in the HTML file.

    .PARAMETER ExternalTests
    Specifies external tests to be included.

    .PARAMETER Variables
    Specifies additional variables to be used during the tests.

    .PARAMETER SplitReports
    Specifies whether to split the report into multiple files, one for each report.

    .EXAMPLE
    Example 1
    ----------------
    Invoke-Testimo -Sources DCDiskSpace, DCFileSystem

    .EXAMPLE
    Example 2
    ----------------
    Invoke-Testimo -Sources DCDiskSpace, DCFileSystem -SplitReports -ReportPath "$PSScriptRoot\Reports\Testimo.html" -AlwaysShowSteps
    Invoke-Testimo -Sources DomainComputersUnsupported, DomainDuplicateObjects -SplitReports -ReportPath "$PSScriptRoot\Reports\Testimo.html" -AlwaysShowSteps

    .NOTES
    General notes
    #>
    [alias('Test-ImoAD', 'Test-IMO', 'Testimo')]
    [CmdletBinding()]
    param(
        [ScriptBlock] $BaselineTests,
        [alias('Type')][string[]] $Sources,
        [alias('ExludeType')] [string[]] $ExcludeSources,
        [string[]] $ExcludeDomains,
        [string[]] $ExcludeDomainControllers,
        [string[]] $IncludeDomains,
        [string[]] $IncludeDomainControllers,
        # this requires rebuild of all tests
        [string] $ForestName,
        [alias('ReturnResults')][switch] $PassThru,
        [switch] $ShowErrors,
        [switch] $ExtendedResults,
        [Object] $Configuration,
        [alias('ReportPath')][string] $FilePath,
        [Parameter(DontShow)][switch] $ShowReport,
        [switch] $HideHTML,
        [alias('HideSolution')][switch] $HideSteps,
        [alias('AlwaysShowSolution')][switch] $AlwaysShowSteps,
        [switch] $SkipRODC,
        [switch] $Online,
        [string[]] $ExternalTests,
        [System.Collections.IDictionary] $Variables,
        [switch] $SplitReports,
        [alias('Tags')][string[]] $IncludeTags,
        [string[]] $ExcludeTags
    )
    if ($ShowReport) {
        Write-Warning "Invoke-Testimo - Paramter ShowReport is deprecated. By default HTML report will open up after running Testimo. If you want to prevent that, use HideHTML switch instead. This message and parameter will be removed in future releases."
    }

    $Script:Reporting = [ordered] @{ }
    $Script:Reporting['Version'] = ''
    $Script:Reporting['Errors'] = [System.Collections.Generic.List[PSCustomObject]]::new()
    $Script:Reporting['Results'] = $null
    $Script:Reporting['Summary'] = [ordered] @{ }

    $TestimoVersion = Get-Command -Name 'Invoke-Testimo' -ErrorAction SilentlyContinue
    $ProgressPreference = 'SilentlyContinue'
    [Array] $GitHubReleases = (Get-GitHubLatestRelease -Url "https://api.github.com/repos/evotecit/Testimo/releases")
    $ProgressPreference = 'Continue'
    $LatestVersion = $GitHubReleases[0]

    if (-not $LatestVersion.Errors) {
        if ($TestimoVersion.Version -eq $LatestVersion.Version) {
            $Script:Reporting['Version'] = "Current/Latest: $($LatestVersion.Version) at $($LatestVersion.PublishDate)"
        } elseif ($TestimoVersion.Version -lt $LatestVersion.Version) {
            $Script:Reporting['Version'] = "Current: $($TestimoVersion.Version), Published: $($LatestVersion.Version) at $($LatestVersion.PublishDate). Update?"
        } elseif ($TestimoVersion.Version -gt $LatestVersion.Version) {
            $Script:Reporting['Version'] = "Current: $($TestimoVersion.Version), Published: $($LatestVersion.Version) at $($LatestVersion.PublishDate). Lucky you!"
        }
    } else {
        $Script:Reporting['Version'] = "Current: $($TestimoVersion.Version)"
    }
    Out-Informative -OverrideTitle 'Testimo' -Text 'Version' -Level 0 -Status $null -ExtendedValue $Script:Reporting['Version']

    if ($BaselineTests) {
        $BaseLineTestsObjects = & $BaselineTests
        if ($BaseLineTestsObjects) {
            Add-TestimoBaseLines -BaseLineObjects $BaseLineTestsObjects
        }
    }

    Add-TestimoSources -Folder $ExternalTests

    if (-not $Script:DefaultSources) {
        $Script:DefaultSources = Get-TestimoSources -Enabled -SourcesOnly
    } else {
        Set-TestsStatus -Sources $Script:DefaultSources
    }

    # make sure that tests are initialized (small one line tests require more, default data)
    Initialize-TestimoTests

    Import-TestimoConfiguration -Configuration $Configuration

    $global:ProgressPreference = 'SilentlyContinue'
    $global:ErrorActionPreference = 'Stop'
    $Script:TestResults = [System.Collections.Generic.List[PSCustomObject]]::new()
    $Script:TestimoConfiguration.Debug.ShowErrors = $ShowErrors
    $Script:TestimoConfiguration.Exclusions.Domains = $ExcludeDomains
    $Script:TestimoConfiguration.Exclusions.DomainControllers = $ExcludeDomainControllers
    $Script:TestimoConfiguration.Inclusions.Domains = $IncludeDomains
    $Script:TestimoConfiguration.Inclusions.DomainControllers = $IncludeDomainControllers

    if (-not $Sources -and -not ($IncludeTags -or $ExcludeTags)) {
        $Sources = $Script:DefaultSources
    }
    Set-TestsStatus -Sources $Sources -ExcludeSources $ExcludeSources -IncludeTags $IncludeTags -ExcludeTags $ExcludeTags

    $Script:Reporting['Forest'] = [ordered] @{ }
    $Script:Reporting['Forest']['Summary'] = $null
    $Script:Reporting['Forest']['Tests'] = [ordered] @{ }
    $Script:Reporting['Domains'] = [ordered] @{ }
    $Scopes = $Script:TestimoConfiguration.Types.Keys
    foreach ($Scope in $Scopes) {
        $Script:Reporting[$Scope] = [ordered] @{ }
        $Script:Reporting[$Scope]['Summary'] = $null
        $Script:Reporting[$Scope]['Tests'] = [ordered] @{ }
    }
    $Script:Reporting['BySource'] = [ordered] @{}


    if ($Script:TestimoConfiguration.Inclusions.Domains) {
        Out-Informative -Text 'Only following Domains will be scanned' -Level 0 -Status $null -ExtendedValue ($Script:TestimoConfiguration.Inclusions.Domains -join ', ')
    }
    if ( $Script:TestimoConfiguration.Inclusions.DomainControllers) {
        Out-Informative -Text 'Only following Domain Controllers will be scanned' -Level 0 -Status $null -ExtendedValue ($Script:TestimoConfiguration.Inclusions.DomainControllers -join ', ')
    }
    # We only exclude if inclusion is not specified for Domains
    if ($Script:TestimoConfiguration.Exclusions.Domains -and -not $Script:TestimoConfiguration.Inclusions.Domains) {
        Out-Informative -Text 'Following Domains will be ignored' -Level 0 -Status $null -ExtendedValue ($Script:TestimoConfiguration.Exclusions.Domains -join ', ')
    }
    # We only exclude if inclusion is not specified for Domain Controllers
    if ( $Script:TestimoConfiguration.Exclusions.DomainControllers -and -not $Script:TestimoConfiguration.Inclusions.DomainControllers) {
        Out-Informative -Text 'Following Domain Controllers will be ignored' -Level 0 -Status $null -ExtendedValue ($Script:TestimoConfiguration.Exclusions.DomainControllers -join ', ')
    }

    Get-RequestedSources -Sources $Sources -ExcludeSources $ExcludeSources -IncludeTags $IncludeTags -ExcludeTags $ExcludeTags

    if ($Script:TestimoConfiguration['Types']['ActiveDirectory']) {
        $ForestDetails = Get-WinADForestDetails -WarningVariable ForestWarning -WarningAction SilentlyContinue -Forest $ForestName -ExcludeDomains $ExcludeDomains -IncludeDomains $IncludeDomains -IncludeDomainControllers $IncludeDomainControllers -ExcludeDomainControllers $ExcludeDomainControllers -SkipRODC:$SkipRODC -Extended
        if ($ForestDetails) {
            # Tests related to FOREST
            $null = Start-Testing -Scope 'Forest' -ForestInformation $ForestDetails.Forest -ForestDetails $ForestDetails -SkipRODC:$SkipRODC -Variables $Variables {
                # Tests related to DOMAIN
                foreach ($Domain in $ForestDetails.Domains) {
                    $Script:Reporting['Domains'][$Domain] = [ordered] @{ }
                    $Script:Reporting['Domains'][$Domain]['Summary'] = [ordered] @{ }
                    $Script:Reporting['Domains'][$Domain]['Tests'] = [ordered] @{ }
                    $Script:Reporting['Domains'][$Domain]['DomainControllers'] = [ordered] @{ }

                    if ($ForestDetails['DomainsExtended']["$Domain"]) {
                        Start-Testing -Scope 'Domain' -Domain $Domain -DomainInformation $ForestDetails['DomainsExtended']["$Domain"] -ForestInformation $ForestDetails.Forest -ForestDetails $ForestDetails -SkipRODC:$SkipRODC -Variables $Variables {
                            # Tests related to DOMAIN CONTROLLERS
                            if (Get-TestimoSourcesStatus -Scope 'DC') {
                                foreach ($DC in $ForestDetails['DomainDomainControllers'][$Domain]) {
                                    $Script:Reporting['Domains'][$Domain]['DomainControllers'][$DC.HostName] = [ordered] @{ }
                                    $Script:Reporting['Domains'][$Domain]['DomainControllers'][$DC.HostName]['Summary'] = [ordered] @{ }
                                    $Script:Reporting['Domains'][$Domain]['DomainControllers'][$DC.HostName]['Tests'] = [ordered] @{ }
                                    Start-Testing -Scope 'DC' -Domain $Domain -DomainController $DC.HostName -IsPDC $DC.IsPDC -DomainInformation $ForestDetails['DomainsExtended']["$Domain"] -ForestInformation $ForestDetails.Forest -ForestDetails $ForestDetails -Variables $Variables
                                }
                            }
                        }
                        #}
                    }
                }
            }
        } else {
            Write-Color -Text '[e]', '[Testimo] ', "Forest Information couldn't be gathered. ", "[", "Error", "] ", "[", $ForestWarning, "]" -Color Red, DarkGray, Yellow, Cyan, DarkGray, Cyan, Cyan, Red, Cyan
        }
    }
    foreach ($Scope in $Scopes | Where-Object { $_ -notin 'ActiveDirectory' }) {
        if ($Script:TestimoConfiguration['Types'][$Scope]) {
            $null = Start-Testing -Scope $Scope -Variables $Variables
        }
    }
    $Script:Reporting['Results'] = $Script:TestResults

    if ($PassThru -and $ExtendedResults) {
        $Script:Reporting
    } else {
        if ($PassThru) {
            $Script:TestResults
        }
    }
    if (-not $FilePath) {
        $FilePath = Get-FileName -Extension 'html' -Temporary
    }

    Start-TestimoReport -Scopes $Scopes -FilePath $FilePath -Online:$Online -ShowHTML:(-not $HideHTML.IsPresent) -TestResults $Script:Reporting -HideSteps:$HideSteps -AlwaysShowSteps:$AlwaysShowSteps -SplitReports:$SplitReports
}

[scriptblock] $SourcesAutoCompleter = {
    param($commandName, $parameterName, $wordToComplete, $commandAst, $fakeBoundParameters)
    @(
        $Script:TestimoConfiguration.ActiveDirectory.Keys
        $Script:TestimoConfiguration.Office365.Keys
    ) | Sort-Object | Where-Object { $_ -like "*$wordToComplete*" }
}
Register-ArgumentCompleter -CommandName Invoke-Testimo -ParameterName Sources -ScriptBlock $SourcesAutoCompleter
Register-ArgumentCompleter -CommandName Invoke-Testimo -ParameterName ExcludeSources -ScriptBlock $SourcesAutoCompleter
Register-ArgumentCompleter -CommandName Get-TestimoSources -ParameterName Sources -ScriptBlock $SourcesAutoCompleter