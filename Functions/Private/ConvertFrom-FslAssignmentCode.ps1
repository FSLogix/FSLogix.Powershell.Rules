function ConvertFrom-FslAssignmentCode {
    [CmdletBinding()]

    Param (
        [Parameter(
            Position = 0,
            ValuefromPipelineByPropertyName = $true,
            ValuefromPipeline = $true,
            Mandatory = $true
        )]
        [Int]$RuleCode
    )

    BEGIN {
        Set-StrictMode -Version Latest
    } # Begin
    PROCESS {

    } #Process
    END {} #End
}  #function ConvertFrom-FslAssignmentCode