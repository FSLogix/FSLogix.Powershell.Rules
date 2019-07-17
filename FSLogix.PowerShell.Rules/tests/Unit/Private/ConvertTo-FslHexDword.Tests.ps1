$here = Split-Path -Parent $MyInvocation.MyCommand.Path
$funcType = Split-Path $here -Leaf
$sut = (Split-Path -Leaf $MyInvocation.MyCommand.Path) -replace '\.Tests\.', '.'
$here = $here | Split-Path -Parent | Split-Path -Parent | Split-Path -Parent
. "$here\functions\$funcType\$sut"

Describe "$($sut.Replace('.ps1',''))" {
    It "takes a int and has correct ouput" {
        ConvertTo-FslHexDword -RegData 45 | should -Be '2D000000'
    }

    It "takes a max uint32 and has correct ouput" {
        $maxNum = [uint32]::MaxValue
        ConvertTo-FslHexDword -RegData $maxNum | should -Be 'ffffffff'
    }

    It "takes a min uint32 and has correct ouput" {
        $minNum = [uint32]::MinValue
        ConvertTo-FslHexDword -RegData $minNum | should -Be '00000000'
    }
}