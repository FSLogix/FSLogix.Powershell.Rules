$here = Split-Path -Parent $MyInvocation.MyCommand.Path
#$funcType = Split-Path $here -Leaf
$sut = (Split-Path -Leaf $MyInvocation.MyCommand.Path) -replace '\.Tests\.', '.'
$here = $here | Split-Path -Parent | Split-Path -Parent | Split-Path -Parent
#. "$here\$funcType\$sut"

Import-Module -Name (Join-Path $here 'FSLogix.PowerShell.Rules.psd1') -Force

InModuleScope 'FSLogix.PowerShell.Rules' -Tag 'Unit' {

    Describe $sut.Trimend('.ps1') {

        Mock Test-Path -MockWith { $true } -Verifiable

        Context 'Mocks and throws' {
            BeforeAll {
                [Diagnostics.CodeAnalysis.SuppressMessageAttribute("PSUseDeclaredVarsMoreThanAssignments", "")]
                $assignment = '1	0', '0x00000011	S-1-5-32-551		BUILTIN\Backup Operators	0	0'
            }

            Mock Get-Content -MockWith { $assignment } -ParameterFilter { -not $TotalCount } -Verifiable

            It 'Does not throw' {
                { Get-FslAssignment -Path TestDrive:\Notexist.fxa } | Should Not Throw
            }

            It 'Calls all Verifiable Mocks' {
                Assert-VerifiableMocks
            }
        }

        Context 'Group' {
            BeforeAll {
                [Diagnostics.CodeAnalysis.SuppressMessageAttribute("PSUseDeclaredVarsMoreThanAssignments", "")]
                $assignment = '1	0', '0x00000011	S-1-5-32-551		BUILTIN\Backup Operators	0	0'
            }

            Mock Get-Content -MockWith { $assignment } -ParameterFilter { -not $TotalCount } -Verifiable

            It 'Returns Correct Flags for Group' {
                $result = Get-FslAssignment -Path TestDrive:\Notexist.fxa
                $result.RuleSetApplies | Should Be $true
                $result.GroupName | Should Be 'BUILTIN\Backup Operators'
                $result.GroupSID | Should Be 'S-1-5-32-551'
                <#$result.UserName | Should Be $false
                $result.ProcessName | Should Be $false
                $result.IncludeChildProcess | Should Be $false
                $result.ProcessId | Should Be $false
                $result.IPAddress | Should Be $false
                $result.ComputerName | Should Be $false
                $result.OU | Should Be $false
                $result.EnvironmentVariable | Should Be $false
                $result.LicenseDays | Should Be 0#>
            }
            It 'Calls all Verifiable Mocks' {
                Assert-VerifiableMocks
            }
        } #Group

        Context 'User' {
            BeforeAll {
                [Diagnostics.CodeAnalysis.SuppressMessageAttribute("PSUseDeclaredVarsMoreThanAssignments", "")]
                $assignment = '1	0', '0x00000005	Jim		Jim	0	0'
            }

            Mock Get-Content -MockWith { $assignment } -ParameterFilter { -not $TotalCount } -Verifiable

            It 'Returns Correct Flags for User' {
                $result = Get-FslAssignment -Path TestDrive:\Notexist.fxa
                $result.RuleSetApplies | Should Be $true
                #$result.GroupName | Should Be 'BUILTIN\Backup Operators'
                #$result.GroupSID | Should Be 'S-1-5-32-551'
                $result.UserName | Should Be 'Jim'
                #$result.ProcessName | Should Be $false
                #$result.IncludeChildProcess | Should Be $false
                #$result.ProcessId | Should Be $false
                #$result.IPAddress | Should Be $false
                #$result.ComputerName | Should Be $false
                #$result.OU | Should Be $false
                #$result.EnvironmentVariable | Should Be $false
                #$result.LicenseDays | Should Be 0#>
            }
            It 'Calls all Verifiable Mocks' {
                Assert-VerifiableMocks
            }
        } #User

        Context 'Process' {
            BeforeAll {
                [Diagnostics.CodeAnalysis.SuppressMessageAttribute("PSUseDeclaredVarsMoreThanAssignments", "")]
                $assignment = '1	0', '0x00000109	C:\Windows\System32\xcopy.exe			0	0'
            }

            Mock Get-Content -MockWith { $assignment } -ParameterFilter { -not $TotalCount } -Verifiable


            It 'Returns Correct Flags for Process' {
                $result = Get-FslAssignment -Path TestDrive:\Notexist.fxa
                $result.RuleSetApplies | Should Be $true
                #$result.GroupName | Should Be 'BUILTIN\Backup Operators'
                #$result.GroupSID | Should Be 'S-1-5-32-551'
                #$result.UserName | Should Be 'Jim'
                $result.ProcessName | Should Be 'C:\Windows\System32\xcopy.exe'
                $result.IncludeChildProcess | Should Be $true
                #$result.ProcessId | Should Be $false
                #$result.IPAddress | Should Be $false
                #$result.ComputerName | Should Be $false
                #$result.OU | Should Be $false
                #$result.EnvironmentVariable | Should Be $false
                #$result.LicenseDays | Should Be 0#>
            }
            It 'Calls all Verifiable Mocks' {
                Assert-VerifiableMocks
            }
        } #Process

        Context 'Network' {
            BeforeAll {
                [Diagnostics.CodeAnalysis.SuppressMessageAttribute("PSUseDeclaredVarsMoreThanAssignments", "")]
                $assignment = '1	0', '0x00000021	192.168.1.78			0	0'
            }

            Mock Get-Content -MockWith { $assignment } -ParameterFilter { -not $TotalCount } -Verifiable


            It 'Returns Correct Flags for Network' {
                $result = Get-FslAssignment -Path TestDrive:\Notexist.fxa
                $result.RuleSetApplies | Should Be $true
                #$result.GroupName | Should Be 'BUILTIN\Backup Operators'
                #$result.GroupSID | Should Be 'S-1-5-32-551'
                #$result.UserName | Should Be 'Jim'
                #$result.ProcessName | Should Be 'C:\Windows\System32\xcopy.exe'
                #$result.IncludeChildProcess | Should Be $true
                #$result.ProcessId | Should Be $false
                $result.IPAddress | Should Be '192.168.1.78'
                #$result.ComputerName | Should Be $false
                #$result.OU | Should Be $false
                #$result.EnvironmentVariable | Should Be $false
                #$result.LicenseDays | Should Be 0#>
            }
            It 'Calls all Verifiable Mocks' {
                Assert-VerifiableMocks
            }
        } #Network
    }
}