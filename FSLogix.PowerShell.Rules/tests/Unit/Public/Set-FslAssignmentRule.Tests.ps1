$here = Split-Path -Parent $MyInvocation.MyCommand.Path
#$funcType = Split-Path $here -Leaf
$sut = (Split-Path -Leaf $MyInvocation.MyCommand.Path) -replace '\.Tests\.', '.'
$here = $here | Split-Path -Parent | Split-Path -Parent | Split-Path -Parent
#. "$here\$funcType\$sut"

Import-Module -Name (Join-Path $here 'FSLogix.PowerShell.Rules.psd1') -Force

InModuleScope 'FSLogix.PowerShell.Rules' {

    Describe $sut.Trimend('.ps1') -Tag 'Unit' {

        $assignOriginal = '..\..\QA\TestFiles\AllAssign\Assign.fxa'
        $assignTest = 'TestDrive:\Assignpipe.fxa'

        It 'Gives back the same file as you feed it from Get-FslAssignment' {
            Get-FslAssignment -Path $assignOriginal | Set-FslAssignment -AssignmentFilePath $assignTest
            Compare-Object -ReferenceObject (Get-Content $assignOriginal) -DifferenceObject (Get-Content $assignTest) | Measure-Object | Select-Object -ExpandProperty Count | Should be 0
        }

    }

}