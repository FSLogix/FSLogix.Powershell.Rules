$here = Split-Path -Parent $MyInvocation.MyCommand.Path
$here = Split-Path $here
$sut = (Split-Path -Leaf $MyInvocation.MyCommand.Path) -replace '\.Tests\.', '.'
. "$here\$sut"

Describe "Find-DuplicateLine" {

    $visRul = Get-Content "..\..\TestFiles\AppRule_Office2013.fxr"
    $hideRul = Get-Content "..\..\TestFiles\AppRule_Project2013Pro.fxr"

    It "Produces output" {
        (Find-DuplicateLine -VisibleAppHidingRule $visRul -HidableAppHidingRule $hideRul).count | Should BeGreaterThan 1
    }
    It "First line is not 1" {
        Find-DuplicateLine -VisibleAppHidingRule $visRul -HidableAppHidingRule $hideRul | Select-Object -First 1 | Should Not Be 1
    }
}
