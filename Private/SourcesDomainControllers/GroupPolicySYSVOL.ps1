#Get-WInADGPOSysvol -Domain 'ad.evotec.pl' -ComputerName DC1 | ft -AutoSize *

$GroupPolicySYSVOL = @{
    Enable = $true
    Source = @{
        Name    = "Group Policy SYSVOL Verification"
        Data    = {
            Get-WinADGPOSysvolFolders -Domain $Domain -ComputerName $DomainController | Where-Object { $_.SysvolStatus -ne 'Exists' }
        }
        Details = [ordered] @{
            Area        = ''
            Description = ''
            Resolution  = ''
            RiskLevel   = 10
            Resources   = @(

            )
        }
        ExpectedOutput = $false
    }
}