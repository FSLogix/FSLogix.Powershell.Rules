$here = Split-Path -Parent $MyInvocation.MyCommand.Path
$funcType = Split-Path $here -Leaf
$sut = (Split-Path -Leaf $MyInvocation.MyCommand.Path) -replace '\.Tests\.', '.'
$here = $here | Split-Path -Parent | Split-Path -Parent | Split-Path -Parent
. "$here\$funcType\$sut"

Describe ConvertTo-FslRuleCode -Tag 'Unit' {

    Context -Name 'Output' {

        BeforeAll {
            [Diagnostics.CodeAnalysis.SuppressMessageAttribute("PSUseDeclaredVarsMoreThanAssignments", "")]
            $convertToFslRuleCode = @{
                FolderOrKey     = $true
                FileOrValue     = $true
                ContainsUserVar = $true
                CopyObject      = $true
                #Persistent = $true
                Redirect        = $true
                Hiding          = $true
                Printer         = $true
                SpecificData    = $true
                Java            = $true
                VolumeAutoMount = $true
                HideFont        = $true
            }
        }

        It 'Does not throw' {
            { ConvertTo-FslRuleCode @AddfslRuleParams  } | should not throw
        }
        It 'Does return an object' {
            ( ConvertTo-FslRuleCode @AddfslRuleParams  | Measure-Object ).Count | Should BeGreaterThan 0
        }

        It 'Returns Some Verbose lines' {
            $verboseLine = ConvertTo-FslRuleCode @AddfslRuleParams -Verbose 4>&1
            $verboseLine.count | Should BeGreaterThan 0
        }
    }

    Context 'Pipeline' {

        It 'Accepts value from the pipeline by property name' {

            $pipeObject = [PSCustomObject]@{
                FolderOrKey     = $true
                FileOrValue     = $true
                CopyObject      = $true
                Redirect        = $true
                Hiding          = $true
                Printer         = $true
                SpecificData    = $true
                Java            = $true
                VolumeAutoMount = $true
                HideFont        = $true
            }

            $return = $pipeObject | ConvertTo-FslRuleCode
            $return | Should Be '0x00007F13'
        }
    }

    Context 'Rule Code Validation' {
        It 'tests' {
            $params = @{
                FolderOrKey     = $true
                FileOrValue     = $true
                CopyObject      = $true
                Redirect        = $true
                Hiding          = $true
                Printer         = $true
                SpecificData    = $true
                Java            = $true
                VolumeAutoMount = $true
                HideFont        = $true
            }
        }
    }
}