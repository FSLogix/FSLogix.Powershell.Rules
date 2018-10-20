$here = Split-Path -Parent $MyInvocation.MyCommand.Path
$funcType = Split-Path $here -Leaf
$sut = (Split-Path -Leaf $MyInvocation.MyCommand.Path) -replace '\.Tests\.', '.'
$here = $here | Split-Path -Parent | Split-Path -Parent | Split-Path -Parent
. "$here\$funcType\$sut"

Describe $sut.TrimEnd('.ps1') {

    $path = Join-Path $here 'tests\QA\TestFiles\AllAssign\Notepad++.fxa'
    $name = 'Fake'

    It 'First test'{
        Remove-FslAssignment -Path $path -Name $name
    }
}