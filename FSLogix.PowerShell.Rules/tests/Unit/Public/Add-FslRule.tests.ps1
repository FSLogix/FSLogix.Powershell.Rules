$here = Split-Path -Parent $MyInvocation.MyCommand.Path
#$funcType = Split-Path $here -Leaf
$sut = (Split-Path -Leaf $MyInvocation.MyCommand.Path) -replace '\.Tests\.', '.'
$here = $here | Split-Path -Parent | Split-Path -Parent | Split-Path -Parent
#. "$here\$funcType\$sut"

Import-Module -Name (Join-Path $here 'FSLogix.PowerShell.Rules.psd1') -Force

Describe "$($sut.Replace('.ps1',''))" -Tag 'Unit' {

    InModuleScope FSLogix.PowerShell.Rules {

        Context -Name 'Output' {

            Mock ConvertTo-FslRuleCode { '0x00000222' }
            Mock Add-Content { $null } -ParameterFilter { $Encoding -and $Encoding -eq 'Unicode' }

            BeforeAll {
                [Diagnostics.CodeAnalysis.SuppressMessageAttribute("PSUseDeclaredVarsMoreThanAssignments", "")]
                $AddfslRuleParams = @{
                    RuleFilePath = 'Testdrive:\temprule.fxr'
                    FullName     = 'Testdrive:\madeup.txt'
                    HidingType   = 'FileOrValue'
                }
            }

            It 'Does not throw' {
                { Add-FslRule @AddfslRuleParams } | should not throw
            }
            It 'Does not return an object' {
                ( Add-FslRule @AddfslRuleParams | Measure-Object ).Count | Should Be 0
            }
            It 'Returns an object from passthru' {
                $result = Add-FslRule @AddfslRuleParams -Passthru
                $result.Count | Should BeLessThan 7
                $result.Count | Should BeGreaterThan 2
            }
            It 'Returns Some Verbose lines' {
                $verboseLine = Add-FslRule @AddfslRuleParams  -Verbose 4>&1
                $verboseLine.count | Should BeGreaterThan 0
            }
        }

        Context 'Pipeline' {

            #Mock ConvertTo-FslRuleCode { '0x00000221' }
            Mock Add-Content { $null } -ParameterFilter { $Encoding -and $Encoding -eq 'Unicode' }

            BeforeAll {
                [Diagnostics.CodeAnalysis.SuppressMessageAttribute("PSUseDeclaredVarsMoreThanAssignments", "")]
                $AddfslRuleParams = @{
                    RuleFilePath = 'Testdrive:\madeup.fxr'
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
                    HidingType   = 'FileOrValue'
                    passthru     = $true
                    Comment      = 'Test'
                    FullName     = 'Testdrive:\madeup.txt'
                }

                $return = $pipeObject | Add-FslRule
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
        Context 'Logic' {
        
            It "Takes Specify Value String Params Correctly" {
                $AddFslRuleParams = @{
                    FullName     = 'HKCU\Software\FSLogix\Test'
                    RegValueType = 'String'
                    ValueData    = 'ChangedByPowerShell'
                    RuleFilePath = 'TestDrive:\SpecifyValue.fxr'
                }
                Add-FslRule @AddFslRuleParams
            }

            It "Takes Specify Value Dword Params Correctly" {
                $AddFslRuleParams = @{
                    FullName     = 'HKCU\Software\FSLogix\Test'
                    RegValueType = 'Dword'
                    ValueData    = 2000
                    RuleFilePath = 'TestDrive:\SpecifyValue.fxr'
                }
                Add-FslRule @AddFslRuleParams
            }

            It "Takes Specify Value Qword Params Correctly" {
                $AddFslRuleParams = @{
                    FullName     = 'HKCU\Software\FSLogix\Test'
                    RegValueType = 'Qword'
                    ValueData    = 6679678969868
                    RuleFilePath = 'TestDrive:\SpecifyValue.fxr'
                }
                Add-FslRule @AddFslRuleParams
            }

            It "Takes Specify Value Multi-String Params Correctly" {
                $AddFslRuleParams = @{
                    FullName     = 'HKCU\Software\FSLogix\Test'
                    RegValueType = 'Multi-String'
                    ValueData    = 'One', 'Two', 'Three', 'Four'
                    RuleFilePath = 'TestDrive:\SpecifyValue.fxr'
                }
                Add-FslRule @AddFslRuleParams
            }

            It "Takes Specify Value ExpandableString Params Correctly" {
                $AddFslRuleParams = @{
                    FullName     = 'HKCU\Software\FSLogix\Test'
                    RegValueType = 'ExpandableString'
                    ValueData    = '%PATH%'
                    RuleFilePath = 'TestDrive:\SpecifyValue.fxr'
                }
                Add-FslRule @AddFslRuleParams
            }

        }
    }
}