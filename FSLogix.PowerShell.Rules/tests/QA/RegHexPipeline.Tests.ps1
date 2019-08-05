$here = Split-Path -Parent $MyInvocation.MyCommand.Path
#$funcType = Split-Path $here -Leaf
$sut = (Split-Path -Leaf $MyInvocation.MyCommand.Path) -replace '\.Tests\.', '.'
$global:here = $here | Split-Path -Parent | Split-Path -Parent
#. "$here\$funcType\$sut"

Import-Module -Name (Join-Path $global:here 'FSLogix.PowerShell.Rules.psd1') -Force

Describe "Tests to and from converstion string to registry hexadecimal" -Tag 'Current' {
    InModuleScope FSLogix.PowerShell.Rules {
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
                    $hex = ConvertTo-FslHexString $test
                    '01' + $hex + '0000'| ConvertFrom-FslRegHex | Select-Object -ExpandProperty Data | Should -be $test
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
                    $hex = ConvertTo-FslHexDword $test 
                    '04' + $hex | ConvertFrom-FslRegHex | Select-Object -ExpandProperty Data | Should -be $test
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
                    $hex = ConvertTo-FslHexQword $test 
                    '0B' + $hex | ConvertFrom-FslRegHex | Select-Object -ExpandProperty Data | Should -be $test
                }
            }
        }

        Context 'Multi-String' {

            $testStrings = @(
                @('line one', 'line two', 'line three'),
                @('oneline')
            )

            foreach ($test in $testStrings) {
    
                It "Testing: $test" {
                    $hex = ConvertTo-FslHexMultiString $test 
                    '07' + $hex + '000000'| ConvertFrom-FslRegHex | Select-Object -ExpandProperty Data | Should -be $test
                }
            }
        }
    }
}