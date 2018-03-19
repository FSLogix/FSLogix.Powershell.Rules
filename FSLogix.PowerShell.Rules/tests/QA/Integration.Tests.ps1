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

    It 'Produces 6 files' {
        Compare-FslRuleFile -Files .\TestFiles\Office2013\Project2013.fxr, .\TestFiles\Office2013\Office2013.fxr, .\TestFiles\Office2013\Visio2013.fxr -OutputPath $outputPath
        ( Get-ChildItem $outputPath -File ).count | Should Be 12
    }
    
    It 'Produces 4 files' {
        Compare-FslRuleFile -Files .\TestFiles\Office2016\Project2016.fxr, .\TestFiles\Office2016\OfficeProPlus2016.fxr -OutputPath $outputPath
        ( Get-ChildItem $outputPath -File ).count | Should Be 16
    }

}
