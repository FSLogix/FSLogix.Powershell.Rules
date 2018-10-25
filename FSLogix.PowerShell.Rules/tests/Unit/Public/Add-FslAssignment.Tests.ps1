$here = Split-Path -Parent $MyInvocation.MyCommand.Path
#$funcType = Split-Path $here -Leaf
$global:sut = (Split-Path -Leaf $MyInvocation.MyCommand.Path) -replace '\.Tests\.', '.'
$global:here = $here | Split-Path -Parent | Split-Path -Parent | Split-Path -Parent
#. "$here\$funcType\$sut"

Import-Module -Name (Join-Path $global:here 'FSLogix.PowerShell.Rules.psd1') -Force

InModuleScope 'FSLogix.PowerShell.Rules' {

    Describe $global:sut.Trimend('.ps1') -Tag 'Unit' {

        AfterAll {
            Remove-Variable -Name 'here' -Scope Global
            Remove-Variable -Name 'sut' -Scope Global
        }


        It 'Adds a timestamp' {
            $AddFslAssignmentParams = @{
                Path                = 'Testdrive:\Timestamp.fxa'
                EnvironmentVariable = 'CLIENTNAME=PC1'
                PassThru            = $true
            }

            $result = Add-FslAssignment @AddFslAssignmentParams
            $result.AssignedTime | should -Not -BeNullOrEmpty
            [DateTime]::FromFileTime($result.AssignedTime) | should -BeOfType [System.DateTime]
        }

        It 'Does Not Add a timestamp' {
            $AddFslAssignmentParams = @{
                Path                = 'Testdrive:\Timestamp.fxa'
                EnvironmentVariable = 'CLIENTNAME=PC1'
                PassThru            = $true
                RuleSetApplies      = $true
            }

            $result = Add-FslAssignment @AddFslAssignmentParams
            $result.AssignedTime | should -Be 0
        }


    }

}