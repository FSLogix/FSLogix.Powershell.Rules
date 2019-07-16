$here = Split-Path -Parent $MyInvocation.MyCommand.Path
$funcType = Split-Path $here -Leaf
$sut = (Split-Path -Leaf $MyInvocation.MyCommand.Path) -replace '\.Tests\.', '.'
$here = $here | Split-Path -Parent | Split-Path -Parent | Split-Path -Parent
. "$here\functions\$funcType\$sut"

Describe "ConvertTo-FslRegHex" {
    Context "Parameter" {
        It "takes a string and has correct output" {
            ConvertTo-FslRegHex -RegData ChangedWithGui -RegValueType String | should -Be '014300680061006E0067006500640057006900740068004700750069000000'
        }

        It "takes a int and has correct ouput" {
            ConvertTo-FslRegHex -RegData 45 -RegValueType DWORD | should -Be '042D000000'
        }
    } #Context
}