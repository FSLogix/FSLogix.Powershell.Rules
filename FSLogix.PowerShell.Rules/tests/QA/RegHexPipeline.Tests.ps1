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

    Context "Dword" {
        
        $testNumbers = @(
            0,
            2147483647,
            20,
            65535,
            3147483647,
            4294967295
        )
        

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
            4294967295,
            42949672950,
            12199541755961100288,
            18212214579788599296,
            15000815849732499456,
            18446744073709551615
        )
            
    
        foreach ($test in $testNumbers) {
    
            It "Testing: $test" {
                ConvertTo-FslRegHex $test -RegValueType QWORD | ConvertFrom-FslRegHex | Select-Object -ExpandProperty Data | Should -be $test
            }
        }
    }

    Context 'Multi-String' {
        $testStrings = @(
            @('line one','line two', 'line three'),
            @('oneline')
        )

        foreach ($test in $testStrings) {
    
            It "Testing: $test" {
                ConvertTo-FslRegHex $test -RegValueType Multi-String | ConvertFrom-FslRegHex | Select-Object -ExpandProperty Data | Should -be $test
            }
        }
    }
}