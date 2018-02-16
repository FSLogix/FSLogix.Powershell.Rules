$here = Split-Path -Parent $MyInvocation.MyCommand.Path
$here = Split-Path $here
$sut = (Split-Path -Leaf $MyInvocation.MyCommand.Path) -replace '\.Tests\.', '.'
. "$here\$sut"

Describe 'Find-DuplicateLine' {
    BeforeAll {
        [Diagnostics.CodeAnalysis.SuppressMessageAttribute("PSUseDeclaredVarsMoreThanAssignments", "")]
        $visibleApp = Get-Content "..\..\TestFiles\AppRule_Office2013.fxr"
        [Diagnostics.CodeAnalysis.SuppressMessageAttribute("PSUseDeclaredVarsMoreThanAssignments", "")]
        $hidableApp = Get-Content "..\..\TestFiles\AppRule_Project2013Pro.fxr"
    }

    It 'Does Not Throw' {
        { Find-DuplicateLine -VisibleAppHidingRule $visibleApp -HidableAppHidingRule $hidableApp } | Should Not throw
    }
    It 'Creates Output' {
        (Find-DuplicateLine -VisibleAppHidingRule $visibleApp -HidableAppHidingRule $hidableApp).Count | Should BeGreaterThan 0
    }
    It 'Contains data that is present in the original hiding file for the visible app' {
        $line = Find-DuplicateLine -VisibleAppHidingRule $visibleApp -HidableAppHidingRule $hidableApp | Get-Random
        $visibleApp.Contains("$line") | Should Be $true
    }
        It 'Contains data that is present in the original hiding file for the app to be hidden' {
        $line = Find-DuplicateLine -VisibleAppHidingRule $visibleApp -HidableAppHidingRule $hidableApp | Get-Random
        $hidableApp.Contains("$line") | Should Be $true
    }
    It 'Dupes should not be more than Original visible app rules' {
        $dupes = Find-DuplicateLine -VisibleAppHidingRule $visibleApp -HidableAppHidingRule $hidableApp
        $dupes.Count -le $visibleApp.Count | Should Be $true
    }
    It 'Dupes should not be more than Original hidable app rules' {
        $dupes = Find-DuplicateLine -VisibleAppHidingRule $visibleApp -HidableAppHidingRule $hidableApp
        $dupes.Count -le $hidableApp.Count | Should Be $true
    }
    It "First line is not 1" {
        Find-DuplicateLine -VisibleAppHidingRule $visRul -HidableAppHidingRule $hideRul | Select-Object -First 1 | Should Not Be 1
    }

}