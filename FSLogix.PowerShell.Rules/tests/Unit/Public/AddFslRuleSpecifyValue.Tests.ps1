##$here = Split-Path -Parent $MyInvocation.MyCommand.Path
#$funcType = Split-Path $here -Leaf
#$sut = (Split-Path -Leaf $MyInvocation.MyCommand.Path) -replace '\.Tests\.', '.'
##$here = $here | Split-Path -Parent | Split-Path -Parent | Split-Path -Parent
#. "$here\$funcType\$sut"
. "D:\PoSHCode\GitHub\FSLogix.Powershell.Rules\FSLogix.PowerShell.Rules\Public\Add-FslRule.ps1"
. "D:\PoSHCode\GitHub\FSLogix.Powershell.Rules\FSLogix.PowerShell.Rules\Private\ConvertTo-FslRuleCode.ps1"

Describe "Specify Value" {
    Context "SV" {
        It "Takes param" {
            Add-FslRule -FullName 'HKCU\Software\FSLogix\Test' -RegValueType 'String' -ValueData 'ChangedByPowerShell' -RuleFilePath C:\jimm\test.fxr
        }
    }
}