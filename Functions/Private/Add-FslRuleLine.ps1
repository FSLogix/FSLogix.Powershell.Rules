function Add-FslRuleLine {
    [CmdletBinding()]

    Param (
        [Parameter(
            Position = 0,
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
}  #function Add-FslRuleLine