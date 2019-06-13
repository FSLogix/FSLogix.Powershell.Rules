$here = Split-Path -Parent $MyInvocation.MyCommand.Path
#$funcType = Split-Path $here -Leaf
#$sut = (Split-Path -Leaf $MyInvocation.MyCommand.Path) -replace '\.Tests\.', '.'
$global:here = $here |  Split-Path -Parent | Split-Path -Parent
#. "$here\$funcType\$sut"

Import-Module -Name (Join-Path $global:here 'FSLogix.PowerShell.Rules.psd1') -Force

Describe 'Get Rule to Set Rule should result in the same file' -Tag 'QA' {

    InModuleScope 'FSLogix.PowerShell.Rules' {

        AfterAll {
            Remove-Variable -Name 'here' -Scope Global
        }

        It 'Gets and Sets Hiding Rules' {
            $path = Join-Path $global:here 'tests\QA\TestFiles\AllHiding\Hiding.fxr'
            $hiding = Get-Content $path

            Get-FslRule -Path $path | Set-FslRule -RuleFilePath Testdrive:\Hiding.fxr
            $hidingTarget = Get-Content Testdrive:\Hiding.fxr

            Compare-Object -ReferenceObject $hiding -DifferenceObject $hidingTarget | Measure-Object | Select-Object -ExpandProperty Count | Should Be 0
        }

        It 'Gets and Sets Redirect Rules' {
            $path = Join-Path $global:here 'tests\QA\TestFiles\AllHiding\redirect.fxr'
            $redirect = Get-Content $path

            Get-FslRule -Path $path | Set-FslRule -RuleFilePath Testdrive:\redirect.fxr
            $redirectTarget = Get-Content Testdrive:\redirect.fxr

            Compare-Object -ReferenceObject $redirect -DifferenceObject $redirectTarget | Measure-Object | Select-Object -ExpandProperty Count | Should Be 0
        }
        <#
        It 'Gets and Sets Specify Rules' {
            $path = Join-Path $global:here 'tests\QA\TestFiles\AllHiding\specify.fxr'
            $specify = Get-Content $path

            Get-FslRule -Path $path | Set-FslRule -RuleFilePath Testdrive:\specify.fxr
            $specifyTarget = Get-Content Testdrive:\specify.fxr

            Compare-Object -ReferenceObject $specify -DifferenceObject $specifyTarget | Measure-Object | Select-Object -ExpandProperty Count | Should Be 0
        }

        It 'Gets and Sets Volume Rules' {
            $path = Join-Path $global:here 'tests\QA\TestFiles\AllHiding\volume.fxr'
            $volume = Get-Content $path

            Get-FslRule -Path $path | Set-FslRule -RuleFilePath Testdrive:\volume.fxr
            $volumeTarget = Get-Content Testdrive:\volume.fxr

            Compare-Object -ReferenceObject $volume -DifferenceObject $volumeTarget | Measure-Object | Select-Object -ExpandProperty Count | Should Be 0
        }
        #>
    }
}