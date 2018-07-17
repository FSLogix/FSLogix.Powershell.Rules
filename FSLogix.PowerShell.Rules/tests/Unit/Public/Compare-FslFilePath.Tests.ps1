$here = Split-Path -Parent $MyInvocation.MyCommand.Path
$here = Split-Path -Parent $MyInvocation.MyCommand.Path
#$funcType = Split-Path $here -Leaf
$sut = (Split-Path -Leaf $MyInvocation.MyCommand.Path) -replace '\.Tests\.', '.'
$global:here = $here | Split-Path -Parent | Split-Path -Parent | Split-Path -Parent
#. "$here\$funcType\$sut"

Import-Module -Name (Join-Path $global:here 'FSLogix.PowerShell.Rules.psd1') -Force

InModuleScope 'FSLogix.PowerShell.Rules' {

    Describe 'Get Rule to Set Rule should result in the same file' -Tag 'QA' {

        AfterAll {
            Remove-Variable -Name 'here' -Scope Global
        }

        Describe 'Compare-FslFilePath' -Tag 'Unit' {

            BeforeAll {
                [Diagnostics.CodeAnalysis.SuppressMessageAttribute("PSUseDeclaredVarsMoreThanAssignments", "")]
                $files = Get-ChildItem -Path "$global:here\tests\QA\TestFiles\CustomerSamples\OfficeInSameFolder" -File -Filter *.xml
                [Diagnostics.CodeAnalysis.SuppressMessageAttribute("PSUseDeclaredVarsMoreThanAssignments", "")]
                $out = 'C:\jimm\Output'
                Import-Module -Name (Join-Path $global:here 'FSLogix.PowerShell.Rules.psd1')
            }

            It 'Does Not Throw' {
               # { Compare-FslFilePath -Files $files.FullName -OutputPath $out } | Should Not Throw
            }
        }
    }
}