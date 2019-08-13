$here = Split-Path -Parent $MyInvocation.MyCommand.Path

#Get public and private function definition files.

$fileName = Join-Path ($here | Split-Path) "Release\FSLogix.PowerShell.Rules.psm1"
$manifest = Join-Path ($here | Split-Path) "Release\FSLogix.PowerShell.Rules.psd1"

Set-Content -Value '#Requires -Version 5.0' -Path $fileName

$Public = @( Get-ChildItem -Path $PSScriptRoot\functions\Public\*.ps1 -ErrorAction SilentlyContinue )
$Private = @( Get-ChildItem -Path $PSScriptRoot\functions\Private\*.ps1 -ErrorAction SilentlyContinue )

#Dot source the files
Foreach ($import in @($Public + $Private)) {
    Try {
        Write-Verbose "Importing $($Import.FullName)"
        $function = Get-Content $import
        Add-Content -Value $function -Path $fileName
        Add-Content -Value '' -Path $fileName
    }
    Catch {
        Write-Error -Message "Failed to write function $($import.fullname): $_"
    }
}
Add-Content -Value '' -Path $fileName

$functionList = $Public.Basename -join ', '

$currentVersion = (Get-Date -Format yyMM) + '.1'

Update-ModuleManifest -Path $manifest -FunctionsToExport $functionList -ModuleVersion $currentVersion