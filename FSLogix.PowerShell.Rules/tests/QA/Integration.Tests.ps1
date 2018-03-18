. ..\..\Public\Get-FslRule.ps1
. ..\..\Public\Set-FslRule.ps1
. ..\..\Public\Add-FslRule.ps1
. ..\..\Public\Compare-FslRuleFile.ps1
. ..\..\Private\ConvertTo-FslRuleCode.ps1
. ..\..\Private\ConvertFrom-FslRuleCode.ps1

Describe Compare-FslRuleFile {

    BeforeAll{
        [Diagnostics.CodeAnalysis.SuppressMessageAttribute("PSUseDeclaredVarsMoreThanAssignments", "")]
        $outputPath = 'TestDrive:\'
    }

    It 'Produces 6 files' {
        Compare-FslRuleFile -Files .\TestFiles\AppRule_Project2013Pro.fxr, .\TestFiles\AppRule_Office2013.fxr, .\TestFiles\AppRule_Visio2013Pro.fxr -OutputPath $outputPath
        (Get-ChildItem $outputPath).count | Should Be 6
    }

}
