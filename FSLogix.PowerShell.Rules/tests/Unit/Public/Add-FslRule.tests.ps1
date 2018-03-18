$here = Split-Path -Parent $MyInvocation.MyCommand.Path
$funcType = Split-Path $here -Leaf
$sut = (Split-Path -Leaf $MyInvocation.MyCommand.Path) -replace '\.Tests\.', '.'
$here = $here | Split-Path -Parent | Split-Path -Parent | Split-Path -Parent 
. "$here\$funcType\$sut"

Describe Add-FSlRule {

    Context -Name 'Output' {
        . "$here\Private\ConvertTo-FslRuleCode.ps1"
        Mock ConvertTo-FslRuleCode {'0x00000222'}
        Mock Add-Content { $null } -ParameterFilter { $Encoding -and $Encoding -eq 'Unicode' }

        BeforeAll{
            [Diagnostics.CodeAnalysis.SuppressMessageAttribute("PSUseDeclaredVarsMoreThanAssignments", "")]
            $AddfslRuleParams = @{
                RuleFilePath = 'Testdrive:\temprule.fxr'
                FullName = 'Testdrive:\madeup.txt'
                HidingType = 'FileOrValue'
            }
        }

        It 'Does not throw' {
            { Add-FslRule @AddfslRuleParams  } | should not throw
        }
        It 'Does not return an object' {
            ( Add-FslRule @AddfslRuleParams  | Measure-Object ).Count | Should Be 0
        }
        It 'Returns an object from passthru' {
            $result = Add-FslRule @AddfslRuleParams -Passthru
            $result.Count | Should BeLessThan 7
            $result.Count | Should BeGreaterThan 2
        }
        It 'Returns Some Verbose lines'{
            $verboseLine = Add-FslRule @AddfslRuleParams  -Verbose 4>&1
            $verboseLine.count | Should BeGreaterThan 0
        }
    }

    Context 'Pipeline' {

        . "$here\Private\ConvertTo-FslRuleCode.ps1"
        #Mock ConvertTo-FslRuleCode { '0x00000221' }
        Mock Add-Content { $null } -ParameterFilter { $Encoding -and $Encoding -eq 'Unicode' }

        BeforeAll{
            [Diagnostics.CodeAnalysis.SuppressMessageAttribute("PSUseDeclaredVarsMoreThanAssignments", "")]
            $AddfslRuleParams = @{
                RuleFilePath = 'Testdrive:\temprule.fxr'
                HidingType   = 'FileOrValue'
                passthru     = $true
                Comment      = 'Test'
            }
        }


        It 'Accepts values from the pipeline by value' {
            $return = 'Testdrive:\madeup.txt' | Add-FslRule @AddfslRuleParams
            Assert-MockCalled Add-Content -Times 2 -Exactly -Scope It
            #Assert-MockCalled ConvertTo-FslRuleCode -Times 1 -Exactly -Scope It
            $return.SourceParent | Should Be 'Testdrive:\'
            $return.Source | Should Be 'madeup.txt'
            $return.DestParent | Should BeNullOrEmpty
            $return.Dest | Should BeNullOrEmpty
            $return.Flags | Should Be '0x00000222'
            $return.binary | Should BeNullOrEmpty
            $return.Comment | Should Be 'Test'

        }

        It 'Accepts value from the pipeline by property name' {

            $pipeObject = [PSCustomObject]@{
                RuleFilePath = 'Testdrive:\temprule.fxr'
                HidingType = 'FileOrValue'
                passthru = $true
                Comment = 'Test'
                FullName = 'Testdrive:\madeup.txt'
            }

            $return =  $pipeObject | Add-FslRule
            Assert-MockCalled Add-Content -Times 2 -Exactly -Scope It
            #Assert-MockCalled ConvertTo-FslRuleCode -Times 1 -Exactly -Scope It
            $return.SourceParent | Should Be 'Testdrive:\'
            $return.Source | Should Be 'madeup.txt'
            $return.DestParent | Should BeNullOrEmpty
            $return.Dest | Should BeNullOrEmpty
            $return.Flags | Should Be '0x00000222'
            $return.binary | Should BeNullOrEmpty
            $return.Comment | Should Be 'Test'
        }
    }

}