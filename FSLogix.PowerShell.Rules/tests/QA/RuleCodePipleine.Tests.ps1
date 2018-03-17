. ..\..\Private\ConvertFrom-FslRuleCode.ps1
. ..\..\Private\ConvertTo-FslRuleCode.ps1

Describe 'Pipeline conversion back and forth' {

    BeforeAll {
        [Diagnostics.CodeAnalysis.SuppressMessageAttribute("PSUseDeclaredVarsMoreThanAssignments", "")]
        $ruleCodes = '0x00000221', '0x00000222', '0x00000420', '0x00000122', '0x00000132', '0x00000131', '0x00000121', '0x00000822', '0x00002020'
    }

    foreach ($code in $ruleCodes){
        It "Tests $code"{
            $code | ConvertFrom-FslRuleCode | ConvertTo-FslRuleCode | Should Be $code
        }
    }
    
}