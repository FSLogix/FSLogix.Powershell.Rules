$here = Split-Path -Parent $MyInvocation.MyCommand.Path
$global:sut = (Split-Path -Leaf $MyInvocation.MyCommand.Path) -replace '\.Tests\.', '.'
$global:here = $here | Split-Path -Parent | Split-Path -Parent | Split-Path -Parent

Import-Module -Name (Join-Path $global:here 'FSLogix.PowerShell.Rules.psd1') -Force

Describe $global:sut.TrimEnd('.ps1') {

    InModuleScope 'FSLogix.PowerShell.Rules' {

        Context 'For inmodulescope' {

            AfterAll {
                Remove-Variable -Name 'here' -Scope Global
                Remove-Variable -Name 'sut' -Scope Global
            }

            $path = 'Testdrive:\RemoveTest.fxa'
            $name1 = 'CLIENTNAME=PC1'
            $name2 = 'CLIENTNAME=PC2'

            BeforeEach {
                #Arrange
                Set-FslAssignment -Path $Path -GroupName Everyone -RuleSetApplies
                Set-FslLicenseDay -Path $Path -LicenseDay 90
                Add-FslAssignment -Path $Path -RuleSetApplies -EnvironmentVariable $name1
                Add-FslAssignment -Path $Path -EnvironmentVariable $name2
                Add-FslAssignment -Path $Path -UserName Jim -RuleSetApplies
                Add-FslAssignment -Path $Path -ProcessName 'c:\test.exe'
                Add-FslAssignment -Path $Path -IPAddress '192.168.0.99'
                Add-FslAssignment -Path $Path -ComputerName 'MyLaptop@domain.com'
                Add-FslAssignment -Path $Path -OU 'MyOU'
                #$count = (Get-Content -Path $path).count
            }

            It 'Creates and error when License reassignment rules are violated.' {
                { Remove-FslAssignment -Path $Path -Name $name2 -ErrorAction Stop } | Should -Throw  "License agreement violation detected"
            }

            It 'The unassigned time should not be 0 when force is used' {
                Remove-FslAssignment -Path $Path -Name $name2 -Force
                $assignment = Get-Content -Path $Path -Tail 1
                $assignment.Split("`t")[-1] | Should -Not -Be 0
            }

            It 'The unassigned time should be able to convert to datetime object when force is used' {
                Remove-FslAssignment -Path $Path -Name $name2 -Force
                $assignment = Get-Content -Path $Path -Tail 1
                [datetime]::FromFileTime($assignment.Split("`t")[-1]) | Should -BeOfType [datetime]
            }

            It 'Does not remove a line when License reassignment rules are violated.' {
                Remove-FslAssignment -Path $Path -Name $name2 -ErrorAction SilentlyContinue
                Get-Content -Path $Path | Should -HaveCount $count
            }

            It 'Removes a line when no assigned time is set' {
                Remove-FslAssignment -Path $Path -Name $name1
                Get-Content -Path $Path | Should -HaveCount ($count - 1)
            }

            It 'Does not change Assigned time on remove' {
                $assignmentTime = (Get-FslAssignment -Path $Path | Where-Object { $_.EnvironmentVariable -eq $name2 }).AssignedTime
                Remove-FslAssignment -Path $Path -Name $name2 -Force
                $newTime = (Get-FslAssignment -Path $Path | Where-Object { $_.EnvironmentVariable -eq $name2 }).AssignedTime
                $assignmentTime | Should -Be $newTime
            }

            It 'Removes a User Name assignment' {
                Remove-FslAssignment -Path $Path -Name Jim
                Get-Content -Path $Path | Should -HaveCount ($count - 1)
            }

            It 'Removes a Group Name assignment' {
                Remove-FslAssignment -Path $Path -Name Everyone
                Get-Content -Path $Path | Should -HaveCount ($count - 1)
            }

            It 'Removes a Process Name assignment' {
                Remove-FslAssignment -Path $Path -Name 'C:\test.exe'
                Get-Content -Path $Path | Should -HaveCount ($count - 1)
            }

            It 'Removes a IPAddress assignment' {
                Remove-FslAssignment -Path $Path -Name '192.168.0.99'
                Get-Content -Path $Path | Should -HaveCount ($count - 1)
            }

            It 'Removes a Computername assignment' {
                Remove-FslAssignment -Path $Path -Name 'MyLaptop@domain.com'
                Get-Content -Path $Path | Should -HaveCount ($count - 1)
            }

            It 'Removes a OU assignment' {
                Remove-FslAssignment -Path $Path -Name 'MyOU'
                Get-Content -Path $Path | Should -HaveCount ($count - 1)
            }
        }
    }
}