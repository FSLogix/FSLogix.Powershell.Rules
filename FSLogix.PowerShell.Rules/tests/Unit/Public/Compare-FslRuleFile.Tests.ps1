$here = Split-Path -Parent $MyInvocation.MyCommand.Path
$global:sut = (Split-Path -Leaf $MyInvocation.MyCommand.Path) -replace '\.Tests\.', '.'
$global:here = $here | Split-Path -Parent | Split-Path -Parent | Split-Path -Parent

Import-Module -Name (Join-Path $global:here 'FSLogix.PowerShell.Rules.psd1') -Force

InModuleScope 'FSLogix.PowerShell.Rules' {

    Describe $global:sut.Trimend('.ps1') -Tag 'Unit' {

        AfterAll {
            Remove-Variable -Name 'here' -Scope Global
            Remove-Variable -Name 'sut' -Scope Global
        }

        BeforeAll {
            [Diagnostics.CodeAnalysis.SuppressMessageAttribute("PSUseDeclaredVarsMoreThanAssignments", "")]
            $files = (Get-ChildItem $global:here\Tests\QA\TestFiles\CustomerSamples\Office2016).FullName #  "TestDrive:\VisioNotExist.fxr", "TestDrive:\ProjectNotExist.fxr", "TestDrive:\OfficeNotExist.fxr"
        }
        <#

        Mock -CommandName Get-FslRule -MockWith {
            $1 = [PSCustomObject]@{
                FullName = 'HKLM\Software\Wow6432Node\Microsoft\Office\Outlook\Addins\UmOutlookAddin.FormRegionAddin\'
                HidingType = 'FolderOrKey'
                Comment = 'Microsoft Office Add-in'
                Flags = '0x00000221'
            }
            $2 = [PSCustomObject]@{
                FullName = 'HKLM\Software\Wow6432Node\Microsoft\Office\Outlook\Addins\OscAddin.Connect\'
                HidingType = 'FolderOrKey'
                Comment = 'Microsoft Office Add-in'
                Flags = '0x00000221'
            }

            Write-Output $1
            Write-Output $2
        } -Verifiable -ParameterFilter  {$path -eq $files[0] }

        Mock -CommandName Get-FslRule -MockWith {
            $1 = [System.Management.Automation.PSCustomObject]@{
                FullName = 'HKLM\Software\Wow6432Node\Microsoft\Office\Outlook\Addins\UmOutlookAddin.FormRegionAddin\'
                HidingType = 'FolderOrKey'
                Comment = 'Microsoft Office Add-in'
                Flags = '0x00000221'
            }
            $2 = [System.Management.Automation.PSCustomObject]@{
                FullName = 'HKLM\Software\Wow6432Node\Microsoft\Office\Outlook\Addins\OneNote.OutlookAddin\'
                HidingType = 'FolderOrKey'
                Comment = 'Microsoft Office Add-in'
                Flags = '0x00000221'
            }
            $lines = $1, $2
            Write-Output $lines
        } -Verifiable -ParameterFilter { $path -eq $files[1] }

        Mock -CommandName Get-FslRule -MockWith {
            $1 = [System.Management.Automation.PSCustomObject]@{
                FullName = 'HKLM\Software\Wow6432Node\Microsoft\Office\Outlook\Addins\UmOutlookAddin.FormRegionAddin\'
                HidingType = 'FolderOrKey'
                Comment = 'Microsoft Office Add-in'
                Flags = '0x00000221'
            }
            $2 = [System.Management.Automation.PSCustomObject]@{
                FullName = 'HKLM\SOFTWARE\Wow6432Node\Classes\CLSID\{816146B0-DFD0-42F8-9C9C-F872842903B3}\'
                HidingType = 'FolderOrKey'
                Comment = 'COM Object'
                Flags = '0x00000221'
            }
            $lines = $1, $2
            Write-Output $lines
        } -Verifiable -ParameterFilter { $path -eq $files[2] }



        Mock -CommandName Get-ChildItem -MockWith {
            [PSCustomObject]@{
                BaseName = 'VisioNotExist'
            }
        } -Verifiable -ParameterFilter { $path -eq $files[0] }

        Mock -CommandName Get-ChildItem -MockWith {
            [PSCustomObject]@{
                BaseName = 'ProjectNotExist'
            }
        } -Verifiable -ParameterFilter { $path -eq $files[1] }

        Mock -CommandName Get-ChildItem -MockWith {
            [PSCustomObject]@{
                BaseName = 'OfficeNotExist'
            }
        } -Verifiable -ParameterFilter { $path -eq $files[2] }

        #>

        Context 'Return values' {

            Mock -CommandName Set-FslRule -MockWith {} -Verifiable
            Mock -CommandName Test-Path -MockWith { $true } -Verifiable

            It 'Should Not Throw' {

                { Compare-FslRuleFile -Files $files -OutputPath TestDrive:\ }  | Should Not Throw
            }

            It 'Returns no object' {
                ($return | Measure-Object).Count | Should Be 0
            }

            It 'Calls all Verifiable Mocks' {
                Assert-VerifiableMock
            }
        }


    }


}