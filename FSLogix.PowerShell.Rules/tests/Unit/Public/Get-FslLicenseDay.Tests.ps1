$here = Split-Path -Parent $MyInvocation.MyCommand.Path
$sut = (Split-Path -Leaf $MyInvocation.MyCommand.Path) -replace '\.Tests\.', '.'
$here = $here | Split-Path -Parent | Split-Path -Parent | Split-Path -Parent


Import-Module -Name (Join-Path $here 'FSLogix.PowerShell.Rules.psd1') -Force

InModuleScope 'FSLogix.PowerShell.Rules' {

    Describe $sut.Trimend('.ps1') -Tag 'Unit' {

        It 'Takes Pipline Input'{
            Set-Content -Path Testdrive:\pipe.fxa -Value "1`t0"
            'Testdrive:\pipe.fxa' | Get-FslLicenseDay | Select-Object -ExpandProperty LicenseDay | Should -Be 0
        }

        It 'Has working parameter alias' {
            Set-Content -Path Testdrive:\alias.fxa -Value "1`t20"
            (Get-FslLicenseDay -AssignmentFilePath 'Testdrive:\alias.fxa').LicenseDay | Should -Be 20
        }

        It 'Gets correct License days back'{
            Set-Content -Path Testdrive:\Correct.fxa -Value "1`t90"
            Add-Content -Path Testdrive:\Correct.fxa -Value "Doesn't Matter"
            (Get-FslLicenseDay -Path Testdrive:\Correct.fxa).LicenseDay | Should -Be 90
        }

        It 'Gets correct Warning with bad extension' {
            Set-Content -Path Testdrive:\BadExtension.bad -Value "1`t45"
            Get-FslLicenseDay -Path Testdrive:\BadExtension.bad 3>&1 | Select-Object -First 1 | Should -Be 'Assignment file extension should be .fxa'
        }

        It 'Gets correct Error with bad data' {
            Set-Content -Path Testdrive:\BadData.fxa -Value "Rubbish"
            Get-FslLicenseDay -Path Testdrive:\BadData.fxa 2>&1 | Select-Object -first 1 | Should -Be 'Bad data on first line of Testdrive:\BadData.fxa'
        }

    }

}