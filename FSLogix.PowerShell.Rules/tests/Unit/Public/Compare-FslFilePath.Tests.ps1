$here = Split-Path -Parent $MyInvocation.MyCommand.Path
$here = Split-Path -Parent $MyInvocation.MyCommand.Path
#$funcType = Split-Path $here -Leaf
$global:sut = (Split-Path -Leaf $MyInvocation.MyCommand.Path) -replace '\.Tests\.', '.'
$global:here = $here | Split-Path -Parent | Split-Path -Parent | Split-Path -Parent
#. "$here\$funcType\$sut"

Import-Module -Name (Join-Path $global:here 'FSLogix.PowerShell.Rules.psd1') -Force

Describe $global:sut.Trimend('.ps1') -Tag 'Long' {

    InModuleScope 'FSLogix.PowerShell.Rules' {

        AfterAll {
            Remove-Variable -Name 'here' -Scope Global
            Remove-Variable -Name 'sut' -Scope Global
        }
        
        $files = Get-ChildItem -Path "$global:here\tests\QA\TestFiles\CustomerSamples\OfficeInSameFolder" -File -Filter *.xml
        $out = 'Testdrive:\'

        It 'Does Not Throw' {
            { Compare-FslFilePath -Files $files.FullName -OutputPath $out } | Should Not Throw
        }
    }
}
