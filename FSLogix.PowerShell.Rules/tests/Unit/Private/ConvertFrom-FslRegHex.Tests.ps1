$here = Split-Path -Parent $MyInvocation.MyCommand.Path
$funcType = Split-Path $here -Leaf
$sut = (Split-Path -Leaf $MyInvocation.MyCommand.Path) -replace '\.Tests\.', '.'
$here = $here | Split-Path -Parent | Split-Path -Parent | Split-Path -Parent
. "$here\functions\$funcType\$sut"

Describe $sut.TrimEnd('.ps1') {

    It "Returns correct result for String" {
        ConvertFrom-FslRegHex -HexString 014300680061006E0067006500640057006900740068004700750069000000 -RegValueType String | Should -Be 'ChangedWithGui'
    }

    It "Returns correct result for DWORD" {
        ConvertFrom-FslRegHex -RegData '042D000000' -RegValueType DWORD | should -Be 45
    }

}