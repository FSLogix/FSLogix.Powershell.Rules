function Write-FslFileHidingLine {
    [cmdletbinding()]

    Param (
        [Parameter(
            Position = 0,
            ValuefromPipelineByPropertyName = $true,
            ValuefromPipeline = $true,
            Mandatory = $true,
            ParameterSetName = 'String'
        )]
        [System.String[]]$FilePath,

        [Parameter(
            Position = 1,
            ValuefromPipelineByPropertyName = $true,
            Mandatory = $true
        )]
        [System.String]$OutRedirectFile,

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
        if ($OutAssignmentFile -notlike "*.fxr"){
            Write-Warning 'Rule files should have an fxr extension'
        }
        if (Test-Path $OutRedirectFile) {
            Write-Error 'File Already Exists'
        }
        Add-Content $OutRedirectFile '1' -Encoding Unicode
    }
    PROCESS {

        if ($PSCmdlet.ParameterSetName -eq 'FileInfo') {
            $FilePath = $FileInfoObject.FullName.ToString()
        }
        
        foreach ($path in $FilePath) {

            $childName = Split-Path $path -Leaf
            $parentName = Split-Path $path -Parent
            Add-Content $OutRedirectFile '##Created by Script' -Encoding Unicode
            Add-Content $OutRedirectFile "$parentName`t$childName`t`t`t0x00000222`t" -Encoding Unicode
            
        } # foreach
        
    } # process
    END {}
} #function