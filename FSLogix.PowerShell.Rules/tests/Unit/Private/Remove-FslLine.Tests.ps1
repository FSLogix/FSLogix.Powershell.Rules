$here = Split-Path -Parent $MyInvocation.MyCommand.Path
$global:sut = (Split-Path -Leaf $MyInvocation.MyCommand.Path) -replace '\.Tests\.', '.'
$global:here = $here | Split-Path -Parent | Split-Path -Parent | Split-Path -Parent

Import-Module -Name (Join-Path $global:here 'FSLogix.PowerShell.Rules.psd1') -Force

Describe $global:sut.TrimEnd('.ps1') -Tag 'Unit' {

    InModuleScope 'FSLogix.PowerShell.Rules' {

        $assignFile = 'TestDrive:\Assign.fxa'

        Copy-Item -Path (Join-Path  $here 'tests\QA\TestFiles\AllAssign\Assign.fxa') $assignFile

        $script:lineCount = (Get-Content -Path $assignFile).count

        It 'Removes an assignment by User Name' {
            Remove-FslLine -Path $assignFile -Category UserName -Name Jim -Type Assignment
            $newLineCount = (Get-Content -Path $assignFile).count
            $script:lineCount - $newLineCount | Should -Be 1
            $script:lineCount = $newLineCount
        }

        It 'Removes an assignment by Group Name' {
            Remove-FslLine -Path $assignFile -Category GroupName -Name Everyone -Type Assignment
            $newLineCount = (Get-Content -Path $assignFile).count
            $script:lineCount - $newLineCount | Should -Be 1
            $script:lineCount = $newLineCount
        }

        It 'Removes an assignment by Process Name' {
            Remove-FslLine -Path $assignFile -Category ProcessName -Name 'C:\Windows\System32\SnippingTool.exe' -Type Assignment
            $newLineCount = (Get-Content -Path $assignFile).count
            $script:lineCount - $newLineCount | Should -Be 1
            $script:lineCount = $newLineCount
        }

        It 'Removes an assignment by IP Address' {
            Remove-FslLine -Path $assignFile -Category IPAddress -Name '192.168.1.79' -Type Assignment
            $newLineCount = (Get-Content -Path $assignFile).count
            $script:lineCount - $newLineCount | Should -Be 1
            $script:lineCount = $newLineCount
        }

        It 'Removes an assignment by Computer Name' {
            Remove-FslLine -Path $assignFile -Category ComputerName -Name 'laptop@jimdom' -Type Assignment
            $newLineCount = (Get-Content -Path $assignFile).count
            $script:lineCount - $newLineCount | Should -Be 1
            $script:lineCount = $newLineCount
        }

        It 'Removes an assignment by OU' {
            Remove-FslLine -Path $assignFile -Category OU -Name 'jimou2' -Type Assignment
            $newLineCount = (Get-Content -Path $assignFile).count
            $script:lineCount - $newLineCount | Should -Be 1
            $script:lineCount = $newLineCount
        }

        It 'Removes an assignment by Environment Variable' {
            Remove-FslLine -Path $assignFile -Category EnvironmentVariable -Name 'encjim2=valjim2' -Type Assignment
            $newLineCount = (Get-Content -Path $assignFile).count
            $script:lineCount - $newLineCount | Should -Be 1
            $script:lineCount = $newLineCount
        }
    }
}