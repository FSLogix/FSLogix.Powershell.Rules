function Set-FslAssignment {
    [CmdletBinding()]

    Param (
        [Parameter(
            Position = 0,
            ValuefromPipelineByPropertyName = $true,
            ValuefromPipeline = $true,
            Mandatory = $true
        )]
        [System.String]$AssignmentFilePath
    )

    BEGIN {
        Set-StrictMode -Version Latest

        #check file has correct filename extension
        if ($AssignmentFilePath -notlike "*.fxa") {
            Write-Warning 'Assignment files should have an fxa extension'
        }
    } # Begin
    PROCESS {

    } #Process
    END {} #End
}  #function Set-FslAssignment