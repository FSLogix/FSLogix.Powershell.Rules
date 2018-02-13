function Add-FslProcessAssignment {
    [CmdletBinding()]

    Param (
        [Parameter(
            Position = 0,
            ValuefromPipelineByPropertyName = $true,
            ValuefromPipeline = $true,
            Mandatory = $true,
            ParameterSetName = 'FileAsArg'
        )]
        [System.String[]]$FileName,

        [Parameter(
            Position = 1,
            ValuefromPipelineByPropertyName = $true,
            Mandatory = $true
        )]
        [System.String]$OutAssignmentFile,

        [Parameter(
            Position = 2,
            ValuefromPipelineByPropertyName = $true,
            ValuefromPipeline = $true,
            Mandatory = $true,
            ParameterSetName = 'FileInfo'
        )]
        [System.IO.FileInfo]$FileInfoObject

    )

    BEGIN {
        Set-StrictMode -Version Latest
        if ($OutAssignmentFile -notlike "*.fxa"){
            Write-Warning 'Assignment files should have an fxa extension'
        }
        if (Test-Path $OutAssignmentFile) {
            Write-Error 'File Already Exists'
        }
        Add-Content $OutAssignmentFile "1`t0" -Encoding Unicode
    } # Begin
    PROCESS {
        if ($PSCmdlet.ParameterSetName -eq 'FileInfo') {
            $FilePath = $FileInfoObject.FullName.ToString()
        }
        
        foreach ($path in $FilePath) {

            Add-Content $OutAssignmentFile '##Created by Script' -Encoding Unicode
            Add-Content $OutAssignmentFile "0x00000109`t$path`t`t`t0`t0" -Encoding Unicode
            
        } # foreach
    } #Process
    END {} #End
}  #function Add-FslProcessAssignment