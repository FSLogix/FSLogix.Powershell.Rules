$here = Split-Path -Parent $MyInvocation.MyCommand.Path
#$funcType = Split-Path $here -Leaf
$sut = (Split-Path -Leaf $MyInvocation.MyCommand.Path) -replace '\.Tests\.', '.'
$here = $here | Split-Path -Parent | Split-Path -Parent
#. "$here\$funcType\$sut"

Import-Module -Name (Join-Path $here 'FSLogix.PowerShell.Rules.psd1') -Force

InModuleScope 'FSLogix.PowerShell.Rules' {

    Describe Compare-FslRuleFile {

        BeforeAll {
            [Diagnostics.CodeAnalysis.SuppressMessageAttribute("PSUseDeclaredVarsMoreThanAssignments", "")]
            $outputPath = 'TestDrive:\'
        }

        It 'Produces 6 files' {
            New-Item -Path $outputPath -Name "Office2016" -ItemType "directory"
            Compare-FslRuleFile -Files (Get-ChildItem (Join-Path $here tests\QA\TestFiles\Office2016)).FullName -OutputPath (Join-Path $outputPath 'Office2016')
                (Get-ChildItem (Join-Path $outputPath 'Office2016')).count | Should Be 6
            }

        It 'Produces 6 files' {
            New-Item -Path $outputPath -Name "Office2013" -ItemType "directory"
            Compare-FslRuleFile -Files (Get-ChildItem (Join-Path $here tests\QA\TestFiles\Office2013)).FullName -OutputPath (Join-Path $outputPath 'Office2013')
            ( Get-ChildItem (Join-Path $outputPath 'Office2013') -File ).count | Should Be 6
        }

        It 'Produces 4 files' {
            New-Item -Path $outputPath -Name "Office2016Pro" -ItemType "directory"
            Compare-FslRuleFile -Files (Get-ChildItem (Join-Path $here tests\QA\TestFiles\Office2016Pro)).FullName -OutputPath (Join-Path $outputPath 'Office2016Pro')
            ( Get-ChildItem (Join-Path $outputPath 'Office2016Pro') -File ).count | Should Be 4
        }

    }
}
