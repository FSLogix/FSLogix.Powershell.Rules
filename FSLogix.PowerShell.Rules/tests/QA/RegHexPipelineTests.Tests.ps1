$here = Split-Path -Parent $MyInvocation.MyCommand.Path
$funcType = Split-Path $here -Leaf
$sut = (Split-Path -Leaf $MyInvocation.MyCommand.Path) -replace '\.Tests\.', '.'
$here = $here | Split-Path -Parent | Split-Path -Parent | Split-Path -Parent
. "$here\FSLogix.PowerShell.Rules\Private\ConvertFrom-FslRegHex.ps1"
. "$here\FSLogix.PowerShell.Rules\Private\ConvertTo-FslRegHex.ps1"

Describe "Tests to and from converstion string to registry hexadecimal" {
    Context "Strings" {
        $test1 = 'The Quick Brown Fox Jumped Over The Lazy Dog'
        $test2 = '0123456789'
        $test3 = 'c:\jimm\doesnotexist'
        $tests = $test1,$test2,$test3

        foreach ($test in $tests) {

            It "Testing: $test" {
                ConvertTo-FslRegHex $test | ConvertFrom-FslRegHex | Should -be $test
            }
        }
    }
}