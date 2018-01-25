$here = Split-Path -Parent $MyInvocation.MyCommand.Path
$here = Split-Path $here
$sut = (Split-Path -Leaf $MyInvocation.MyCommand.Path) -replace '\.Tests\.', '.'
. "$here\$sut"

Describe "Add-FslNewRuleFile" {
    BeforeAll {

        $visRul = Get-Content "..\..\TestFiles\AppRule_Office2013.fxr"
        $hideRul = Get-Content "..\..\TestFiles\AppRule_Project2013Pro.fxr"
        $outHid = "TESTDRIVE:\Test_Hiding.fxr"
        $outRed = "TESTDRIVE:\Test_Redirect.fxr"
        $appName = 'Project2013Pro'

        $AddFslNewRuleFile = @{
            VisibleAppHidingRule = $visRul
            HidableAppHidingRule = $hideRul
            OutHidingFile        = $outHid
            OutRedirectFile      = $outRed
            AppName              = $appName
        }

        Add-FslNewRuleFile @AddFslNewRuleFile
    }

    It 'New Hiding File should exist' {
        Test-Path $outHid | Should Be $true
    }
    It 'New Redirect File should exist' {
        Test-Path $outRed | Should Be $true
    }
}