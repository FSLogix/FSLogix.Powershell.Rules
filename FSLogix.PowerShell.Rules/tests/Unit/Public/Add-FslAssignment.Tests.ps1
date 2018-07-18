$here = Split-Path -Parent $MyInvocation.MyCommand.Path
#$funcType = Split-Path $here -Leaf
$global:sut = (Split-Path -Leaf $MyInvocation.MyCommand.Path) -replace '\.Tests\.', '.'
$global:here = $here | Split-Path -Parent | Split-Path -Parent | Split-Path -Parent
#. "$here\$funcType\$sut"

Import-Module -Name (Join-Path $global:here 'FSLogix.PowerShell.Rules.psd1') -Force

InModuleScope 'FSLogix.PowerShell.Rules' {

    Describe $global:sut.Trimend('.ps1') -Tag 'Unit' {

        AfterAll {
            Remove-Variable -Name 'here' -Scope Global
            Remove-Variable -Name 'sut' -Scope Global
        }

    }

}