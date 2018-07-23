<# INSERT HEADER ABOVE #>

#Get public and private function definition files.

#Requires -Version 5.0

$Public  = @( Get-ChildItem -Path $PSScriptRoot\Public\*.ps1 -ErrorAction SilentlyContinue )
$Private = @( Get-ChildItem -Path $PSScriptRoot\Private\*.ps1 -ErrorAction SilentlyContinue )
$Type = @( Get-ChildItem -Path $PSScriptRoot\Types\*.ps1 -ErrorAction SilentlyContinue)

#Dot source the files
Foreach($import in @($Type + $Public + $Private))
{
    Try
    {
        Write-Verbose "Importing $($Import.FullName)"
        . $import.fullname
    }
    Catch
    {
        Write-Error -Message "Failed to import function $($import.fullname): $_"
    }
}

Export-ModuleMember -Function $Public.Basename
<# INSERT FOOTER BELOW #>
