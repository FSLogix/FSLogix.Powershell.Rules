$here = Split-Path -Parent $MyInvocation.MyCommand.Path
#$funcType = Split-Path $here -Leaf
$sut = (Split-Path -Leaf $MyInvocation.MyCommand.Path) -replace '\.Tests\.', '.'
$here = $here |  Split-Path -Parent | Split-Path -Parent
#. "$here\$funcType\$sut"

Import-Module -Name (Join-Path $here 'FSLogix.PowerShell.Rules.psd1') -Force

InModuleScope 'FSLogix.PowerShell.Rules' {

    Describe 'Get Rule to Set Rule should result in the same file' {

        It 'Gets and Sets Hiding' {
            $path = Join-Path $here 'tests\QA\TestFiles\AllHiding\Hiding.fxr'

            $hiding = Get-Content $path

            Get-FslRule -Path $path | Set-FslRule -RuleFilePath Testdrive:\Hiding.fxr

            $hidingTarget = Get-Content Testdrive:\Hiding.fxr

            Compare-Object -ReferenceObject $hiding -DifferenceObject $hidingTarget

        }


                    $redirect = Get-Content (Join-Path $here 'tests\QA\TestFiles\AllHiding\Redirect.fxr')
            $specify = Get-Content (Join-Path $here 'tests\QA\TestFiles\AllHiding\Specify.fxr')
            $volume = Get-Content (Join-Path $here 'tests\QA\TestFiles\AllHiding\volume.fxr')

    }
}