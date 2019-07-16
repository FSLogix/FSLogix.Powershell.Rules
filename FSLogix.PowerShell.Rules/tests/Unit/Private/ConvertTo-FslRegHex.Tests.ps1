$here = Split-Path -Parent $MyInvocation.MyCommand.Path
$funcType = Split-Path $here -Leaf
$sut = (Split-Path -Leaf $MyInvocation.MyCommand.Path) -replace '\.Tests\.', '.'
$here = $here | Split-Path -Parent | Split-Path -Parent | Split-Path -Parent
. "$here\functions\$funcType\$sut"

Describe "ConvertTo-FslRegHex" {
    Context "String" {
        It "takes a string and has correct output" {
            ConvertTo-FslRegHex -RegData ChangedWithGui -RegValueType String | should -Be '014300680061006E0067006500640057006900740068004700750069000000'
        }
    }
    Context 'DWORD' {

        It "takes a int and has correct ouput" {
            ConvertTo-FslRegHex -RegData 45 -RegValueType DWORD | should -Be '042D000000'
        }

        It "takes a max uint32 and has correct ouput" {
            $maxNum = [uint32]::MaxValue
            ConvertTo-FslRegHex -RegData $maxNum -RegValueType DWORD | should -Be '04ffffffff'
        }

        It "takes a min uint32 and has correct ouput" {
            $minNum = [uint32]::MinValue
            ConvertTo-FslRegHex -RegData $minNum -RegValueType DWORD | should -Be '0400000000'
        }

    }

    Context 'QWORD' {

        It "takes a int and has correct ouput" {
            ConvertTo-FslRegHex -RegData 45 -RegValueType QWORD | should -Be '0B2D00000000000000'
        }

        It "takes a max Uint64 and has correct ouput" {
            $maxNum = [uint64]::MaxValue
            ConvertTo-FslRegHex -RegData $maxNum -RegValueType QWORD | should -Be '0Bffffffffffffffff'
        }

        It "takes a min Uint64 and has correct ouput" {
            $minNum = [Uint64]::MinValue
            ConvertTo-FslRegHex -RegData $minNum -RegValueType QWORD | should -Be '0B0000000000000000'
        }
    } #Context
}