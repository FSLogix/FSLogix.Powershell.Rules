$here = Split-Path -Parent $MyInvocation.MyCommand.Path
$Global:sut = (Split-Path -Leaf $MyInvocation.MyCommand.Path) -replace '\.Tests\.', '.'
$Global:here = $here | Split-Path -Parent | Split-Path -Parent | Split-Path -Parent


Import-Module -Name (Join-Path $Global:here 'FSLogix.PowerShell.Rules.psd1') -Force

InModuleScope 'FSLogix.PowerShell.Rules' {

    Describe $Global:sut.Trimend('.ps1') -Tag 'Unit' {

        AfterAll {
            Remove-Variable -Name 'here' -Scope Global
            Remove-Variable -Name 'sut' -Scope Global        
        }

        It 'Takes String Pipline Input' {
            Set-Content -Path Testdrive:\pipe.fxa -Value "1`t0"
            'Testdrive:\pipe.fxa' | Set-FslLicenseDay -LicenseDay 10
            Get-Content -Path Testdrive:\pipe.fxa -TotalCount 1 | Should -Be "1`t10"
        }

        It 'Takes Int Pipline Input' {
            Set-Content -Path Testdrive:\pipe2.fxa -Value "1`t0"
            20 | Set-FslLicenseDay -Path 'Testdrive:\pipe2.fxa'
            Get-Content -Path Testdrive:\pipe2.fxa -TotalCount 1 | Should -Be "1`t20"
        }

        It 'Takes Positional Input' {
            Set-Content -Path Testdrive:\position.fxa -Value "1`t0"
            Set-FslLicenseDay 'Testdrive:\position.fxa' 40
            Get-Content -Path Testdrive:\position.fxa -TotalCount 1 | Should -Be "1`t40"
        }

        It 'Has working parameter alias' {
            Set-Content -Path Testdrive:\alias.fxa -Value "1`t20"
            Set-FslLicenseDay -AssignmentFilePath 'Testdrive:\alias.fxa' -LicenseDay 0 | Should -BeNullOrEmpty
        }

        It 'Gets correct License days back' {
            Set-Content -Path Testdrive:\Correct.fxa -Value "1`t90"
            Add-Content -Path Testdrive:\Correct.fxa -Value "Doesn't Matter"
            Set-FslLicenseDay -Path Testdrive:\Correct.fxa -LicenseDay 30 
            Get-Content -Path Testdrive:\Correct.fxa -TotalCount 1 | Should -Be "1`t30"
        }

        It 'Gets correct Warning with bad extension' {
            Set-Content -Path Testdrive:\BadExtension.bad -Value "1`t45"
            Get-FslLicenseDay -Path Testdrive:\BadExtension.bad 3>&1 | Select-Object -First 1 | Should -Be 'Assignment file extension should be .fxa'
        }

    }

}