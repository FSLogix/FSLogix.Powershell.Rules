$here = Split-Path -Parent $MyInvocation.MyCommand.Path
#$funcType = Split-Path $here -Leaf
$sut = (Split-Path -Leaf $MyInvocation.MyCommand.Path) -replace '\.Tests\.', '.'
$global:here = $here | Split-Path -Parent | Split-Path -Parent
#. "$here\$funcType\$sut"

Import-Module -Name (Join-Path $global:here 'FSLogix.PowerShell.Rules.psd1') -Force

Describe Compare-FslRuleFile -Tag 'QA', 'Long' {

    InModuleScope 'FSLogix.PowerShell.Rules' {

        AfterAll {
            Remove-Variable -Name 'here' -Scope Global
        }

        $outputPath = 'TestDrive:\'

        $samplePath = Join-Path -Path $global:here -ChildPath tests\QA\TestFiles\CustomerSamples

        foreach ($folder in Get-ChildItem -Path $samplePath -Directory) {

            $files = Get-ChildItem -Path $folder.FullName -Filter "*.fxr"

            It "Produces $($files.count * 2) files for $($folder.name)" {
                $files = Get-ChildItem -Path $folder.FullName -Filter "*.fxr"
                New-Item -Path $outputPath -Name $folder.name -ItemType "directory"
                Compare-FslRuleFile -Files $files.FullName -OutputPath (Join-Path $outputPath $folder.name)
                (Get-ChildItem (Join-Path $outputPath $folder.name)).count | Should Be ($files.count * 2)

            }
        }
    }
}
