function ConvertFrom-FslAssignmentCode {
    [CmdletBinding()]

    Param (
        [Parameter(
            Position = 0,
            ValuefromPipelineByPropertyName = $true,
            ValuefromPipeline = $true,
            Mandatory = $true
        )]
        [Int]$AssignmentCode
    )

    BEGIN {
        Set-StrictMode -Version Latest
        $Apply                      = 0x0001
        $Remove                     = 0x0002
        $User                       = 0x0004
        $Process                    = 0x0008
        $Group                      = 0x0010
        $Network                    = 0x0020
        $Computer                   = 0x0040
        $ADDistinguishedName        = 0x0080
        $ApplyToProcessChildren     = 0x0100
        #$ProcessID                  = 0x0200
        $EnvironmentVariable        = 0x2000
        #$MandatoryLevelShift        = 10
        #$MandatoryLevelMask         = 0x1C00

    } # Begin
    PROCESS {
        $output = [PSCustomObject]@{
            'Apply'                  = if ( $AssignmentCode -band $Apply ) { $true } else { $false }
            'Remove'                 = if ( $AssignmentCode -band $Remove ) { $true } else { $false }
            'User'                   = if ( $AssignmentCode -band $User ) { $true } else { $false }
            'Process'                = if ( $AssignmentCode -band $Process ) { $true } else { $false }
            'Group'                  = if ( $AssignmentCode -band $Group ) { $true } else { $false }
            'Network'                = if ( $AssignmentCode -band $Network ) { $true } else { $false }
            'Computer'               = if ( $AssignmentCode -band $Computer ) { $true } else { $false }
            'ADDistinguishedName'    = if ( $AssignmentCode -band $ADDistinguishedName ) { $true } else { $false }
            'ApplyToProcessChildren' = if ( $AssignmentCode -band $ApplyToProcessChildren ) { $true } else { $false }
            #'ProcessId'              = if ( $AssignmentCode -band $ProcessID ) { $true } else { $false } #Can't get the GUI to produce a pid code
            'EnvironmentVariable'    = if ( $AssignmentCode -band $EnvironmentVariable ) { $true } else { $false }

            #The Mandatory bits are in the original code, but not used
            #'MandatoryLevelShift'    = if ( $AssignmentCode -band $MandatoryLevelShift ) { $true } else { $false }
            #'MandatoryLevelMask'     = if ( $AssignmentCode -band $MandatoryLevelMask ) { $true } else { $false }
        }

        Write-Output $output

    } #Process
    END {} #End
}  #function ConvertFrom-FslAssignmentCode