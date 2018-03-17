. ..\..\Private\ConvertFrom-FslAssignmentCode.ps1
. ..\..\Private\ConvertTo-FslAssignmentCode.ps1

Describe 'Pipeline conversion back and forth' {

    BeforeAll {
        [Diagnostics.CodeAnalysis.SuppressMessageAttribute("PSUseDeclaredVarsMoreThanAssignments", "")]
        $AssignmentCodes = Get-content .\TestFiles\Assign.fxa | 
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