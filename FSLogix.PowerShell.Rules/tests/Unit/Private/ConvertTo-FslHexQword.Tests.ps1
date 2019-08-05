$here = Split-Path -Parent $MyInvocation.MyCommand.Path
$funcType = Split-Path $here -Leaf
$sut = (Split-Path -Leaf $MyInvocation.MyCommand.Path) -replace '\.Tests\.', '.'
$here = $here | Split-Path -Parent | Split-Path -Parent | Split-Path -Parent
. "$here\functions\$funcType\$sut"

Describe "$($sut.Replace('.ps1',''))" {
    It "takes a int and has correct ouput" {
        ConvertTo-FslHexQword -RegData 45 | should -Be '2D00000000000000'
    }

    It "takes a max Uint64 and has correct ouput" {
        $maxNum = [uint64]::MaxValue
        ConvertTo-FslHexQword -RegData $maxNum | should -Be 'ffffffffffffffff'
    }

    It "takes a min Uint64 and has correct ouput" {
        $minNum = [Uint64]::MinValue
        ConvertTo-FslHexQword -RegData $minNum | should -Be '0000000000000000'
    }
}