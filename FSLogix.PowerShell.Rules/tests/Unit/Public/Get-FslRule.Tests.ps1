$here = Split-Path -Parent $MyInvocation.MyCommand.Path
#$funcType = Split-Path $here -Leaf
$global:sut = (Split-Path -Leaf $MyInvocation.MyCommand.Path) -replace '\.Tests\.', '.'
$global:here = $here | Split-Path -Parent | Split-Path -Parent | Split-Path -Parent
#. "$here\$funcType\$sut"

Import-Module -Name (Join-Path $global:here 'FSLogix.PowerShell.Rules.psd1') -Force

Describe $global:sut.Trimend('.ps1')  -Tag 'Unit' {

    InModuleScope 'FSLogix.PowerShell.Rules' {

        AfterAll {
            Remove-Variable -Name 'here' -Scope Global
            Remove-Variable -Name 'sut' -Scope Global
        }

        $result = Get-FslRule -Path ( Join-Path $global:here tests\QA\TestFiles\AllHiding\Hiding.fxr )
        
        It 'outputs the right type' {
            $first = $result | select-object -First 1
            $first.psobject.typenames | Should Contain 'FSLogix.Rule'
        }

    }


}