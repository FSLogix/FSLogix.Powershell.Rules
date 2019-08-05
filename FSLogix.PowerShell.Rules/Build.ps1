<# INSERT HEADER ABOVE #>

#Get public and private function definition files.

$fileName = "C:\PoShCode\GitHub\FSLogix.Powershell.Rules\Release\FSLogix.PowerShell.Rules.psm1"

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

        #. $import.fullname
    }
    Catch {
        Write-Error -Message "Failed to import function $($import.fullname): $_"
    }
}
Add-Content -Value '' -Path $fileName

Add-Content -Value "Export-ModuleMember -Function $($Public.Basename)" -Path $fileName