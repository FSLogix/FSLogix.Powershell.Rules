$here = Split-Path -Parent $MyInvocation.MyCommand.Path
#$funcType = Split-Path $here -Leaf
#$sut = (Split-Path -Leaf $MyInvocation.MyCommand.Path) -replace '\.Tests\.', '.'
$here = $here | Split-Path -Parent | Split-Path -Parent | Split-Path -Parent
. "$here\FSLogix.PowerShell.Rules\functions\Private\ConvertFrom-FslRegHex.ps1"
. "$here\FSLogix.PowerShell.Rules\functions\Private\ConvertTo-FslRegHex.ps1"

Describe "Tests to and from converstion string to registry hexadecimal" {
    Context "Strings" {
        $test1 = 'The Quick Brown Fox Jumped Over The Lazy Dog'
        $test2 = '0123456789'
        $test3 = 'c:\jimm\doesnotexist'
        $test4 = 'Pipe and brackets | () {} []'
        $test5 = 'Escaping Jim''s quote'
        $test6 = "As they say, ""live and learn."""
        $test7 = "As they say, 'live and learn.'"
        $test8 = 'As they say, "live and learn."'

        $tests = $test1, $test2, $test3, $test4, $test5, $test6, $test7, $test8

        foreach ($test in $tests) {

            It "Testing: $test" {
                ConvertTo-FslRegHex $test -RegValueType String | ConvertFrom-FslRegHex -RegValueType String | Should -be $test
            }
        }
    }
}