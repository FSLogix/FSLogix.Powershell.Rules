$here = Split-Path -Parent $MyInvocation.MyCommand.Path
#$funcType = Split-Path $here -Leaf
#$sut = (Split-Path -Leaf $MyInvocation.MyCommand.Path) -replace '\.Tests\.', '.'
$here = $here | Split-Path -Parent | Split-Path -Parent | Split-Path -Parent
. "$here\FSLogix.PowerShell.Rules\functions\Private\ConvertFrom-FslRegHex.ps1"
. "$here\FSLogix.PowerShell.Rules\functions\Private\ConvertTo-FslRegHex.ps1"

Describe "Tests to and from converstion string to registry hexadecimal" -Tag 'Current' {
    Context "Strings" {
        $testStrings = @(
            'The Quick Brown Fox Jumped Over The Lazy Dog',
            '0123456789',
            'c:\jimm\doesnotexist',
            'Pipe and brackets | () {} []',
            'Escaping Jim''s quote',
            "As they say, ""live and learn.""",
            "As they say, 'live and learn.'",
            'As they say, "live and learn."'
        )

        foreach ($test in $testStrings) {

            It "Testing: $test" {
                ConvertTo-FslRegHex $test -RegValueType String | ConvertFrom-FslRegHex | Select-Object -ExpandProperty Data | Should -be $test
            }
        }
    }

<<<<<<< HEAD
    Context "Dword" {
        
        $testNumbers = @(
            0,
            2147483647,
            20,
            65535,
            4294967295
        )
        
=======
    Context "Dword"  {
        #$testDword1 = 0
        $testDword2 = 2147483647
        $testDword3 = 20
        #$testDword4 = -1
        $testDword5 = -2147483648

        $tests = $testDword2, $testDword3
>>>>>>> 259b38b0f39546a6546b4ccdbfd1e1fe009f99cf

        foreach ($test in $testNumbers) {

            It "Testing: $test" {
                ConvertTo-FslRegHex $test -RegValueType Dword | ConvertFrom-FslRegHex | Select-Object -ExpandProperty Data | Should -be $test
            }
        }
    }

    Context "Qword" {
        
            $testNumbers = @(
                0,
                2147483647,
                20,
                65535,
                2147483648,
                4294967295
            )
            
    
            foreach ($test in $testNumbers) {
    
                It "Testing: $test" {
                    ConvertTo-FslRegHex $test -RegValueType Dword | ConvertFrom-FslRegHex | Select-Object -ExpandProperty Data | Should -be $test
                }
            }

        It "ItName" {
            Assertion
        }
    }
}