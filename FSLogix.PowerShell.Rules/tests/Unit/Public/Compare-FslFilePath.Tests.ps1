$here = Split-Path -Parent $MyInvocation.MyCommand.Path
$funcType = Split-Path $here -Leaf
$sut = (Split-Path -Leaf $MyInvocation.MyCommand.Path) -replace '\.Tests\.', '.'
$here = $here | Split-Path -Parent | Split-Path -Parent | Split-Path -Parent
. "$here\$funcType\$sut"

Describe 'Compare-FslFilePath' -Tag 'Unit'{

    BeforeAll{
        [Diagnostics.CodeAnalysis.SuppressMessageAttribute("PSUseDeclaredVarsMoreThanAssignments", "")]
        $files = Get-ChildItem -Path "$here\tests\QA\TestFiles\OfficeInSameFolder" -File -Filter *.xml
        [Diagnostics.CodeAnalysis.SuppressMessageAttribute("PSUseDeclaredVarsMoreThanAssignments", "")]
        $out = 'C:\jimm\Output'
        Import-Module -Name (Join-Path $here 'FSLogix.PowerShell.Rules.psm1')
    }

    It 'Does Not Throw'{
        { Compare-FslFilePath -Files $files.FullName -OutputPath $out } | Should Not Throw
    }
}