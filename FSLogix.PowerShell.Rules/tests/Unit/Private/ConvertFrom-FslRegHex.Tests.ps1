$here = Split-Path -Parent $MyInvocation.MyCommand.Path
$funcType = Split-Path $here -Leaf
$sut = (Split-Path -Leaf $MyInvocation.MyCommand.Path) -replace '\.Tests\.', '.'
$here = $here | Split-Path -Parent | Split-Path -Parent | Split-Path -Parent
. "$here\functions\$funcType\$sut"

Describe $sut.TrimEnd('.ps1') {

    It "Returns correct data for a String" {
        (ConvertFrom-FslRegHex -HexString 014300680061006E0067006500640057006900740068004700750069000000).Data | Should -Be 'ChangedWithGui'
    }

    It "Returns correct data for a DWORD" {
        (ConvertFrom-FslRegHex -HexString 042D000000).Data | should -Be 45
    }

    It "Returns correct data for a QWORD" {
        (ConvertFrom-FslRegHex -HexString 0Bffffffffffffffff).Data | should -Be ([UInt64]::MaxValue)
    }

    It "Returns correct type for String" {
        (ConvertFrom-FslRegHex -HexString 014300680061006E0067006500640057006900740068004700750069000000).RegValueType | Should -Be 'String'
    }

    It "Returns correct type for DWORD" {
        (ConvertFrom-FslRegHex -HexString 042D000000).RegValueType | should -Be 'DWORD'
    }

    It "Returns correct type for QWORD" {
        (ConvertFrom-FslRegHex -HexString 0Bffffffffffffffff).RegValueType | should -Be 'QWORD'
    }
}