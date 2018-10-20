function Remove-FslAssignment {
    [CmdletBinding()]

    Param (
        [Parameter(
            Position = 0,
            ValuefromPipelineByPropertyName = $true,
            ValuefromPipeline = $true,
            Mandatory = $true
        )]
        [alias('AssignmentFilePath')]
        [System.String]$Path,

        [Parameter(
            ValuefromPipelineByPropertyName = $true,
            Mandatory = $true
        )]
        [alias('FullName')]
        [System.String]$Name
    )

    BEGIN {
        Set-StrictMode -Version Latest
    } # Begin
    PROCESS {

        Test-Path -Path $Path -ErrorAction Stop

        if ($Path -notlike "*.fxa") {
            Write-Warning 'Assignment files should have an fxa extension'
        }

        $assignments = Get-FslAssignment -Path $Path


        
    } #Process
    END {} #End
}  #function Remove-FslAssignment