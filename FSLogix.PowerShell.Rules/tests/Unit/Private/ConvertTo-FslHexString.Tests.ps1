$here = Split-Path -Parent $MyInvocation.MyCommand.Path
$funcType = Split-Path $here -Leaf
$sut = (Split-Path -Leaf $MyInvocation.MyCommand.Path) -replace '\.Tests\.', '.'
$here = $here | Split-Path -Parent | Split-Path -Parent | Split-Path -Parent
. "$here\functions\$funcType\$sut"

Describe "$($sut.Replace('.ps1',''))" {
    
    It "takes a string ChangedWithGui and has correct output" {
        ConvertTo-FslHexString -RegData ChangedWithGui | should -Be '4300680061006E006700650064005700690074006800470075006900'
    }

    It "takes a string %PATH% and has correct output" {
        ConvertTo-FslHexString -RegData '%PATH%' | should -Be '250050004100540048002500'
    }
    
}