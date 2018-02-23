function Convert-FslToRuleCode {
    [CmdletBinding()]

    Param (
        [Parameter(
            Position = 0,
            ValuefromPipelineByPropertyName = $true
        )]
        [Switch]$FolderOrKey,
        [Parameter(
            Position = 1,
            ValuefromPipelineByPropertyName = $true
        )]
        [Switch]$FileOrValue,
        [Parameter(
            Position = 2,
            ValuefromPipelineByPropertyName = $true
        )]
        [Switch]$ContainsUserVar,
        [Parameter(
            Position = 3,
            ValuefromPipelineByPropertyName = $true
        )]
        [Switch]$CopyObject,
        [Parameter(
            Position = 4,
            ValuefromPipelineByPropertyName = $true
        )]
        [Switch]$Persistent,
        [Parameter(
            Position = 5,
            ValuefromPipelineByPropertyName = $true
        )]
        [Switch]$Redirect,
        [Parameter(
            Position = 6,
            ValuefromPipelineByPropertyName = $true
        )]
        [Switch]$Hiding,
        [Parameter(
            Position = 7,
            ValuefromPipelineByPropertyName = $true
        )]
        [Switch]$HidePrinter,
        [Parameter(
            Position = 8,
            ValuefromPipelineByPropertyName = $true
        )]
        [Switch]$SpecificData,
        [Parameter(
            Position = 9,
            ValuefromPipelineByPropertyName = $true
        )]
        [Switch]$Java,
        [Parameter(
            Position = 10,
            ValuefromPipelineByPropertyName = $true
        )]
        [Switch]$VolumeAutomount,
        [Parameter(
            Position = 11,
            ValuefromPipelineByPropertyName = $true
        )]
        [Switch]$HideFont,
        [Parameter(
            Position = 12,
            ValuefromPipelineByPropertyName = $true
        )]
        [Switch]$Mask
    )

    BEGIN {
        Set-StrictMode -Version Latest
    } # Begin
    PROCESS {
        
    } #Process
    END {} #End
}  #function Convert-FslToRuleCode