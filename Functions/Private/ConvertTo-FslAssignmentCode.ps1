function ConvertTo-FslAssignmentCode {
    [CmdletBinding()]

    Param (
        [Parameter(
            Position = 0,
            ValuefromPipelineByPropertyName = $true
        )]
        [Switch]$Apply,

        [Parameter(
            Position = 0,
            ValuefromPipelineByPropertyName = $true
        )]
        [Switch]$Remove,

        [Parameter(
            Position = 0,
            ValuefromPipelineByPropertyName = $true
        )]
        [Switch]$User,

        [Parameter(
            Position = 0,
            ValuefromPipelineByPropertyName = $true
        )]
        [Switch]$Process,

        [Parameter(
            Position = 0,
            ValuefromPipelineByPropertyName = $true
        )]
        [Switch]$Group,

        [Parameter(
            Position = 0,
            ValuefromPipelineByPropertyName = $true
        )]
        [Switch]$Network,

        [Parameter(
            Position = 0,
            ValuefromPipelineByPropertyName = $true
        )]
        [Switch]$Computer,

        [Parameter(
            Position = 0,
            ValuefromPipelineByPropertyName = $true
        )]
        [Switch]$ADDistinguishedName,

        [Parameter(
            Position = 0,
            ValuefromPipelineByPropertyName = $true
        )]
        [Switch]$ApplyToProcessChildren,

        [Parameter(
            Position = 0,
            ValuefromPipelineByPropertyName = $true
        )]
        [Switch]$Pid,

        [Parameter(
            Position = 0,
            ValuefromPipelineByPropertyName = $true
        )]
        [Switch]$MandatoryLevelMaskBit,

        [Parameter(
            Position = 0,
            ValuefromPipelineByPropertyName = $true
        )]
        [Switch]$EnvironmentVariable,

        [Parameter(
            Position = 0,
            ValuefromPipelineByPropertyName = $true
        )]
        [Switch]$MandatoryLevelShift
    )

    BEGIN {
        Set-StrictMode -Version Latest
        $ApplyBit = 0x0001
        $RemoveBit = 0x0002
        $UserBit = 0x0004
        $ProcessBit = 0x0008
        $GroupBit = 0x0010
        $NetworkBit = 0x0020
        $ComputerBit = 0x0040
        $ADDistinguishedNameBit = 0x0080
        $ApplyToProcessChildrenBit = 0x0100
        $PidBit = 0x0200
        $MandatoryLevelMaskBit = 0x1C00
        $EnvironmentVariableBit = 0x2000
        $MandatoryLevelShiftBit = 10
    } # Begin
    PROCESS {
        $codeToOutput = 0
        switch ($true) {
            $Apply { $codeToOutput = $codeToOutput -bor $ApplyBit }
            $Remove { $codeToOutput = $codeToOutput -bor $RemoveBit }
            $User { $codeToOutput = $codeToOutput -bor $UserBit }
            $Process { $codeToOutput = $codeToOutput -bor $ProcessBit }
            $Group { $codeToOutput = $codeToOutput -bor $GroupBit }
            $Network { $codeToOutput = $codeToOutput -bor $NetworkBit }
            $Computer { $codeToOutput = $codeToOutput -bor $ComputerBit }
            $ADDistinguishedName { $codeToOutput = $codeToOutput -bor $ADDistinguishedNameBit }
            $ApplyToProcessChildren { $codeToOutput = $codeToOutput -bor $ApplyToProcessChildrenBit }
            $Pid { $codeToOutput = $codeToOutput -bor $PidBit }
            $MandatoryLevelMask { $codeToOutput = $codeToOutput -bor $MandatoryLevelMaskBit }
            $EnvironmentVariable { $codeToOutput = $codeToOutput -bor $EnvironmentVariableBit }
            $MandatoryLevelShift { $codeToOutput = $codeToOutput -bor $MandatoryLevelShiftBit }
        }

        #convert code to hex string so it doesn't get outputted as an integer
        $formattedCode = "0x{0:X8}" -f $codeToOutput

        Write-Output $formattedCode

    } #Process
    END {} #End
}  #function ConvertTo-FslAssignmentCode