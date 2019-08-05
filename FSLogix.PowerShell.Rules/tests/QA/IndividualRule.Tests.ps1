$here = Split-Path -Parent $MyInvocation.MyCommand.Path
$here = $here | Split-Path -Parent | Split-Path -Parent

Import-Module -Name (Join-Path $here 'FSLogix.PowerShell.Rules.psd1') -Force

Describe 'Checking rules files match when created by parameter' -Tag 'QA' {

    InModuleScope 'FSLogix.PowerShell.Rules' {

        $hideFiles = Join-Path $here "tests\QA\TestFiles\IndividualRulesFromGUI"

        Context "Individual Hiding" {

            It "Hide File" {

                Set-FslRule -Path TestDrive:\HideFile.fxr -FullName D:\JimM\template.vhd -HidingType FileOrValue -Comment 'Hide File'

                $guiFile = Get-Content -Path ( Join-Path $hideFiles 'HideFile.fxr' )
                $poshFile = Get-Content -Path TestDrive:\HideFile.fxr

                Compare-Object -ReferenceObject $guiFile -DifferenceObject $poshFile | Measure-Object | Select-Object -ExpandProperty Count | Should Be 0
            }

            It "Hide Folder" {

                Set-FslRule -Path TestDrive:\HideFolder.fxr -FullName D:\JimM -HidingType FolderOrKey -Comment 'Hide Folder'

                $guiFile = Get-Content -Path ( Join-Path $hideFiles 'HideFolder.fxr' )
                $poshFile = Get-Content -Path TestDrive:\HideFolder.fxr

                Compare-Object -ReferenceObject $guiFile -DifferenceObject $poshFile | Measure-Object | Select-Object -ExpandProperty Count | Should Be 0
            }

            It "Hide Registry Key" {

                Set-FslRule -Path TestDrive:\HideRegistryKey.fxr -FullName HKLM\SOFTWARE\FSLogix -HidingType FolderOrKey -Comment 'Hide Registry Key'

                $guiFile = Get-Content -Path ( Join-Path $hideFiles 'HideRegistryKey.fxr' )
                $poshFile = Get-Content -Path TestDrive:\HideRegistryKey.fxr

                Compare-Object -ReferenceObject $guiFile -DifferenceObject $poshFile | Measure-Object | Select-Object -ExpandProperty Count | Should Be 0
            }

            It "Hide Registry Value" {

                Set-FslRule -Path TestDrive:\HideRegistryValue.fxr -FullName HKLM\SOFTWARE\FSLogix\RuleEditor\Capabilities\FileAssociations\.fxr -HidingType FileOrValue -Comment 'Hide Registry Value'

                $guiFile = Get-Content -Path ( Join-Path $hideFiles 'HideRegistryValue.fxr' )
                $poshFile = Get-Content -Path TestDrive:\HideRegistryValue.fxr

                Compare-Object -ReferenceObject $guiFile -DifferenceObject $poshFile | Measure-Object | Select-Object -ExpandProperty Count | Should Be 0
            }

            It "Hide Font" {

                Set-FslRule -Path TestDrive:\HideFont.fxr -FullName 'Agency FB' -HidingType Font -Comment 'Hide Font'

                $guiFile = Get-Content -Path ( Join-Path $hideFiles 'HideFont.fxr' )
                $poshFile = Get-Content -Path TestDrive:\HideFont.fxr

                Compare-Object -ReferenceObject $guiFile -DifferenceObject $poshFile | Measure-Object | Select-Object -ExpandProperty Count | Should Be 0
            }

            It "Hide Printer" {

                Set-FslRule -Path TestDrive:\HidePrinter.fxr -FullName 'HP Officejet 6300 series' -HidingType Printer -Comment 'Hide Printer'

                $guiFile = Get-Content -Path ( Join-Path $hideFiles 'HidePrinter.fxr' )
                $poshFile = Get-Content -Path TestDrive:\HidePrinter.fxr

                Compare-Object -ReferenceObject $guiFile -DifferenceObject $poshFile | Measure-Object | Select-Object -ExpandProperty Count | Should Be 0
            }
        }

        Context "Individual Redirect" {
            It "File Redirect" {
                Set-FslRule -Path TestDrive:\RedirectFile.fxr -FullName '%SystemDriveFolder%\Users\jsmoy\OneDrive\Documents\FSLogix Rule Sets\HidePrinter.fxa' -RedirectDestPath 'D:\JimM\MyFile1.fxa' -RedirectType FileOrValue -Comment 'Redirect File'

                $guiFile = Get-Content -Path ( Join-Path $hideFiles 'RedirectFile.fxr' )
                $poshFile = Get-Content -Path TestDrive:\RedirectFile.fxr

                Compare-Object -ReferenceObject $guiFile -DifferenceObject $poshFile | Measure-Object | Select-Object -ExpandProperty Count | Should Be 0
            }

            It "Folder Redirect" {
                Set-FslRule -Path TestDrive:\RedirectFolder.fxr -FullName '%SystemDriveFolder%\jimm' -RedirectDestPath 'D:\JimM' -RedirectType FolderOrKey -Comment 'Folder Redirect'

                $guiFile = Get-Content -Path ( Join-Path $hideFiles 'RedirectFolder.fxr' )
                $poshFile = Get-Content -Path TestDrive:\RedirectFolder.fxr

                Compare-Object -ReferenceObject $guiFile -DifferenceObject $poshFile | Measure-Object | Select-Object -ExpandProperty Count | Should Be 0
            }
        }

    }
}