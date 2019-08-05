$here = Split-Path -Parent $MyInvocation.MyCommand.Path
$funcType = Split-Path $here -Leaf
$sut = (Split-Path -Leaf $MyInvocation.MyCommand.Path) -replace '\.Tests\.', '.'
$here = $here | Split-Path -Parent | Split-Path -Parent | Split-Path -Parent
. "$here\functions\$funcType\$sut"

Describe "$($sut.Replace('.ps1',''))" {
    
    It "takes a string and has correct output" {
        ConvertTo-FslHexMultiString -RegData 'line one', 'line two', 'line three' | should -Be '6C0069006E00650020006F006E00650000006C0069006E0065002000740077006F0000006C0069006E0065002000740068007200650065000000'
    }
    
}