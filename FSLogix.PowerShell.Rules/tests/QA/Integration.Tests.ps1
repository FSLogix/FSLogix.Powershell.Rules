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
            Compare-FslRuleFile -Files (Get-ChildItem (Join-Path $here tests\QA\TestFiles\Office2016Pro)).FullName -OutputPath $outputPath
                (Get-ChildItem $outputPath).count | Should Be 6
            }

        It 'Produces 6 files' {
            Compare-FslRuleFile -Files .\TestFiles\Office2013\Project2013.fxr, .\TestFiles\Office2013\Office2013.fxr, .\TestFiles\Office2013\Visio2013.fxr -OutputPath $outputPath
            ( Get-ChildItem $outputPath -File ).count | Should Be 12
        }

        It 'Produces 4 files' {
            Compare-FslRuleFile -Files .\TestFiles\Office2016\Project2016.fxr, .\TestFiles\Office2016\OfficeProPlus2016.fxr -OutputPath $outputPath
            ( Get-ChildItem $outputPath -File ).count | Should Be 16
        }

    }
}
