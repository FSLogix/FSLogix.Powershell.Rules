$here = Split-Path -Parent $MyInvocation.MyCommand.Path
$here = Split-Path $here
$sut = (Split-Path -Leaf $MyInvocation.MyCommand.Path) -replace '\.Tests\.', '.'
. "$here\$sut"

Describe Add-FSlRule {
    
    Context -Name 'Output' {
        . ..\..\Private\ConvertTo-FslRuleCode.ps1
        Mock ConvertTo-FslRuleCode {'0x00000222'}
        Mock Add-Content { $null } -ParameterFilter { $Encoding -and $Encoding -eq 'Unicode' }

        BeforeAll{
            [Diagnostics.CodeAnalysis.SuppressMessageAttribute("PSUseDeclaredVarsMoreThanAssignments", "")]
            $AddfslRuleParams = @{
                RuleFilePath = 'Testdrive:\temprule.fxr'
                FullName = 'Testdrive:\madeup.txt'
                HidingType = 'File'
            }
        }

        It 'Does not throw' {
            { Add-FslRule @AddfslRuleParams  } | should not throw
        }
        It 'Does not return an object' {
            ( Add-FslRule @AddfslRuleParams  | Measure-Object ).Count | Should Be 0
        }
        It 'Returns an object from passthru' {
            $result = Add-FslRule @AddfslRuleParams  -Passthru
            $result.Count | Should BeLessThan 7
            $result.Count | Should BeGreaterThan 2
        }
        It 'Returns Some Verbose lines'{
            $verboseLine = Add-FslRule @AddfslRuleParams  -Verbose 4>&1
            $verboseLine.count | Should BeGreaterThan 0
        }
    }

}