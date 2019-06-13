$here = Split-Path -Parent $MyInvocation.MyCommand.Path
#$funcType = Split-Path $here -Leaf
#$sut = (Split-Path -Leaf $MyInvocation.MyCommand.Path) -replace '\.Tests\.', '.'
$global:here = $here | Split-Path -Parent | Split-Path -Parent
#. "$here\$funcType\$sut"

Import-Module -Name (Join-Path $global:here 'FSLogix.PowerShell.Rules.psd1') -Force

Describe 'Get Assignment to Set Assignment should result in the same file' -Tag 'QA' {
    
    InModuleScope 'FSLogix.PowerShell.Rules' {
        
        AfterAll {
            Remove-Variable -Name 'here' -Scope Global
        }

        It 'Gets and Sets App Masking Assignments' {
            $path = Join-Path $global:here 'tests\QA\TestFiles\AllAssign\Assign.fxa'
            $hiding = Get-Content $path

            $ld = Get-FslLicenseDay -Path $path

            Get-FslAssignment -Path $path | Set-FslAssignment -AssignmentFilePath Testdrive:\Assign.fxa
            $ld | Set-FslLicenseDay -Path Testdrive:\Assign.fxa
            $hidingTarget = Get-Content Testdrive:\Assign.fxa

            Compare-Object -ReferenceObject $hiding -DifferenceObject $hidingTarget | Measure-Object | Select-Object -ExpandProperty Count | Should Be 0
        }

        <#
        It 'Gets and Sets Java Process Assignments' {
            $path = Join-Path $global:here 'tests\QA\TestFiles\AllAssign\java_1.6.0_45.fxa'
            $java = Get-Content $path

            Get-FslAssignment -Path $path | Set-FslAssignment -AssignmentFilePath Testdrive:\java_1.6.0_45.fxa
            $javaTarget = Get-Content Testdrive:\java_1.6.0_45.fxa

            Compare-Object -ReferenceObject $java -DifferenceObject $javaTarget | Measure-Object | Select-Object -ExpandProperty Count | Should Be 0
        }
        #>
    }
}