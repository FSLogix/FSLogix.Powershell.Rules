function Add-FslJavaAssignment {
    [CmdletBinding(PositionalBinding)]

    Param (
        [Parameter(
            ValuefromPipelineByPropertyName = $true,
            ValuefromPipeline = $true,
            Mandatory = $true
        )]
        [System.String]$StringVar
    )

    BEGIN {
        Set-StrictMode -Version Latest
    } # Begin
    PROCESS {
        
    } #Process
    END {} #End
}  #function Add-FslJavaAssignment