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
        $output = [PSCustomObject]@{
            'Apply'                  = if ( $ruleCode -band $Apply ) { $true } else { $false }
            'Remove'                 = if ( $ruleCode -band $Remove ) { $true } else { $false }
            'User'                   = if ( $ruleCode -band $User ) { $true } else { $false }
            'Process'                = if ( $ruleCode -band $Process ) { $true } else { $false }
            'Group'                  = if ( $ruleCode -band $Group ) { $true } else { $false }
            'Network'                = if ( $ruleCode -band $Network ) { $true } else { $false }
            'Computer'               = if ( $ruleCode -band $Computer ) { $true } else { $false }
            'ADDistinguishedName'    = if ( $ruleCode -band $ADDistinguishedName ) { $true } else { $false }
            'ApplyToProcessChildren' = if ( $ruleCode -band $ApplyToProcessChildren ) { $true } else { $false }
            'Pid'                    = if ( $ruleCode -band $Pid ) { $true } else { $false }
            'MandatoryLevelMask'     = if ( $ruleCode -band $MandatoryLevelMask ) { $true } else { $false }
            'EnvironmentVariable'    = if ( $ruleCode -band $EnvironmentVariable ) { $true } else { $false }
            'MandatoryLevelShift'    = if ( $ruleCode -band $MandatoryLevelShift ) { $true } else { $false }
        }

        Write-Output $output

    } #Process
    END {} #End
}  #function ConvertFrom-FslAssignmentCode