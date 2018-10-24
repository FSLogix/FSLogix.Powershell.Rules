$here = Split-Path -Parent $MyInvocation.MyCommand.Path
$global:sut = (Split-Path -Leaf $MyInvocation.MyCommand.Path) -replace '\.Tests\.', '.'
$global:here = $here | Split-Path -Parent | Split-Path -Parent | Split-Path -Parent

Import-Module -Name (Join-Path $global:here 'FSLogix.PowerShell.Rules.psd1') -Force

InModuleScope 'FSLogix.PowerShell.Rules' {

    Describe $global:sut.TrimEnd('.ps1') -Tag 'Unit' {

        $path = Join-Path $here 'tests\QA\TestFiles\AllAssign\Notepad++.fxa'
        $name = 'Fake'

        It 'First test' {
            Remove-FslAssignment -Path $path -Name $name
        }
    }
}