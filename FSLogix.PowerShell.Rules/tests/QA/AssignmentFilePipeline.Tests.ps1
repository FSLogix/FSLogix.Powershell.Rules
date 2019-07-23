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

        $files = @((Join-Path $global:here 'tests\QA\TestFiles\AllAssign\Assign.fxa'),
        (Join-Path $global:here 'tests\QA\TestFiles\AllAssign\AssignNoGroup.fxa'),
        (Join-Path $global:here 'tests\QA\TestFiles\AllAssign\ClientName.fxa'))

        foreach ($assignFile in $files) {
            $filename = $assignFile.Split('\')[-1]
            It "Gets and Sets App Masking Assignments for file $filename" {
                $hiding = Get-Content $assignFile
    
                $ld = Get-FslLicenseDay -Path $assignFile
    
                Get-FslAssignment -Path $assignFile | Set-FslAssignment -AssignmentFilePath Testdrive:\$filename
                $ld | Set-FslLicenseDay -Path Testdrive:\$filename
                $hidingTarget = Get-Content Testdrive:\$filename
    
                Compare-Object -ReferenceObject $hiding -DifferenceObject $hidingTarget | Measure-Object | Select-Object -ExpandProperty Count | Should Be 0
            }
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