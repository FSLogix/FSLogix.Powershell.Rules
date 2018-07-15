$here = Split-Path -Parent $MyInvocation.MyCommand.Path
$funcType = Split-Path $here -Leaf
$sut = (Split-Path -Leaf $MyInvocation.MyCommand.Path) -replace '\.Tests\.', '.'
$here = $here | Split-Path -Parent | Split-Path -Parent | Split-Path -Parent
. "$here\FSLogix.PowerShell.Rules\Private\ConvertFrom-FslAssignmentCode.ps1"
. "$here\FSLogix.PowerShell.Rules\Private\ConvertTo-FslAssignmentCode.ps1"

Describe 'Pipeline conversion back and forth' {

    BeforeAll {
        [Diagnostics.CodeAnalysis.SuppressMessageAttribute("PSUseDeclaredVarsMoreThanAssignments", "")]
        $AssignmentCodes = Get-content $here\FSLogix.PowerShell.Rules\Tests\QA\TestFiles\AllAssign\Assign.fxa |
            Select-Object -Skip 1 |
            ConvertFrom-String -Delimiter `t -PropertyNames Codes |
            Select-Object @{n = 'Codes'; e = {'0x' + "{0:X8}" -f $_.Codes}} |
            Select-Object -ExpandProperty Codes
    }

    foreach ($code in $AssignmentCodes) {
        It "Tests $code" {
            $code | ConvertFrom-FslAssignmentCode | ConvertTo-FslAssignmentCode | Should Be $code
        }
    }

}