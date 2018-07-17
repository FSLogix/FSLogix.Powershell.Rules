$here = Split-Path -Parent $MyInvocation.MyCommand.Path
$funcType = Split-Path $here -Leaf
$sut = (Split-Path -Leaf $MyInvocation.MyCommand.Path) -replace '\.Tests\.', '.'
$here = $here | Split-Path -Parent | Split-Path -Parent | Split-Path -Parent
. "$here\$funcType\$sut"

Describe ConvertFrom-FslAssignmentCode -Tag 'Unit' {

    Context -Name 'Output' {

        BeforeAll {
            [Diagnostics.CodeAnalysis.SuppressMessageAttribute("PSUseDeclaredVarsMoreThanAssignments", "")]
            $ConvertFromFslAssignmentCodeParams = @{
                AssignmentCode = 0x00000012
            }
        }

        It 'Does not throw' {
            { ConvertFrom-FslAssignmentCode @ConvertFromFslAssignmentCodeParams  } | should not throw
        }
        It 'Returns an object' {
            ( ConvertFrom-FslAssignmentCode @ConvertFromFslAssignmentCodeParams  | Measure-Object ).Count | Should Be 1
        }
        It 'Returns No Verbose lines' {
            $verboseLine = ConvertFrom-FslAssignmentCode @ConvertFromFslAssignmentCodeParams  -Verbose 4>&1
            $verboseLine.count | Should BeNullOrEmpty
        }
    }

    Context 'Pipeline' {

        It 'Accepts values from the pipeline by value' {
            $return = '0x00000012' | ConvertFrom-FslAssignmentCode
            $return | Should BeOfType [PSCustomObject]

        }

        It 'Accepts value from the pipeline by property name' {

            $pipeObject = [PSCustomObject]@{
                AssignmentCode = 0x00000012
            }

            $return = $pipeObject | ConvertFrom-FslAssignmentCode
            $return | Should BeOfType [PSCustomObject]
        }
    }

    Context 'Math testing' {

        It 'Should return correctly from 0x00000012' {
            $return = 0x00000012 | ConvertFrom-FslAssignmentCode

            $return.Apply | Should Be $false
            $return.Remove | Should Be $true
            $return.User | Should Be $false
            $return.Process | Should Be $false
            $return.Group | Should Be $true
            $return.Network | Should Be $false
            $return.Computer | Should Be $false
            $return.ADDistinguishedName | Should Be $false
            $return.ApplyToProcessChildren | Should Be $false
            $return.ProcessID | Should Be $false
            $return.EnvironmentVariable | Should Be $false
        }

        It 'Should return correctly from 0x00000011' {
            $return = 0x00000011 | ConvertFrom-FslAssignmentCode

            $return.Apply | Should Be $true
            $return.Remove | Should Be $false
            $return.User | Should Be $false
            $return.Process | Should Be $false
            $return.Group | Should Be $true
            $return.Network | Should Be $false
            $return.Computer | Should Be $false
            $return.ADDistinguishedName | Should Be $false
            $return.ApplyToProcessChildren | Should Be $false
            $return.ProcessID | Should Be $false
            $return.EnvironmentVariable | Should Be $false
        }

        It 'Should return correctly from 0x00000005' {
            $return = 0x00000005 | ConvertFrom-FslAssignmentCode

            $return.Apply | Should Be $true
            $return.Remove | Should Be $false
            $return.User | Should Be $true
            $return.Process | Should Be $false
            $return.Group | Should Be $false
            $return.Network | Should Be $false
            $return.Computer | Should Be $false
            $return.ADDistinguishedName | Should Be $false
            $return.ApplyToProcessChildren | Should Be $false
            $return.ProcessID | Should Be $false
            $return.EnvironmentVariable | Should Be $false
        }

        It 'Should return correctly from 0x00000006' {
            $return = 0x00000006 | ConvertFrom-FslAssignmentCode

            $return.Apply | Should Be $false
            $return.Remove | Should Be $true
            $return.User | Should Be $true
            $return.Process | Should Be $false
            $return.Group | Should Be $false
            $return.Network | Should Be $false
            $return.Computer | Should Be $false
            $return.ADDistinguishedName | Should Be $false
            $return.ApplyToProcessChildren | Should Be $false
            $return.ProcessID | Should Be $false
            $return.EnvironmentVariable | Should Be $false
        }

        It 'Should return correctly from 0x00000009' {
            $return = 0x00000009 | ConvertFrom-FslAssignmentCode

            $return.Apply | Should Be $true
            $return.Remove | Should Be $false
            $return.User | Should Be $false
            $return.Process | Should Be $true
            $return.Group | Should Be $false
            $return.Network | Should Be $false
            $return.Computer | Should Be $false
            $return.ADDistinguishedName | Should Be $false
            $return.ApplyToProcessChildren | Should Be $false
            $return.ProcessID | Should Be $false
            $return.EnvironmentVariable | Should Be $false
        }

        It 'Should return correctly from 0x0000000a' {
            $return = 0x0000000a | ConvertFrom-FslAssignmentCode

            $return.Apply | Should Be $false
            $return.Remove | Should Be $true
            $return.User | Should Be $false
            $return.Process | Should Be $true
            $return.Group | Should Be $false
            $return.Network | Should Be $false
            $return.Computer | Should Be $false
            $return.ADDistinguishedName | Should Be $false
            $return.ApplyToProcessChildren | Should Be $false
            $return.ProcessID | Should Be $false
            $return.EnvironmentVariable | Should Be $false
        }

        It 'Should return correctly from 0x00000109' {
            $return = 0x00000109 | ConvertFrom-FslAssignmentCode

            $return.Apply | Should Be $true
            $return.Remove | Should Be $false
            $return.User | Should Be $false
            $return.Process | Should Be $true
            $return.Group | Should Be $false
            $return.Network | Should Be $false
            $return.Computer | Should Be $false
            $return.ADDistinguishedName | Should Be $false
            $return.ApplyToProcessChildren | Should Be $true
            $return.ProcessID | Should Be $false
            $return.EnvironmentVariable | Should Be $false
        }

        It 'Should return correctly from 0x0000010a' {
            $return = 0x0000010a | ConvertFrom-FslAssignmentCode

            $return.Apply | Should Be $false
            $return.Remove | Should Be $true
            $return.User | Should Be $false
            $return.Process | Should Be $true
            $return.Group | Should Be $false
            $return.Network | Should Be $false
            $return.Computer | Should Be $false
            $return.ADDistinguishedName | Should Be $false
            $return.ApplyToProcessChildren | Should Be $true
            $return.ProcessID | Should Be $false
            $return.EnvironmentVariable | Should Be $false
        }

        It 'Should return correctly from 0x00000021' {
            $return = 0x00000021 | ConvertFrom-FslAssignmentCode

            $return.Apply | Should Be $true
            $return.Remove | Should Be $false
            $return.User | Should Be $false
            $return.Process | Should Be $false
            $return.Group | Should Be $false
            $return.Network | Should Be $true
            $return.Computer | Should Be $false
            $return.ADDistinguishedName | Should Be $false
            $return.ApplyToProcessChildren | Should Be $false
            $return.ProcessID | Should Be $false
            $return.EnvironmentVariable | Should Be $false
        }

        It 'Should return correctly from 0x00000022' {
            $return = 0x00000022 | ConvertFrom-FslAssignmentCode

            $return.Apply | Should Be $false
            $return.Remove | Should Be $true
            $return.User | Should Be $false
            $return.Process | Should Be $false
            $return.Group | Should Be $false
            $return.Network | Should Be $true
            $return.Computer | Should Be $false
            $return.ADDistinguishedName | Should Be $false
            $return.ApplyToProcessChildren | Should Be $false
            $return.ProcessID | Should Be $false
            $return.EnvironmentVariable | Should Be $false
        }

        It 'Should return correctly from 0x00000041' {
            $return = 0x00000041 | ConvertFrom-FslAssignmentCode

            $return.Apply | Should Be $true
            $return.Remove | Should Be $false
            $return.User | Should Be $false
            $return.Process | Should Be $false
            $return.Group | Should Be $false
            $return.Network | Should Be $false
            $return.Computer | Should Be $true
            $return.ADDistinguishedName | Should Be $false
            $return.ApplyToProcessChildren | Should Be $false
            $return.ProcessID | Should Be $false
            $return.EnvironmentVariable | Should Be $false
        }

        It 'Should return correctly from 0x00000042' {
            $return = 0x00000042 | ConvertFrom-FslAssignmentCode

            $return.Apply | Should Be $false
            $return.Remove | Should Be $true
            $return.User | Should Be $false
            $return.Process | Should Be $false
            $return.Group | Should Be $false
            $return.Network | Should Be $false
            $return.Computer | Should Be $true
            $return.ADDistinguishedName | Should Be $false
            $return.ApplyToProcessChildren | Should Be $false
            $return.ProcessID | Should Be $false
            $return.EnvironmentVariable | Should Be $false
        }

        It 'Should return correctly from 0x00000081' {
            $return = 0x00000081 | ConvertFrom-FslAssignmentCode

            $return.Apply | Should Be $true
            $return.Remove | Should Be $false
            $return.User | Should Be $false
            $return.Process | Should Be $false
            $return.Group | Should Be $false
            $return.Network | Should Be $false
            $return.Computer | Should Be $false
            $return.ADDistinguishedName | Should Be $true
            $return.ApplyToProcessChildren | Should Be $false
            $return.ProcessID | Should Be $false
            $return.EnvironmentVariable | Should Be $false
        }

        It 'Should return correctly from 0x00000082' {
            $return = 0x00000082 | ConvertFrom-FslAssignmentCode

            $return.Apply | Should Be $false
            $return.Remove | Should Be $true
            $return.User | Should Be $false
            $return.Process | Should Be $false
            $return.Group | Should Be $false
            $return.Network | Should Be $false
            $return.Computer | Should Be $false
            $return.ADDistinguishedName | Should Be $true
            $return.ApplyToProcessChildren | Should Be $false
            $return.ProcessID | Should Be $false
            $return.EnvironmentVariable | Should Be $false
        }

        It 'Should return correctly from 0x00002001' {
            $return = 0x00002001 | ConvertFrom-FslAssignmentCode

            $return.Apply | Should Be $true
            $return.Remove | Should Be $false
            $return.User | Should Be $false
            $return.Process | Should Be $false
            $return.Group | Should Be $false
            $return.Network | Should Be $false
            $return.Computer | Should Be $false
            $return.ADDistinguishedName | Should Be $false
            $return.ApplyToProcessChildren | Should Be $false
            $return.ProcessID | Should Be $false
            $return.EnvironmentVariable | Should Be $true
        }

        It 'Should return correctly from 0x00002002' {
            $return = 0x00002002 | ConvertFrom-FslAssignmentCode

            $return.Apply | Should Be $false
            $return.Remove | Should Be $true
            $return.User | Should Be $false
            $return.Process | Should Be $false
            $return.Group | Should Be $false
            $return.Network | Should Be $false
            $return.Computer | Should Be $false
            $return.ADDistinguishedName | Should Be $false
            $return.ApplyToProcessChildren | Should Be $false
            $return.ProcessID | Should Be $false
            $return.EnvironmentVariable | Should Be $true
        }
    }

}