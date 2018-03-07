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
        $Apply = 0x0001
        $Remove = 0x0002
        $User = 0x0004
        $Process = 0x0008
        $Group = 0x0010
        $Network = 0x0020
        $Computer = 0x0040
        $ADDistinguishedName = 0x0080
        $ApplyToProcessChildren = 0x0100
        $Pid = 0x0200
        #There are 6 mandatory levels, from 0 to 5. To keep compatibility we set 0=unassigned / 1=untrusted / 2=Low and so on...
        #We reserve three bits to store the value
        $MandatoryLevelMask = 0x1C00 #bitmask
        $EnvironmentVariable = 0x2000
        $MandatoryLevelShift = 10

    } # Begin
    PROCESS {

    } #Process
    END {} #End
}  #function ConvertFrom-FslAssignmentCode