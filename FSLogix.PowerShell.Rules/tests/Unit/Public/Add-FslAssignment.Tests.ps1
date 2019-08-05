$here = Split-Path -Parent $MyInvocation.MyCommand.Path
#$funcType = Split-Path $here -Leaf
$sut = (Split-Path -Leaf $MyInvocation.MyCommand.Path) -replace '\.Tests\.', '.'
$here = $here | Split-Path -Parent | Split-Path -Parent | Split-Path -Parent
#. "$here\$funcType\$sut"

Import-Module -Name (Join-Path $here 'FSLogix.PowerShell.Rules.psd1') -Force

Describe $sut.Trimend('.ps1') -Tag 'Unit' {

    InModuleScope 'FSLogix.PowerShell.Rules' {

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