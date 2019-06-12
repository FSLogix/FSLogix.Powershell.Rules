$here = Split-Path -Parent $MyInvocation.MyCommand.Path
$funcType = Split-Path $here -Leaf
$sut = (Split-Path -Leaf $MyInvocation.MyCommand.Path) -replace '\.Tests\.', '.'
$here = $here | Split-Path -Parent | Split-Path -Parent | Split-Path -Parent
. "$here\$funcType\$sut"

Describe "ConvertTo-FslRegHex" {
    Context "Parameter" {
        It "takes a string and has correct Ouput" {
            ConvertTo-FslRegHex -RegStringData ChangedWithGui | should -Be '014300680061006E0067006500640057006900740068004700750069000000'
        }
    }
}