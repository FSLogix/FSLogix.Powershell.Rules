function Compare-FslRuleFile {
    [CmdletBinding()]

    Param (
        [Parameter(
            Position = 0,
            ValuefromPipelineByPropertyName = $true,
            ValuefromPipeline = $true,
            Mandatory = $true
        )]
        [System.String[]]$Path,

        [Parameter(
            Position = 0,
            ValuefromPipelineByPropertyName = $true,
            Mandatory = $false
        )]
        [System.String]$OutputPath
    )

    BEGIN {
        Set-StrictMode -Version Latest
    } # Begin
    PROCESS {

        foreach ($filepath in $Path) {
            if (-not (Test-Path $file)){
                Write-Error "$filepath does not exist"
            }
            else{
                $rules = Get-FslRule $filepath
                
            }

        }
    } #Process
    END {} #End
}  #function Compare-FslRuleFile