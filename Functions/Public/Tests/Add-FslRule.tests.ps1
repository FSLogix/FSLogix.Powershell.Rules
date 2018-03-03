$here = Split-Path -Parent $MyInvocation.MyCommand.Path
$here = Split-Path $here
$sut = (Split-Path -Leaf $MyInvocation.MyCommand.Path) -replace '\.Tests\.', '.'
. "$here\$sut"

Describe Add-FSlRule {
    Mock ConvertTo-FslRuleCode {'0x00000221'}
    Mock Add-Content {''}
    Mock Export-Csv {''}

    BeforeAll {
        . ..\..\Private\ConvertTo-FslRuleCode.ps1
    }

    It 'Does not throw' {
        {Add-FslRule -RuleFilePath 'Testdrive:\temprule.fxr' -Name "Testdrive:\madeup.txt"} | should not throw
    }
    It 'Does not return an object' {
        ($result | Measure-Object).Count | Should Be 0
    }
    It 'Returns an object from passthru' {
        
        (Add-FslRule -RuleFilePath 'Testdrive:\temprule.fxr' -Name "Testdrive:\madeup.txt" -Passthru | Measure-Object).Count | Should Be 1
    }

}