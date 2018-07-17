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

        $assignOriginal = Join-Path $global:here Tests\QA\TestFiles\AllAssign\Assign.fxa
        $assignTest = 'TestDrive:\Assignpipe.fxa'

        It 'Gives back the same file as you feed it from Get-FslAssignment' {
            Get-FslAssignment -Path $assignOriginal | Set-FslAssignment -AssignmentFilePath $assignTest
            Compare-Object -ReferenceObject (Get-Content $assignOriginal) -DifferenceObject (Get-Content $assignTest) | Measure-Object | Select-Object -ExpandProperty Count | Should be 0
        }

    }

}