function Compare-FslFilePath {
    [CmdletBinding()]

    Param (
        [Parameter(
            Position = 0,
            ValuefromPipelineByPropertyName = $true,
            ValuefromPipeline = $true,
            Mandatory = $true
        )]
        [System.Array[]]$Files,

        [Parameter(
            Position = 0,
            ValuefromPipelineByPropertyName = $true
        )]
        [System.String]$OutputPath = "$PSScriptRoot"
    )

    BEGIN {
        Set-StrictMode -Version Latest
    } # Begin
    PROCESS {


        foreach ($filepath in $Files) {
            if (-not (Test-Path $filepath)){
                Write-Error "$filepath does not exist"
                exit
            }
        }

        $allFiles = @()
        foreach ($filepath in $Files){
            $appFiles = ( Import-Clixml $filepath ).FullName
            $allfiles += $appFiles
        }

        $dupes = $allFiles | Group-Object | Where-Object { $_.Count -gt 1 } | Select-Object -ExpandProperty Name


        foreach ($filepath in $Files){

            $baseFileName = $filepath | Get-ChildItem | Select-Object -ExpandProperty BaseName

            $newFileName = "$($baseFileName)_UniqueHiding.fxr"

            $currentAppFiles = ( Import-Clixml $filepath ).FullName

            $uniqueFiles =  $currentAppFiles | Where-Object { $dupes -notcontains $_ }

            $uniqueFiles | Set-FslRule -HidingType FileOrValue -RuleFilePath ( Join-Path $OutputPath $newFileName )

        }

    } #Process
    END {} #End
}  #function Compare-FslFilePath